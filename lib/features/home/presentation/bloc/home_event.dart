import 'package:equatable/equatable.dart';

//* Home screen events — load products, select category, refresh.

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// Initial load: fetch categories + all products.
class LoadHome extends HomeEvent {
  const LoadHome();
}

/// User selected a category. [categoryName] is null or 'all' for all products.
class CategorySelected extends HomeEvent {
  const CategorySelected(this.categoryName);

  final String? categoryName;

  @override
  List<Object?> get props => [categoryName];
}

/// Pull-to-refresh: re-fetch for current filter.
class RefreshHome extends HomeEvent {
  const RefreshHome();
}

/// Toggle category layout: row vs grid.
class CategoryLayoutToggled extends HomeEvent {
  const CategoryLayoutToggled();
}

/// Toggle product view: grid vs list.
class ProductViewStyleToggled extends HomeEvent {
  const ProductViewStyleToggled();
}

/// Toggle search mode (show/hide search field).
class SearchModeToggled extends HomeEvent {
  const SearchModeToggled();
}

/// Close search mode (clears query and exits search).
class SearchClosed extends HomeEvent {
  const SearchClosed();
}

/// User changed the search query (client-side filter; no API).
class SearchQueryChanged extends HomeEvent {
  const SearchQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Bottom nav tab or page changed (tap or swipe). [index]: 0=Home, 1=Cart, 2=AddProduct, 3=Settings.
class BottomNavIndexChanged extends HomeEvent {
  const BottomNavIndexChanged(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}
