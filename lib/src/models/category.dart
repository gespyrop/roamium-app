import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String name;

  const Category(this.name);

  @override
  String toString() =>
      '${name[0].toUpperCase()}${name.substring(1).replaceAll('_', ' ')}';

  @override
  List<Object?> get props => [name];
}
