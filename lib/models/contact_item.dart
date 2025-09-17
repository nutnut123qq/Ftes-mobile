class ContactItem {
  final String id;
  final String name;
  final String phoneNumber;
  final bool isInvited;

  ContactItem({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.isInvited = false,
  });

  ContactItem copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    bool? isInvited,
  }) {
    return ContactItem(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isInvited: isInvited ?? this.isInvited,
    );
  }
}
