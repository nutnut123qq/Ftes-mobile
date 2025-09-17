class TransactionItem {
  final String id;
  final String courseTitle;
  final String category;
  final String price;
  final String status;
  final String date;
  final String imageUrl;
  final String studentName;
  final String email;
  final String transactionId;

  const TransactionItem({
    required this.id,
    required this.courseTitle,
    required this.category,
    required this.price,
    required this.status,
    required this.date,
    required this.imageUrl,
    required this.studentName,
    required this.email,
    required this.transactionId,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      id: json['id'] ?? '',
      courseTitle: json['courseTitle'] ?? '',
      category: json['category'] ?? '',
      price: json['price'] ?? '',
      status: json['status'] ?? '',
      date: json['date'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      studentName: json['studentName'] ?? '',
      email: json['email'] ?? '',
      transactionId: json['transactionId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseTitle': courseTitle,
      'category': category,
      'price': price,
      'status': status,
      'date': date,
      'imageUrl': imageUrl,
      'studentName': studentName,
      'email': email,
      'transactionId': transactionId,
    };
  }

  TransactionItem copyWith({
    String? id,
    String? courseTitle,
    String? category,
    String? price,
    String? status,
    String? date,
    String? imageUrl,
    String? studentName,
    String? email,
    String? transactionId,
  }) {
    return TransactionItem(
      id: id ?? this.id,
      courseTitle: courseTitle ?? this.courseTitle,
      category: category ?? this.category,
      price: price ?? this.price,
      status: status ?? this.status,
      date: date ?? this.date,
      imageUrl: imageUrl ?? this.imageUrl,
      studentName: studentName ?? this.studentName,
      email: email ?? this.email,
      transactionId: transactionId ?? this.transactionId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TransactionItem &&
        other.id == id &&
        other.courseTitle == courseTitle &&
        other.category == category &&
        other.price == price &&
        other.status == status &&
        other.date == date &&
        other.imageUrl == imageUrl &&
        other.studentName == studentName &&
        other.email == email &&
        other.transactionId == transactionId;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      courseTitle,
      category,
      price,
      status,
      date,
      imageUrl,
      studentName,
      email,
      transactionId,
    );
  }

  @override
  String toString() {
    return 'TransactionItem(id: $id, courseTitle: $courseTitle, category: $category, price: $price, status: $status, date: $date, imageUrl: $imageUrl, studentName: $studentName, email: $email, transactionId: $transactionId)';
  }
}
