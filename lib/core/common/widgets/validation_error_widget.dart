import 'package:flutter/material.dart';

class ValidationErrorWidget extends StatelessWidget {
  final dynamic state;
  final String fieldName;

  const ValidationErrorWidget(
      {super.key, required this.state, required this.fieldName});

  @override
  Widget build(BuildContext context) {
    if (state.validationErrors != null &&
        state.validationErrors!.isNotEmpty &&
        state.validationErrors!.containsKey(fieldName) &&
        state.validationErrors![fieldName]!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          state.validationErrors![fieldName]![0],
          style: const TextStyle(fontSize: 12, color: Colors.red),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
