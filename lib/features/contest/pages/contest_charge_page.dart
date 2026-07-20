import 'package:flutter/material.dart';

class ContestChargePage extends StatelessWidget {
  final String chargeId;

  const ContestChargePage({super.key, required this.chargeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contest Charge')),
      body: Center(
        child: Text('Contest details for $chargeId'),
      ),
    );
  }
}
