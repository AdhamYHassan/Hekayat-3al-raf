import 'package:equatable/equatable.dart';
import 'ambassador_list_item_entity.dart';

/// Paginated result of ambassadors
class PaginatedAmbassadorsEntity extends Equatable {
  final int count;
  final bool hasMore;
  final List<AmbassadorListItemEntity> ambassadors;

  const PaginatedAmbassadorsEntity({
    required this.count,
    required this.hasMore,
    required this.ambassadors,
  });

  @override
  List<Object?> get props => [count, hasMore, ambassadors];
}

