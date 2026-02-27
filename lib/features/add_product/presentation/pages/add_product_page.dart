import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/animation/animation.dart';
import '../../../../core/component/app_snackbar.dart';
import '../../../../core/component/custom_text_area_form_field.dart';
import '../../../../core/component/custom_text_form_field.dart';
import '../../../../core/di/app_dependencies.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/shared/app_scaffold.dart';
import '../../../../core/theme/app_color_extension.dart';
import '../../../../core/validation/form_validators.dart';
import '../../../home/domain/entities/create_product_input.dart';
import '../../../home/presentation/mappers/home_product_mapper.dart';
import '../../../home/presentation/widgets/home_category_chips.dart';
import '../../../../core/routing/app_routes.dart';
import '../bloc/add_product_bloc.dart';
import '../bloc/add_product_event.dart';
import '../bloc/add_product_state.dart';
import '../widgets/add_product_button.dart';
import '../widgets/add_product_category_section.dart';
import '../widgets/cancel_button.dart';

//* Add Product form page — Product Name, Price, Description, Category (chips), Image URL, Add/Cancel.
//? Uses AddProductBloc; navigates to product details on success.

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();

  CategoryLayoutStyle _categoryLayout = CategoryLayoutStyle.row;

  static const ProductNameValidator _productNameValidator =
      ProductNameValidator();
  static const PriceValidator _priceValidator = PriceValidator();
  static const UrlValidator _urlValidator = UrlValidator();

  /// Description validator — required non-empty.
  static String? _descriptionValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.addProduct_validation_descriptionRequired.tr();
    }
    return null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _onAddProduct(AddProductBloc bloc) {
    if (_formKey.currentState?.validate() != true) return;
    final categories = bloc.state.categories;
    if (categories.isEmpty) return;
    final category = categories[bloc.state.selectedCategoryIndex];
    final priceStr = _priceController.text.trim().replaceAll(RegExp(r'[^\d.]'), '');
    final price = double.tryParse(priceStr) ?? 0.0;
    bloc.add(SubmitAddProduct(CreateProductInput(
      title: _nameController.text.trim(),
      price: price,
      description: _descriptionController.text.trim(),
      category: category,
      imageUrl: _imageUrlController.text.trim(),
    )));
  }

  void _onCancel(AddProductBloc bloc) {
    _formKey.currentState?.reset();
    _nameController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _imageUrlController.clear();
    bloc.add(const CategorySelected(0));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final appColors = theme.extension<AppColorExtension>();

    return BlocProvider<AddProductBloc>(
      create: (_) =>
          getIt<AddProductBloc>()..add(const LoadCategoriesRequested()),
      child: BlocListener<AddProductBloc, AddProductState>(
        listenWhen: (prev, curr) =>
            prev.status != curr.status ||
            prev.createdProduct != curr.createdProduct,
        listener: (context, state) {
          if (state.createdProduct != null) {
            AppSnackbar.showSuccess(context, LocaleKeys.addProduct_productAdded);
            context.push(
              AppRoutes.productDetails,
              extra: payloadFromProduct(state.createdProduct!),
            );
          }
          if (state.status.isFail() && state.errorMessage != null) {
            AppSnackbar.showError(context, state.errorMessage!);
          }
        },
        child: BlocBuilder<AddProductBloc, AddProductState>(
          builder: (context, state) {
            final categories =
                state.categories
                    .map((s) => HomeCategoryItem(
                          id: s,
                          label: s,
                          labelIsLocaleKey: false,
                        ))
                    .toList();
            final hasCategories = categories.isNotEmpty;
            if (!hasCategories && !state.status.isLoading()) {
              //* Fallback: show empty until loaded
            }

            return AppScaffold.clean(
              backgroundColor: theme.colorScheme.surface,
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 24.h,
                        ),
                        child: Form(
                          key: _formKey,
                          child: AnimatedColumn(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CustomTextFormField(
                                controller: _nameController,
                                labelKey: LocaleKeys.addProduct_productName,
                                hintKey: LocaleKeys.addProduct_hintProductName,
                                textInputAction: TextInputAction.next,
                                validator: _productNameValidator.call,
                              ),
                              SizedBox(height: 24.h),
                              CustomTextFormField(
                                controller: _priceController,
                                labelKey: LocaleKeys.addProduct_price,
                                hintKey: LocaleKeys.addProduct_hintPrice,
                                keyboardType: const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                prefixText: r'$ ',
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[\d.]'),
                                  ),
                                ],
                                validator: _priceValidator.call,
                              ),
                              SizedBox(height: 24.h),
                              CustomTextAreaFormField(
                                controller: _descriptionController,
                                labelKey: LocaleKeys.addProduct_description,
                                hintKey: LocaleKeys.addProduct_hintDescription,
                                minLines: 3,
                                maxLines: 5,
                                height: 150,
                                validator: _descriptionValidator,
                              ),
                              SizedBox(height: 24.h),
                              Padding(
                                padding: EdgeInsets.only(bottom: 12.h),
                                child: Text(
                                  LocaleKeys.addProduct_category.tr(),
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              if (hasCategories)
                                AddProductCategorySection(
                                  categories: categories,
                                  selectedIndex: state.selectedCategoryIndex,
                                  layoutStyle: _categoryLayout,
                                  onCategorySelected: (i) => context
                                      .read<AddProductBloc>()
                                      .add(CategorySelected(i)),
                                  onLayoutToggle: () => setState(() {
                                    _categoryLayout =
                                        _categoryLayout ==
                                                CategoryLayoutStyle.row
                                            ? CategoryLayoutStyle.grid
                                            : CategoryLayoutStyle.row;
                                  }),
                                )
                              else
                                SizedBox(
                                  height: 55.h,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              SizedBox(height: 24.h),
                              CustomTextFormField(
                                controller: _imageUrlController,
                                labelKey: LocaleKeys.addProduct_imageUrl,
                                hintKey: LocaleKeys.addProduct_hintImageUrl,
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                validator: _urlValidator.call,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    AnimatedSection(
                      sectionIndex: 0,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(20.w, 17.h, 20.w, 24.h),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          border: Border(
                            top: BorderSide(
                              color: appColors?.borderColor ??
                                  theme.colorScheme.outline,
                            ),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AddProductButton(
                              enabled: !state.status.isLoading(),
                              onPressed: () => _onAddProduct(
                                context.read<AddProductBloc>(),
                              ),
                            ),
                            SizedBox(height: 12.h),
                            AddProductCancelButton(
                              onPressed: () => _onCancel(
                                context.read<AddProductBloc>(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
