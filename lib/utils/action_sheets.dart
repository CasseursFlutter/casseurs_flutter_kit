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
    const buttonTextStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600
    );

    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,      
      builder: (modalContext) {        
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 16
              ),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 16
                    ),
                    child: Column(
                      children: [
                        title,
                        if (message != null)
                          ...[
                            const SizedBox(height: 8,),
                            Text(message,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey
                              ),
                            ),
                          ]                          
                      ],
                    ),
                  ),                                    
                  if (actions != null)
                    ...IterableUtils.addBetweenEach(
                      actions.map((e) {
                        return TouchableOpacity(
                          onPressed: e.onPressed,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                if (e.icon != null) e.icon!,
                                Expanded(
                                  child: Text(
                                    e.title,
                                    textAlign: TextAlign.center,
                                    style: buttonTextStyle
                                  )
                                )
                              ],
                            ),
                          )                                                    
                        );
                      }),
                      element: const SizedBox(height: 8,)
                    ).toList()
                ],
              ),
            ),
            if (cancelAction != null)
              ...[
                const SizedBox(height: 16,),
                TouchableOpacity(
                  onPressed: () {
                    cancelAction.onPressed?.call();
                    Navigator.of(modalContext).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    color: Colors.white,
                    child: Text(cancelAction.title,
                      textAlign: TextAlign.center,
                      style: buttonTextStyle,
                    ),
                  ),
                )
              ]
          ],
        );                                 
      }
    );
  }
}