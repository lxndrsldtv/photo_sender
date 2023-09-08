import 'package:flutter/material.dart';

class Steam extends StatelessWidget {
  const Steam({super.key});

  @override
  Widget build(BuildContext context) {
    final l = MediaQuery.of(context).size.width / 10.0;
    return Stack(
      children: [
        Center(
          child: AnimatedOpacity(
            opacity: 0.0,
            duration: const Duration(seconds: 1),
            child: Container(
              width: l,
              height: l,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
