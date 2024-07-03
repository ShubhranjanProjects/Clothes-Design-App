import 'package:flutter/material.dart';

class UiHelper {
  static CustomInputField(
      TextEditingController controller, Icon icon, String text, bool hide) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 300, vertical: 15),
      child: TextField(
        controller: controller,
        obscureText: hide,
        decoration: InputDecoration(
          hintText: text,
          suffixIcon: icon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  static alertBoxHelper(BuildContext context, String txt) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(txt),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok'))
            ],
          );
        });
  }
}
