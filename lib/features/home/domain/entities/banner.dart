/// Banner entity for domain layer
class Banner {
  final String? id;
  final String? title;
  final String? description;
  final String? buttonText;
  final String? imageUrl;
  final String? url;
  final String? backgroundGradient;
  final String? backgroundColor;
  final bool? active;
  final String? createdAt;
  final String? createdUser;

  const Banner({
    this.id,
    this.title,
    this.description,
    this.buttonText,
    this.imageUrl,
    this.url,
    this.backgroundGradient,
    this.backgroundColor,
    this.active,
    this.createdAt,
    this.createdUser,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Banner && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
