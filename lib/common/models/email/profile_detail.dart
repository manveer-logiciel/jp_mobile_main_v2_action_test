class EmailProfileDetail {
  final String name;
  final String email;
  final String? imageUrl;
  final String? initial;
  final String? color;
  final String? group;
  

  EmailProfileDetail({required this.name, this.group, required this.email, this.imageUrl, this.initial, this.color});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmailProfileDetail &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return name;
  }}