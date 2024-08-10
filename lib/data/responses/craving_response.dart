import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'craving_response.g.dart';

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class CravingResponse extends Equatable {
  final int id;
  final String name;
  final Iterable<int> categories;

  const CravingResponse({
    required this.id,
    required this.name,
    required this.categories,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        categories,
      ];

  factory CravingResponse.fromJson(Map<String, dynamic> json) => _$CravingResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CravingResponseToJson(this);
}
