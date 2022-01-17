import 'dart:io';

import 'package:casseurs_flutter_kit/casseurs_flutter_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActionSheetAction {
  final String title;
  final Widget? icon;
  final Function()? onPressed;  
  final bool isDefault;
  final bool isDestructive;

  ActionSheetAction({
    required this.title,
    this.icon,
    this.onPressed,
    this.isDefault = false,
    this.isDestructive = false
  });
}

Future<void> showActionSheet({
  required BuildContext context,
  required Widget title,
  String? message,
  List<ActionSheetAction>? actions,
  ActionSheetAction? cancelAction
}) async {
  if (Platform.isIOS) {
    return showCupertinoModalPopup(
      context: context,
      builder: (modalContext) {
        return CupertinoActionSheet(          
          title: title,
          message: message != null
            ? Text(message)
            : null,
          cancelButton: cancelAction != null
            ? CupertinoActionSheetAction(                
                child: Text(cancelAction.title),
                onPressed: Navigator.of(modalContext).pop,
              )
            : null,          
          actions: actions?.map((e) => CupertinoActionSheetAction(
            onPressed: () {
              e.onPressed?.call();
              Navigator.of(modalContext).pop();
            },
            child: Text(e.title),
            isDefaultAction: e.isDefault,
            isDestructiveAction: e.isDestructive,
          )).toList(),
        );
      }
    );
  } else {
    return showModalBottomSheet(
      context: context,
      builder: (modalContext) {
        return Container(
          child: Column(
            children: [
              title,
              if (message != null)
                Text(message),
              if (actions != null)
                ...actions.map((e) {
                  return TouchableOpacity(
                    onPressed: e.onPressed,
                    child: Row(
                      children: [
                        if (e.icon != null) e.icon!,
                        Expanded(
                          child: Text(e.title)
                        )
                      ],
                    )
                  );
                }).toList()
            ],
          ),
        );
      }
    );
  }
}