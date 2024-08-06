import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:kycravings/domain/models/craving_model.dart';

@CopyWith()
class CravingHistoryModel extends Equatable {
  final int id;
  final CravingModel cravingModel;
  final DateTime createdAt;

  const CravingHistoryModel({
    required this.id,
    required this.cravingModel,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        cravingModel,
        createdAt,
      ];
}
