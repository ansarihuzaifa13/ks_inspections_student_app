import 'package:flutter/material.dart';

class ChargePage extends StatelessWidget {
  final String chargeId;

  const ChargePage({super.key, required this.chargeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Charge')),
      body: Center(
        child: Text('Charge details for $chargeId'),
      ),
    );
  }
}
