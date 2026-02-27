// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_product_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateProductResponseModel {

 int get id; String get title; double get price; String get description; String get category;@JsonKey(name: 'image') String get image;@JsonKey(name: 'rating') ProductRatingModel? get rating;
/// Create a copy of CreateProductResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateProductResponseModelCopyWith<CreateProductResponseModel> get copyWith => _$CreateProductResponseModelCopyWithImpl<CreateProductResponseModel>(this as CreateProductResponseModel, _$identity);

  /// Serializes this CreateProductResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateProductResponseModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.price, price) || other.price == price)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.image, image) || other.image == image)&&(identical(other.rating, rating) || other.rating == rating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,price,description,category,image,rating);

@override
String toString() {
  return 'CreateProductResponseModel(id: $id, title: $title, price: $price, description: $description, category: $category, image: $image, rating: $rating)';
}


}

/// @nodoc
abstract mixin class $CreateProductResponseModelCopyWith<$Res>  {
  factory $CreateProductResponseModelCopyWith(CreateProductResponseModel value, $Res Function(CreateProductResponseModel) _then) = _$CreateProductResponseModelCopyWithImpl;
@useResult
$Res call({
 int id, String title, double price, String description, String category,@JsonKey(name: 'image') String image,@JsonKey(name: 'rating') ProductRatingModel? rating
});


$ProductRatingModelCopyWith<$Res>? get rating;

}
/// @nodoc
class _$CreateProductResponseModelCopyWithImpl<$Res>
    implements $CreateProductResponseModelCopyWith<$Res> {
  _$CreateProductResponseModelCopyWithImpl(this._self, this._then);

  final CreateProductResponseModel _self;
  final $Res Function(CreateProductResponseModel) _then;

/// Create a copy of CreateProductResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? price = null,Object? description = null,Object? category = null,Object? image = null,Object? rating = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as ProductRatingModel?,
  ));
}
/// Create a copy of CreateProductResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductRatingModelCopyWith<$Res>? get rating {
    if (_self.rating == null) {
    return null;
  }

  return $ProductRatingModelCopyWith<$Res>(_self.rating!, (value) {
    return _then(_self.copyWith(rating: value));
  });
}
}


/// Adds pattern-matching-related methods to [CreateProductResponseModel].
extension CreateProductResponseModelPatterns on CreateProductResponseModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateProductResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateProductResponseModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateProductResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _CreateProductResponseModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateProductResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _CreateProductResponseModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  double price,  String description,  String category, @JsonKey(name: 'image')  String image, @JsonKey(name: 'rating')  ProductRatingModel? rating)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateProductResponseModel() when $default != null:
return $default(_that.id,_that.title,_that.price,_that.description,_that.category,_that.image,_that.rating);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  double price,  String description,  String category, @JsonKey(name: 'image')  String image, @JsonKey(name: 'rating')  ProductRatingModel? rating)  $default,) {final _that = this;
switch (_that) {
case _CreateProductResponseModel():
return $default(_that.id,_that.title,_that.price,_that.description,_that.category,_that.image,_that.rating);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  double price,  String description,  String category, @JsonKey(name: 'image')  String image, @JsonKey(name: 'rating')  ProductRatingModel? rating)?  $default,) {final _that = this;
switch (_that) {
case _CreateProductResponseModel() when $default != null:
return $default(_that.id,_that.title,_that.price,_that.description,_that.category,_that.image,_that.rating);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateProductResponseModel extends CreateProductResponseModel {
  const _CreateProductResponseModel({required this.id, required this.title, required this.price, required this.description, required this.category, @JsonKey(name: 'image') required this.image, @JsonKey(name: 'rating') this.rating}): super._();
  factory _CreateProductResponseModel.fromJson(Map<String, dynamic> json) => _$CreateProductResponseModelFromJson(json);

@override final  int id;
@override final  String title;
@override final  double price;
@override final  String description;
@override final  String category;
@override@JsonKey(name: 'image') final  String image;
@override@JsonKey(name: 'rating') final  ProductRatingModel? rating;

/// Create a copy of CreateProductResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateProductResponseModelCopyWith<_CreateProductResponseModel> get copyWith => __$CreateProductResponseModelCopyWithImpl<_CreateProductResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateProductResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateProductResponseModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.price, price) || other.price == price)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.image, image) || other.image == image)&&(identical(other.rating, rating) || other.rating == rating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,price,description,category,image,rating);

@override
String toString() {
  return 'CreateProductResponseModel(id: $id, title: $title, price: $price, description: $description, category: $category, image: $image, rating: $rating)';
}


}

/// @nodoc
abstract mixin class _$CreateProductResponseModelCopyWith<$Res> implements $CreateProductResponseModelCopyWith<$Res> {
  factory _$CreateProductResponseModelCopyWith(_CreateProductResponseModel value, $Res Function(_CreateProductResponseModel) _then) = __$CreateProductResponseModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, double price, String description, String category,@JsonKey(name: 'image') String image,@JsonKey(name: 'rating') ProductRatingModel? rating
});


@override $ProductRatingModelCopyWith<$Res>? get rating;

}
/// @nodoc
class __$CreateProductResponseModelCopyWithImpl<$Res>
    implements _$CreateProductResponseModelCopyWith<$Res> {
  __$CreateProductResponseModelCopyWithImpl(this._self, this._then);

  final _CreateProductResponseModel _self;
  final $Res Function(_CreateProductResponseModel) _then;

/// Create a copy of CreateProductResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? price = null,Object? description = null,Object? category = null,Object? image = null,Object? rating = freezed,}) {
  return _then(_CreateProductResponseModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as ProductRatingModel?,
  ));
}

/// Create a copy of CreateProductResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductRatingModelCopyWith<$Res>? get rating {
    if (_self.rating == null) {
    return null;
  }

  return $ProductRatingModelCopyWith<$Res>(_self.rating!, (value) {
    return _then(_self.copyWith(rating: value));
  });
}
}

// dart format on
