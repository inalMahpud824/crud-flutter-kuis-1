import 'package:flutter/material.dart';

class AppForm extends StatefulWidget {
  // Required for form validations
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Handles text onchange
  TextEditingController nameController;
  TextEditingController ageController;

  AppForm({required this.formKey, required this.nameController,required this.ageController});

  @override
  _AppFormState createState() => _AppFormState();
}

class _AppFormState extends State<AppForm> {
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 3) {
      return 'Name must be more than 2 characters';
    }
    return null;
  }

  String? _validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Age is required';
    }
    RegExp regex = RegExp(r'(?<=\s|^)\d+(?=\s|$)');
    if (!regex.hasMatch(value)) {
      return 'Age must be a number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: widget.nameController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: 'Name'),
            validator: _validateName,
          ),
          TextFormField(
            controller: widget.ageController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Age'),
            validator: _validateAge,
          ),
        ],
      ),
    );
  }
}
