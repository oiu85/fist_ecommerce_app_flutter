# Auth Feature — DDD Design Document

This document describes how to implement the **auth feature** so that login calls the real API and follows the **exact same pattern as the home feature**: domain (repositories, entities/usecases), data (models, repository_impl, data sources, di), presentation (bloc, pages, widgets). API calls go through a DataSource using `NetworkClient`, repository implements the domain interface, BLoC uses a UseCase (no direct repository/API access).

---

## 1. Domain Layer

### 1.1 Responsibility
- Pure Dart; no Flutter/network imports.
- Define the **auth contract** and what “login” returns (token or failure).

### 1.2 Entity (optional)
- **Option A (recommended):** No separate entity; repository and use case return `Either<Failure, String>` where the `String` is the token. Keeps auth minimal and matches “return token or failure.”
- **Option B:** Add `AuthSession` entity with `token` (and optionally `username`) if you want a single place to extend later (e.g. refresh token, expiry). Then repository returns `Either<Failure, AuthSession>`.

Recommendation: **Option A** for the first version; you can introduce `AuthSession` later if needed.

### 1.3 Repository contract
- **File:** `lib/features/auth/domain/repositories/auth_repository.dart`
- **Interface:** `IAuthRepository` (mirror `IProductRepository` naming).
- **Method:**  
  `Future<Either<Failure, String>> login(String username, String password);`  
  - Success: return `Right(token)`.
  - Failure: return `Left(Failure(message: ...))`.
- Use `core/domain/failure.dart` for `Failure` (same as home).
- Use `dartz` for `Either`.

### 1.4 Use case
- **File:** `lib/features/auth/domain/usecases/login_use_case.dart`
- **Class:** `LoginUseCase`.
- **Constructor:** `LoginUseCase(IAuthRepository repository)`.
- **Method:** `Future<Either<Failure, String>> call(String username, String password) => repository.login(username, password);`
- BLoC will use **only** this use case, never the repository or data source directly.

---

## 2. Data Layer

### 2.1 API contract
- **Endpoint:** `POST {{baseUrl}}/auth/login`
- **Body (JSON):** `{ "username": "...", "password": "..." }`
- **Response:** `201` with body `{ "token": "..." }`
- **Base URL:** Same as home — from `ApiConfig.baseUrl`. No separate “auth client”; reuse the same `NetworkClient` (which already uses `ApiConfig.baseUrl`).

### 2.2 ApiConfig
- **File to modify:** `lib/core/config/api_config.dart`
- **Add:**  
  `static const String authLoginPath = '/auth/login';`  
  (relative path, same as `productsPath`, so `NetworkClient` will resolve it against `baseUrl`.)

### 2.3 Auth response model (Freezed)
- **File:** `lib/features/auth/data/models/auth_model.dart`
- **Purpose:** Parse the login response `{ "token": "..." }`.
- **Type:** Freezed + `json_serializable` (same pattern as `ProductModel`).
- **Fields:** `token` (String).
- **Methods:**  
  - `factory AuthModel.fromJson(Map<String, dynamic> json)`.  
  - No `toEntity` required if domain uses `String`; BLoC/use case only need the token string (expose it from the model or return `model.token` in the repository).
- **Code gen:** Add `part 'auth_model.freezed.dart';` and `part 'auth_model.g.dart';`, then run `dart run build_runner build --delete-conflicting-outputs`.

### 2.4 Auth remote data source
- **File:** `lib/features/auth/data/datasources/auth_remote_data_source.dart`
- **Class:** `AuthRemoteDataSource` (mirror `ProductRemoteDataSource`).
- **Constructor:** `AuthRemoteDataSource(NetworkClient client)`.
- **Method:**  
  `Future<Either<NetworkFailure, AuthModel>> login(String username, String password) async`
  - Call `_client.post(ApiConfig.authLoginPath, data: {'username': username, 'password': password})`.
  - On `Left(NetworkFailure)`: return as-is.
  - On `Right(Response)`:  
    - Check status code 201 (optional but recommended).  
    - Parse `response.data` as `Map<String, dynamic>`, then `AuthModel.fromJson(...)`.  
    - On parse error: return `Left(NetworkFailure(message: '...'))`.  
    - On success: return `Right(authModel)`.
- Use `NetworkFailure` and `Either` from the same places as `ProductRemoteDataSource` (`core/network/network_client.dart`, `dartz`).

### 2.5 Auth repository implementation
- **File:** `lib/features/auth/data/repositories/auth_repository_impl.dart`
- **Class:** `AuthRepositoryImpl implements IAuthRepository`.
- **Dependencies:**  
  - `AuthRemoteDataSource _dataSource`  
  - `AppStorageService _storage`
- **Where to save token and set isLoggedIn:**  
  **Inside `AuthRepositoryImpl.login`**, after a successful response from the data source:
  1. Call `_dataSource.login(username, password)`.
  2. If `Left(NetworkFailure nf)`: return `Left(Failure(message: nf.message))`.
  3. If `Right(AuthModel model)`:
     - `await _storage.setAccessToken(model.token);`
     - `await _storage.setLoggedIn(true);`
     - return `Right(model.token)` (or `Right(unit)` if you prefer; then use case would return `Either<Failure, Unit>` and BLoC would only care about success/fail).
- **Rationale:** Persisting the token and login state is part of “completing login” and belongs in the data layer (repository), not in the BLoC or use case. The domain contract stays “login returns token or failure”; the repository implementation is responsible for calling the API and then persisting the result via `AppStorageService`.

### 2.6 Dependency injection (auth feature)
- **File:** `lib/features/auth/data/di.dart`
- **Function:** `void registerAuthDependencies(GetIt sl) { ... }`
- **Registrations (order matters):**
  1. **Data source:**  
     `sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource(sl<NetworkClient>()));`
  2. **Repository:**  
     `sl.registerLazySingleton<IAuthRepository>(() => AuthRepositoryImpl(sl<AuthRemoteDataSource>(), sl<AppStorageService>()));`
  3. **Use case:**  
     `sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl<IAuthRepository>()));`
  4. **BLoC (factory, new instance per screen):**  
     `sl.registerFactory<AuthBloc>(() => AuthBloc(loginUseCase: sl<LoginUseCase>()));`
- **Aggregation:** In `lib/core/di/app_dependencies.dart`, add `import '../features/auth/data/di.dart';` and call `registerAuthDependencies(getIt);` after `registerHomeDependencies(getIt)` (or in the same “feature registration” section).

---

## 3. Presentation Layer

### 3.1 Auth BLoC

- **Events**
  - **File:** `lib/features/auth/presentation/bloc/auth_event.dart`
  - **Event:** `LoginSubmitted` with `username` and `password` (both `String`). Use `Equatable` for equality (same style as `HomeEvent`).

- **State**
  - **File:** `lib/features/auth/presentation/bloc/auth_state.dart`
  - **States:**  
    - **initial** — before any submit.  
    - **loading** — login request in progress.  
    - **success** — login succeeded (token saved by repository; BLoC doesn’t hold token).  
    - **fail** — login failed with a **message** (e.g. `errorMessage: String`).
  - Use the same **BlocStatus** pattern as home: `lib/core/status/bloc_status.dart` (e.g. `BlocStatus.initial()`, `BlocStatus.loading()`, `BlocStatus.success()`, `BlocStatus.fail(error: message)`). State can hold `BlocStatus status` and `String? errorMessage` for fail.

- **BLoC**
  - **File:** `lib/features/auth/presentation/bloc/auth_bloc.dart`
  - **Class:** `AuthBloc extends Bloc<AuthEvent, AuthState>`.
  - **Constructor:** `AuthBloc({required LoginUseCase loginUseCase})`.
  - **Handler:** On `LoginSubmitted`:
    1. Emit state with `status: BlocStatus.loading()` (and clear previous error).
    2. `await _loginUseCase.call(username, password)`.
    3. **On Left(failure):** emit state with `status: BlocStatus.fail(error: failure.message)` and set `errorMessage`.
    4. **On Right(token):** emit state with `status: BlocStatus.success()` (no need to store token in state; persistence is already done in repository).
  - No API or repository calls in BLoC; only `LoginUseCase`.

### 3.2 Login page and UI

- **File to modify:** `lib/features/auth/presentation/pages/login_page.dart`
- **Changes:**
  1. **BlocProvider:** Wrap the page content (or the subtree that needs auth state) with `BlocProvider<AuthBloc>` and create the bloc from `getIt<AuthBloc>()` (or from a parent if you provide it at a higher level). Prefer creating the bloc in the page so it’s disposed when leaving the login screen.
  2. **Dispatch on submit:** When the user taps “Sign in”, instead of the current placeholder logic that sets token and navigates, call:
     - `context.read<AuthBloc>().add(LoginSubmitted(username: _usernameController.text.trim(), password: _passwordController.text));`
  3. **React to state:**
     - **Loading:** Disable the sign-in button and/or show a loading indicator (e.g. overlay or `CircularProgressIndicator` on the button).
     - **Success:** Use `BlocListener<AuthBloc, AuthState>` (or `BlocConsumer`): when `state.status.isSuccess()` (or equivalent), call `context.go(AppRoutes.home)` (and optionally a short success snackbar).
     - **Fail:** In the same listener, when `state.status.isFail()`, show a snackbar with `state.errorMessage` (e.g. using existing `AppSnackbar.showError` or similar).
  4. **Cleanup:** Keep disposing the text controllers in `dispose`; do not store token or call storage directly in the page — all of that is in the repository.
- **Widgets:** Reuse existing `LoginFormSection`, `LoginSignInButton`, etc. Pass the submit callback that dispatches `LoginSubmitted` (or give them access to the bloc via `context.read<AuthBloc>()` and dispatch there). Prefer a single place (e.g. the page) that both provides the bloc and dispatches the event with the current form values.

---

## 4. Base URL and Network Client

- **Source of base URL:** Same as home — **`ApiConfig.baseUrl`** in `lib/core/config/api_config.dart`. The app does not use a separate “auth client”; `NetworkClient` is configured once with `ApiConfig.baseUrl` and used by all features (home and auth).
- **Auth requests:** Use the same `NetworkClient` instance (injected into `AuthRemoteDataSource`). Only the path differs: `ApiConfig.authLoginPath` (relative), so the full URL is `baseUrl + authLoginPath`.
- No env-specific logic is required for this task unless the project already has a different mechanism for base URL; in that case, keep using that mechanism for both home and auth.

---

## 5. File Summary

### New files to create

| Layer       | File path                                                                 | Purpose |
|------------|----------------------------------------------------------------------------|--------|
| Domain     | `lib/features/auth/domain/repositories/auth_repository.dart`                | `IAuthRepository` with `login(username, password) -> Either<Failure, String>` |
| Domain     | `lib/features/auth/domain/usecases/login_use_case.dart`                     | `LoginUseCase` calling repository `login` |
| Data       | `lib/features/auth/data/models/auth_model.dart`                            | Freezed + JSON model for `{ "token": "..." }` |
| Data       | `lib/features/auth/data/datasources/auth_remote_data_source.dart`          | POST login, parse response, return `Either<NetworkFailure, AuthModel>` |
| Data       | `lib/features/auth/data/repositories/auth_repository_impl.dart`            | Implement `IAuthRepository`; call data source then `AppStorageService` on success |
| Data       | `lib/features/auth/data/di.dart`                                          | Register data source, repository, use case, BLoC |
| Presentation | `lib/features/auth/presentation/bloc/auth_event.dart`                     | `LoginSubmitted(username, password)` |
| Presentation | `lib/features/auth/presentation/bloc/auth_state.dart`                   | State with `BlocStatus` and `errorMessage` (initial, loading, success, fail) |
| Presentation | `lib/features/auth/presentation/bloc/auth_bloc.dart`                      | AuthBloc with `LoginUseCase`, handle `LoginSubmitted` |

After code generation for the auth model:

- `lib/features/auth/data/models/auth_model.freezed.dart`
- `lib/features/auth/data/models/auth_model.g.dart`

### Existing files to modify

| File | Change |
|------|--------|
| `lib/core/config/api_config.dart` | Add `static const String authLoginPath = '/auth/login';` |
| `lib/core/di/app_dependencies.dart` | Import auth `di.dart` and call `registerAuthDependencies(getIt);` |
| `lib/features/auth/presentation/pages/login_page.dart` | Provide `AuthBloc`, dispatch `LoginSubmitted` with form values, use `BlocListener`/`BlocConsumer` for loading/success (navigate to home)/fail (snackbar), remove direct storage and navigation from `_onSignIn` |

---

## 6. Naming and Pattern Alignment with Home

- **Repository interface:** `IProductRepository` → `IAuthRepository` (same `I` prefix).
- **Repository impl:** `ProductRepositoryImpl` → `AuthRepositoryImpl`.
- **Remote data source:** `ProductRemoteDataSource` → `AuthRemoteDataSource`.
- **Use case:** `GetProductsUseCase` / `GetCategoriesUseCase` → `LoginUseCase` (single use case for login).
- **BLoC:** `HomeBloc` → `AuthBloc`; events/states follow the same Equatable/BlocStatus style.
- **DI:** Same pattern — data source and repository as lazy singletons, use case lazy singleton, BLoC as factory. Auth repository additionally receives `AppStorageService` for persisting token and `isLoggedIn`.

---

## 7. Testing (recommended, not in scope of this design)

- **Unit:** `LoginUseCase` with a mock `IAuthRepository`; `AuthRepositoryImpl` with mock data source and mock `AppStorageService` (verify `setAccessToken` and `setLoggedIn(true)` on success).
- **Unit:** `AuthBloc` with mock `LoginUseCase` (initial, loading, success, fail emissions).
- **Widget:** Login page — tap sign in, assert loading then navigation or error snackbar.

This design document is sufficient for an implementer to add the auth feature end-to-end in line with the existing home feature and DDD rules.
