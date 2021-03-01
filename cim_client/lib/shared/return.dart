import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class Return<R, D> extends Equatable {
  final R result;
  final D data;
  final String description;

  Return({
    @required this.result,
    this.data,
    this.description,
  });

  @override
  List<Object> get props => [result, data, description];
}

class Boolean<D> extends Return<bool, D> {
  Boolean(bool result, {D data, String description})
      : super(result: result, data: data, description: description);
}

class Ok<D> extends Boolean<D> {
  Ok({D data, String description})
      : super(true, data: data, description: description);
}

class Err<D> extends Boolean<D> {
  Err({D data, String description})
      : super(false, data: data, description: description);
}

