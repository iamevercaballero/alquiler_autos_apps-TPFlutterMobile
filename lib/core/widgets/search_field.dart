import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  const SearchField({super.key, required this.hint, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Buscar...', border: OutlineInputBorder()),
        onChanged: onChanged,
      ),
    );
  }
}
