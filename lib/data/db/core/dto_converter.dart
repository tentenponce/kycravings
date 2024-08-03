import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';

abstract class DtoConverter<T extends Equatable, S extends DataClass> {
  Future<S> convert(T dto);
  Future<T> convertBack(S dbObj);

  Future<Iterable<S>> convertList(Iterable<T> dtos) async {
    return Future.wait(dtos.map(convert).toList());
  }

  Future<Iterable<T>> convertBackList(Iterable<S> dbObjs) async {
    return Future.wait(dbObjs.map(convertBack).toList());
  }
}
