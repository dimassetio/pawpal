import 'package:flutter/material.dart';

class PPMainContainer extends StatelessWidget {
  const PPMainContainer({
    super.key,
    required this.children,
    required this.scrollable,
  });
  final bool scrollable;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(20),
        child: scrollable
            ? SingleChildScrollView(
                child: Column(
                  children: children,
                ),
              )
            : Column(
                children: children,
              ),
      ),
    );
  }
}
