import 'package:flutter/material.dart';

class BookingSelector extends StatelessWidget {
  const BookingSelector({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: "OVA111",

      decoration: const InputDecoration(
        labelText: "Booking",
      ),

      items: const [
        DropdownMenuItem(
          value: "OVA111",
          child: Text(
            "01/09/26 - 31/08/27 • OVA111",
          ),
        ),
      ],

      onChanged: (_) {},
    );
  }
}