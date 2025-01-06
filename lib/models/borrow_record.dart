class BorrowRecord {
  final String id;
  final String bookId;
  final String memberId;
  final DateTime borrowDate;
  final DateTime dueDate;
  DateTime? returnDate;
  bool isReturned;

  BorrowRecord({
    required this.id,
    required this.bookId,
    required this.memberId,
    required this.borrowDate,
    required this.dueDate,
    this.returnDate,
    this.isReturned = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'memberId': memberId,
      'borrowDate': borrowDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'returnDate': returnDate?.toIso8601String(),
      'isReturned': isReturned,
    };
  }

  factory BorrowRecord.fromJson(Map<String, dynamic> json) {
    return BorrowRecord(
      id: json['id'],
      bookId: json['bookId'],
      memberId: json['memberId'],
      borrowDate: DateTime.parse(json['borrowDate']),
      dueDate: DateTime.parse(json['dueDate']),
      returnDate: json['returnDate'] != null
          ? DateTime.parse(json['returnDate'])
          : null,
      isReturned: json['isReturned'],
    );
  }

  bool isOverdue() {
    if (isReturned) return false;
    return DateTime.now().isAfter(dueDate);
  }
}
