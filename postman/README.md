# Postman – FakeStore API

Postman collection and environment for **FakeStore API** (v2.1.11).  
Use this to explore and test all endpoints before building the e-commerce Flutter app.

## Files

| File | Purpose |
|------|--------|
| `FakeStore-API.postman_collection.json` | All API requests grouped by: Products, Carts, Users, Auth. **Carts** and **Auth** use **raw JSON**; Products/Users use form-data. |
| `FakeStore-API.postman_environment.json` | Environment variables: `baseUrl`, `id`, `productId`, `userId`, `cartId`, `token`. |

## Setup

1. **Import in Postman**
   - **Collections:** Import → Upload Files → select `FakeStore-API.postman_collection.json`
   - **Environments:** Import → Upload Files → select `FakeStore-API.postman_environment.json`

2. **Select environment**
   - In the top-right dropdown, choose **FakeStore API - Base**.

3. **Run requests**
   - Open any folder (e.g. **Products**), then run **Get all products** or any other request.
   - For requests that need an ID (e.g. Get single product), set `id` in the environment (default: `1`) or in the request URL/path.

## Collection structure

- **Products** – GET all, GET all categories, GET by category, GET by id, POST (add), PUT (update), DELETE
- **Carts** – GET all, GET by id, POST (add), PUT (update), DELETE
- **Users** – GET all, GET by id, POST (add), PUT (update), DELETE
- **Auth** – POST Login (username + password → token)

**Products** and **Users** use form-data; **Carts** and **Auth** use raw JSON (required).  
If FakeStore returns **400** on POST/PUT (it officially expects `application/json`), switch that request’s body in Postman to **raw** → **JSON** and use the same field names as in the form-data.

## Carts: Why GET Returns `null` for Newly Created Carts

FakeStoreAPI is a **fake/mock API** that does **not persist** POST/PUT/DELETE data. When you `POST /carts`, you get a 201 response with a generated `id`, but that cart is **never stored**. `GET /carts/{newId}` returns **`null`** because only pre-seeded carts (ids 1–7) exist permanently.

**Correct cart creation** requires `Content-Type: application/json`:

```json
{
  "userId": 1,
  "products": [{"productId": 1, "quantity": 2}, {"productId": 2, "quantity": 1}]
}
```

Products use `productId` and `quantity` — not full Product objects. Form-data does **not** work. For your Flutter app: persist cart state client-side (e.g. shared_preferences, Hive); use the API only for pre-seeded carts or simulation.

## Environment variables

| Variable   | Default                  | Usage |
|-----------|--------------------------|--------|
| `baseUrl` | `https://fakestoreapi.com` | Base URL for all requests. |
| `id`      | `1`                      | Generic path `id` (product/cart/user). |
| `productId` | `1`                   | Product id for cart items. |
| `userId`  | `1`                      | User id for cart/user flows. |
| `cartId`  | `1`                      | Cart id for cart endpoints. |
| `categoryName` | `electronics`       | Category for GET products by category (e.g. `electronics`, `jewelery`, `men's clothing`, `women's clothing`). |
| `token`   | (empty)                  | Optional; set from Login response if you use auth later. |

## API reference

- Docs: [https://fakestoreapi.com/docs](https://fakestoreapi.com/docs)
- OpenAPI: [https://fakestoreapi.com/docs-data](https://fakestoreapi.com/docs-data)
