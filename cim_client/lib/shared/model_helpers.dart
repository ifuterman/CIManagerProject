import 'package:equatable/equatable.dart';
import 'package:rxdart/subjects.dart';

class BehaviorSubjectHelper<T> extends Equatable{
  BehaviorSubjectHelper() : this._();

  BehaviorSubjectHelper.seeded(T seededValue) : this._(initial: seededValue);

  BehaviorSubjectHelper._({T initial}) : _on = BehaviorSubject.seeded(initial);

  final BehaviorSubject<T> _on;

  Stream<T> get stream => _on.stream;

  T get value => _on.value;

  void add(T value) => _on.add(value);


  @override
  List<Object> get props => [value];
}

// TODO(vvk): test!
///
class PublishSubjectHelper<T> extends Equatable{

  PublishSubjectHelper() : _on = PublishSubject<T>();

  final PublishSubject<T> _on;

  Stream<T> get stream => _on.stream;

  void add(T value) => _on.add(value);

  @override
  List<Object> get props => [];
}
