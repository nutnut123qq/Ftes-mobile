class NotificationItem {
  final String id;
  final String title;
  final String description;
  final String iconPath;
  final DateTime date;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.date,
    this.isRead = false,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      iconPath: json['iconPath'] as String,
      date: DateTime.parse(json['date'] as String),
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconPath': iconPath,
      'date': date.toIso8601String(),
      'isRead': isRead,
    };
  }

  NotificationItem copyWith({
    String? id,
    String? title,
    String? description,
    String? iconPath,
    DateTime? date,
    bool? isRead,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      date: date ?? this.date,
      isRead: isRead ?? this.isRead,
    );
  }
}
