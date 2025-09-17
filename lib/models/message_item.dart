class MessageItem {
  final String id;
  final String content;
  final String time;
  final bool isFromUser;
  final MessageType type;
  final String? imageUrl;
  final int? rating;

  const MessageItem({
    required this.id,
    required this.content,
    required this.time,
    required this.isFromUser,
    this.type = MessageType.text,
    this.imageUrl,
    this.rating,
  });

  factory MessageItem.fromJson(Map<String, dynamic> json) {
    return MessageItem(
      id: json['id'] as String,
      content: json['content'] as String,
      time: json['time'] as String,
      isFromUser: json['isFromUser'] as bool,
      type: MessageType.values.firstWhere(
        (e) => e.toString() == 'MessageType.${json['type']}',
        orElse: () => MessageType.text,
      ),
      imageUrl: json['imageUrl'] as String?,
      rating: json['rating'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'time': time,
      'isFromUser': isFromUser,
      'type': type.toString().split('.').last,
      'imageUrl': imageUrl,
      'rating': rating,
    };
  }
}

enum MessageType {
  text,
  image,
  rating,
}
