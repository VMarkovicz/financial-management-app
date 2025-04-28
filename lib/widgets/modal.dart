import 'package:flutter/material.dart';

class Modal extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget> actions;

  const Modal({
    super.key,
    required this.title,
    required this.body,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  static Future<void> show({
    required BuildContext context,
    required String title,
    required Widget body,
    required List<Widget> actions,
  }) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 26),
          titlePadding: const EdgeInsets.symmetric(
            horizontal: 26,
            vertical: 16,
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 26,
            vertical: 16,
          ),
          title: Text(title),
          content: body,
          actions: [
            SizedBox(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:
                    actions
                        .map(
                          (action) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: action,
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
