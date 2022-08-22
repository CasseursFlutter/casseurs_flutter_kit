class PaginatedList<T> {
  final List<T> items;
  final int page;
  final int total;

  bool get hasMore => items.length < total;

  const PaginatedList({
    this.items = const [],
    this.page = 0,
    this.total = 0
  });

  factory PaginatedList.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) itemParser) {
    return PaginatedList<T>(
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      items: List<Map<String, dynamic>>.from(json['items']).map((e) => itemParser(e)).toList()
    );
  }

  PaginatedList<T> copyWith({    
    List<T>? items,
    int? page,
    int? total
  }) {
    return PaginatedList(      
      items: items ?? this.items,
      page: page ?? this.page,
      total: total ?? this.total
    );
  }
}