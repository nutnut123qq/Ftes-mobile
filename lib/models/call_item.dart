class CallItem {
  final String id;
  final String name;
  final String date;
  final CallType type;
  final String avatar;

  const CallItem({
    required this.id,
    required this.name,
    required this.date,
    required this.type,
    required this.avatar,
  });

  factory CallItem.fromJson(Map<String, dynamic> json) {
    return CallItem(
      id: json['id'] as String,
      name: json['name'] as String,
      date: json['date'] as String,
      type: CallType.values.firstWhere(
        (e) => e.toString() == 'CallType.${json['type']}',
        orElse: () => CallType.incoming,
      ),
      avatar: json['avatar'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'type': type.toString().split('.').last,
      'avatar': avatar,
    };
  }
}

enum CallType {
  incoming,
  outgoing,
  missed,
}
