import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertDialogAction {
  final bool isDesctructive;
  final Function? onPressed;
  final String title;

  AlertDialogAction({
    this.title = 'Ok',
    this.onPressed,
    this.isDesctructive = false
  });
}

Future<void> showAlertDialog({
  required BuildContext context,
  required String title,
  dynamic content,  
  List<AlertDialogAction>? actions,
  Function(BuildContext context)? onBuild,
  bool barrierDismissible = false,
  bool dismissOnButtonClick = true
}) async {
  final targetPlatform = Theme.of(context).platform;
  List<AlertDialogAction> actionList = actions ?? [AlertDialogAction()];

  if (targetPlatform == TargetPlatform.iOS) {
    return showCupertinoDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (context) {
        onBuild?.call(context);
        return CupertinoAlertDialog(
          title: Text(title),
          content: content != null
            ? content is String
              ? Text(content)
              : content
            : null,
          actions: actionList.map((action) => CupertinoDialogAction(
            child: Text(action.title),
            onPressed: () {
              if (dismissOnButtonClick) {
                Navigator.of(context).pop();
              }
              action.onPressed?.call();
            },
            isDefaultAction: !action.isDesctructive,
            isDestructiveAction: action.isDesctructive,
          )).toList(),
        );
      }
    );
  } else {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        onBuild?.call(context);
        return AlertDialog(
          title: Text(title),
          content: content != null ? Text(content) : null,
          actions: actionList.map((action) => TextButton(
            onPressed: () {
              action.onPressed?.call();
              if (dismissOnButtonClick) {
                Navigator.of(context).pop();
              }
            },
            child: Text(
              action.title,
              style:TextStyle(
                color: action.isDesctructive ? Colors.red : Colors.blue,
              )
            ),
          )).toList(),
        );
      }
    );
  }
}