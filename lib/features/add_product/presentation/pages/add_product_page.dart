import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/component/custom_text_area_form_field.dart';
import '../../../../core/component/custom_text_form_field.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/shared/app_scaffold.dart';
import '../../../../core/theme/app_color_extension.dart';
import '../../../../core/validation/form_validators.dart';
import '../../../../mock_data/home_mock_data.dart';
import '../../../home/presentation/widgets/home_category_chips.dart';
import '../widgets/add_product_button.dart';
import '../widgets/add_product_category_section.dart';
import '../widgets/cancel_button.dart';

//* Add Product form page — Product Name, Price, Description, Category (chips), Image URL, Add/Cancel.
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

  //? Exclude "All" — add product requires a specific category
  late final List<HomeCategoryItem> _categories =
      mockHomeCategories.skip(1).toList();
  int _selectedCategoryIndex = 0;
  CategoryLayoutStyle _categoryLayout = CategoryLayoutStyle.row;

  static const ProductNameValidator _productNameValidator =
      ProductNameValidator();
  static const PriceValidator _priceValidator = PriceValidator();
  static const UrlValidator _urlValidator = UrlValidator();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _onAddProduct() {
    if (_formKey.currentState?.validate() ?? false) {
      //! TODO: Submit product via BLoC/Repository when backend is wired
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product submission coming soon')),
      );
    }
  }

  void _onCancel() {
    //* Pop or clear form — for tab-based nav, we clear
    _formKey.currentState?.reset();
    _nameController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _imageUrlController.clear();
    setState(() => _selectedCategoryIndex = 0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final appColors = theme.extension<AppColorExtension>();

    return AppScaffold.clean(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //* Product Name
                      CustomTextFormField(
                        controller: _nameController,
                        labelKey: LocaleKeys.addProduct_productName,
                        hintKey: LocaleKeys.addProduct_hintProductName,
                        textInputAction: TextInputAction.next,
                        validator: _productNameValidator.call,
                      ),
                      SizedBox(height: 24.h),

                      //* Price (with $ prefixText — fixes text visibility & hint alignment)
                      CustomTextFormField(
                        controller: _priceController,
                        labelKey: LocaleKeys.addProduct_price,
                        hintKey: LocaleKeys.addProduct_hintPrice,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        prefixText: '\$ ',
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[\d.]'),
                          ),
                        ],
                        validator: _priceValidator.call,
                      ),
                      SizedBox(height: 24.h),

                      //* Description (multi-line)
                      CustomTextAreaFormField(
                        controller: _descriptionController,
                        labelKey: LocaleKeys.addProduct_description,
                        hintKey: LocaleKeys.addProduct_hintDescription,
                        minLines: 3,
                        maxLines: 5,
                        height: 150,
                      ),
                      SizedBox(height: 24.h),

                      //* Category — row/grid with toggle (same as home page)
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
                      AddProductCategorySection(
                        categories: _categories,
                        selectedIndex: _selectedCategoryIndex,
                        layoutStyle: _categoryLayout,
                        onCategorySelected: (i) =>
                            setState(() => _selectedCategoryIndex = i),
                        onLayoutToggle: () => setState(() {
                          _categoryLayout =
                              _categoryLayout == CategoryLayoutStyle.row
                                  ? CategoryLayoutStyle.grid
                                  : CategoryLayoutStyle.row;
                        }),
                      ),
                      SizedBox(height: 24.h),

                      //* Image URL
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

            //* Bottom action bar — white bg, top border
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20.w, 17.h, 20.w, 24.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: appColors?.borderColor ?? theme.colorScheme.outline,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AddProductButton(onPressed: _onAddProduct),
                  SizedBox(height: 12.h),
                  AddProductCancelButton(onPressed: _onCancel),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
