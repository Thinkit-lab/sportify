// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class MyDropdownButtonFormField extends StatefulWidget {
  // var dropdownValueController = TextEditingController();
  const MyDropdownButtonFormField({super.key});

  

  @override
  _MyDropdownButtonFormFieldState createState() => _MyDropdownButtonFormFieldState();
}

class _MyDropdownButtonFormFieldState extends State<MyDropdownButtonFormField> {
  final List<String> dropdownItems = ['Football', 'Basketball', 'Ice Hockey', 'Motorsports', 'Bandy', 'Rugby'];
  var dropdownValueController = TextEditingController();

  String get getController {
    return dropdownValueController.text;
  }

  @override
  void initState() {
    super.initState();
    dropdownValueController.text = dropdownItems.first;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: dropdownValueController.text,
      items: dropdownItems.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),),
        );
      }).toList(),
      onChanged: (String? val) {
        if (val != null) {
          setState(() {
            dropdownValueController.value = dropdownValueController.value.copyWith(text: val);
          });
        }
      },
      decoration: InputDecoration(
        labelText: 'Select Interest',
        iconColor: Colors.teal,
        fillColor: Colors.teal,
        prefixIconColor: Colors.teal,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  void dispose() {
    dropdownValueController.dispose();
    super.dispose();
  }
}