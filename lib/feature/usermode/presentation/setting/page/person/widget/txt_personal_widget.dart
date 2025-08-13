import 'package:flutter/material.dart';
import 'package:m9/core/config/theme/app_color.dart';

class TxtPersonalWidget extends StatefulWidget {
  final TextEditingController controller;
  final IconData icon;
  final String name;
  final TextInputType type;
  const TxtPersonalWidget({
    super.key,
    required this.controller,
    required this.icon,
    required this.name,
    required this.type,
  });

  @override
  State<TxtPersonalWidget> createState() => _TxtPersonalWidgetState();
}

class _TxtPersonalWidgetState extends State<TxtPersonalWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        initialValue: "",
        onChanged: (value) {
          setState(() {
            widget.controller.text = value;
          });
        },
        keyboardType: widget.type,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 10),
          border: InputBorder.none,
          prefixIcon: Icon(widget.icon, color: Colors.indigo.shade800),
          hintText: widget.name,
        ),
      ),
    );
  }
}
