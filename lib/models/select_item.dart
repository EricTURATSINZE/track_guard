class SelectItem {
  final String value;
  final String name;

  SelectItem({
    required this.value,
    required this.name,
  });

  @override
  String toString() {
    return '''
id: $value,
name: $name,
''';
  }
}
