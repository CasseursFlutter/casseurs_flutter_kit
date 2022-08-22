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
  dynamic? content,  
  List<AlertDialogAction>? actions,
  Function(BuildContext context)? onBuild
}) async {
  final targetPlatform = Theme.of(context).platform;
  List<AlertDialogAction> actionList = actions ?? [AlertDialogAction()];

  if (targetPlatform == TargetPlatform.iOS) {
    return showCupertinoDialog(
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
              Navigator.of(context).pop();
              if (action.onPressed != null) action.onPressed!();
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
      barrierDismissible: false,
      builder: (BuildContext context) {
        onBuild?.call(context);
        return AlertDialog(
          title: Text(title),
          content: content != null ? Text(content) : null,
          actions: actionList.map((action) => TextButton(
            onPressed: () {
              if(action.onPressed != null) action.onPressed!();
              Navigator.of(context).pop();
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