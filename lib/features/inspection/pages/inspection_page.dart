import 'package:flutter/material.dart';

class InspectionPage extends StatelessWidget {
  final String inspectionId;

  const InspectionPage({super.key, required this.inspectionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inspection')),
      body: Center(
        child: Text('Inspection details for $inspectionId'),
      ),
    );
  }
}
