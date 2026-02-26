import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../bloc/product_details_bloc.dart';
import '../bloc/product_details_event.dart';
import '../bloc/product_details_state.dart';
import '../widgets/back_button.dart';
import '../widgets/favourite_button.dart';
import '../widgets/add_to_cart_button.dart';
import '../widgets/product_details_advantage_row.dart';
import '../widgets/product_details_description_quantity.dart';
import '../widgets/product_details_hero.dart';
import '../widgets/product_details_title_price_rating.dart';

@immutable
class ProductDetailsPayload {
  const ProductDetailsPayload({
    required this.categoryName,
    required this.title,
    required this.priceFormatted,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.imageUrl,
  });

  final String categoryName;
  final String title;
  final String priceFormatted;
  final double rating;
  final int reviewCount;
  final String description;
  final String imageUrl;
}

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({
    super.key,
    required this.payload,
    this.onBack,
    this.onFavourite,
    this.onAddToCart,
  });

  final ProductDetailsPayload payload;
  final VoidCallback? onBack;
  final VoidCallback? onFavourite;
  final void Function(int quantity)? onAddToCart;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

const double _kHeroHeight = 375;
const double _kCardOverlap = 24;

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late final ScrollController _scrollController;
  late final ProductDetailsBloc _bloc;
  double _scrollLeadHeight = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _bloc = ProductDetailsBloc(onAddToCart: widget.onAddToCart);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _bloc.close();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted || _scrollLeadHeight <= 0) return;
    _bloc.add(ProductDetailsScrollChanged(
      scrollOffset: _scrollController.offset,
      scrollLeadHeight: _scrollLeadHeight,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final heroHeight = _kHeroHeight.h;
    final cardOverlap = _kCardOverlap.h;
    final scrollLeadHeight = heroHeight - cardOverlap;
    _scrollLeadHeight = scrollLeadHeight;

    return BlocProvider<ProductDetailsBloc>.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAF8),
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ProductDetailsHero(
                imageUrl: widget.payload.imageUrl,
                onBack: widget.onBack ?? () => Navigator.of(context).pop(),
                onFavourite: widget.onFavourite,
              ),
            ),
            Positioned.fill(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: scrollLeadHeight),
                    Transform.translate(
                      offset: Offset(0, -cardOverlap),
                      child: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
                        buildWhen: (prev, curr) => prev.quantity != curr.quantity,
                        builder: (context, state) => _DetailsCard(
                          theme: theme,
                          colorScheme: colorScheme,
                          payload: widget.payload,
                          quantity: state.quantity,
                          onDecrement: () =>
                              context.read<ProductDetailsBloc>().add(
                                    const ProductDetailsQuantityDecremented(),
                                  ),
                          onIncrement: () =>
                              context.read<ProductDetailsBloc>().add(
                                    const ProductDetailsQuantityIncremented(),
                                  ),
                          onAddToCart: widget.onAddToCart != null
                              ? () => context.read<ProductDetailsBloc>().add(
                                    const ProductDetailsAddToCartRequested(),
                                  )
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
              buildWhen: (prev, curr) =>
                  prev.showButtonsOnContent != curr.showButtonsOnContent,
              builder: (context, state) {
                return Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: IgnorePointer(
                    ignoring: !state.showButtonsOnContent,
                    child: AnimatedOpacity(
                      opacity: state.showButtonsOnContent ? 1 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: SafeArea(
                        bottom: false,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              ProductDetailsBackButton(
                                onPressed: widget.onBack ??
                                    () => Navigator.of(context).pop(),
                              ),
                              FavouriteButton(
                                  onPressed: widget.onFavourite),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({
    required this.theme,
    required this.colorScheme,
    required this.payload,
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
    required this.onAddToCart,
  });

  final ThemeData theme;
  final ColorScheme colorScheme;
  final ProductDetailsPayload payload;
  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final VoidCallback? onAddToCart;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: ShapeDecoration(
        color: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        shadows: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.25),
            blurRadius: 50.r,
            offset: Offset(0, 25.h),
            spreadRadius: 0,
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        20.w,
        32.h,
        20.w,
        MediaQuery.paddingOf(context).bottom + 24.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductDetailsTitlePriceRating(
            categoryName: payload.categoryName,
            title: payload.title,
            priceFormatted: payload.priceFormatted,
            rating: payload.rating,
            reviewCount: payload.reviewCount,
          ),
          SizedBox(height: 24.h),
          ProductDetailsDescriptionQuantity(
            description: payload.description,
            quantity: quantity,
            onDecrement: onDecrement,
            onIncrement: onIncrement,
          ),
          SizedBox(height: 32.h),
          AddToCartButton(onPressed: onAddToCart),
          SizedBox(height: 32.h),
          ProductDetailsAdvantageRow(),
        ],
      ),
    );
  }
}
