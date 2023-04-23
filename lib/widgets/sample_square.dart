import 'package:flutter/material.dart';

class SampleSquare extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(1);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(height: 20, color: Colors.deepPurple[200]),
    );
  }
}
