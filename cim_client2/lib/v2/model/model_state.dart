import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'model_state.freezed.dart';

@freezed
class ModelState<T>  with _$ModelState<T>{
  const factory ModelState.initial() = Initial<T>;
  const factory ModelState(T value) = Data<T>;
  const factory ModelState.loading() = Loading<T>;
  const factory ModelState.error([String? message]) = ErrorDetails<T>;
}

