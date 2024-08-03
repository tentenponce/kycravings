// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'your_cravings_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$YourCravingsState {
  List<CravingModel> get cravings => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $YourCravingsStateCopyWith<YourCravingsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $YourCravingsStateCopyWith<$Res> {
  factory $YourCravingsStateCopyWith(
          YourCravingsState value, $Res Function(YourCravingsState) then) =
      _$YourCravingsStateCopyWithImpl<$Res, YourCravingsState>;
  @useResult
  $Res call({List<CravingModel> cravings});
}

/// @nodoc
class _$YourCravingsStateCopyWithImpl<$Res, $Val extends YourCravingsState>
    implements $YourCravingsStateCopyWith<$Res> {
  _$YourCravingsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cravings = null,
  }) {
    return _then(_value.copyWith(
      cravings: null == cravings
          ? _value.cravings
          : cravings // ignore: cast_nullable_to_non_nullable
              as List<CravingModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$YourCravingsStateImplCopyWith<$Res>
    implements $YourCravingsStateCopyWith<$Res> {
  factory _$$YourCravingsStateImplCopyWith(_$YourCravingsStateImpl value,
          $Res Function(_$YourCravingsStateImpl) then) =
      __$$YourCravingsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<CravingModel> cravings});
}

/// @nodoc
class __$$YourCravingsStateImplCopyWithImpl<$Res>
    extends _$YourCravingsStateCopyWithImpl<$Res, _$YourCravingsStateImpl>
    implements _$$YourCravingsStateImplCopyWith<$Res> {
  __$$YourCravingsStateImplCopyWithImpl(_$YourCravingsStateImpl _value,
      $Res Function(_$YourCravingsStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cravings = null,
  }) {
    return _then(_$YourCravingsStateImpl(
      cravings: null == cravings
          ? _value._cravings
          : cravings // ignore: cast_nullable_to_non_nullable
              as List<CravingModel>,
    ));
  }
}

/// @nodoc

class _$YourCravingsStateImpl implements _YourCravingsState {
  const _$YourCravingsStateImpl({final List<CravingModel> cravings = const []})
      : _cravings = cravings;

  final List<CravingModel> _cravings;
  @override
  @JsonKey()
  List<CravingModel> get cravings {
    if (_cravings is EqualUnmodifiableListView) return _cravings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cravings);
  }

  @override
  String toString() {
    return 'YourCravingsState(cravings: $cravings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$YourCravingsStateImpl &&
            const DeepCollectionEquality().equals(other._cravings, _cravings));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_cravings));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$YourCravingsStateImplCopyWith<_$YourCravingsStateImpl> get copyWith =>
      __$$YourCravingsStateImplCopyWithImpl<_$YourCravingsStateImpl>(
          this, _$identity);
}

abstract class _YourCravingsState implements YourCravingsState {
  const factory _YourCravingsState({final List<CravingModel> cravings}) =
      _$YourCravingsStateImpl;

  @override
  List<CravingModel> get cravings;
  @override
  @JsonKey(ignore: true)
  _$$YourCravingsStateImplCopyWith<_$YourCravingsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
