import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonType;
  final String label;
  final Function onPressedCallback;

  const CustomButton(
      {super.key,
      required this.label,
      required this.onPressedCallback,
      required this.buttonType});

  Widget _buildFromType() {
    switch (buttonType) {
      case 'primary':
        return _buildPrimaryButton();
      case 'primaryOutline':
        return _buildPrimaryOutlineButton();
      default:
        return const Text('The button type is not defined');
    }
  }

  // Primary bottom builder
  Widget _buildPrimaryButton() {
    return Container(
      margin: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0)),
        onPressed: () {
          onPressedCallback();
        },
        child: Text(label, style: const TextStyle(color: Color(0xff01d25a))),
      ),
    );
  }

  // Primary outline bottom builder
  Widget _buildPrimaryOutlineButton() {
    return Container(
      margin: const EdgeInsets.all(4.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.white),
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0)),
        onPressed: () {
          onPressedCallback();
        },
        child: Text(label, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      child: _buildFromType(),
    );
  }
}
