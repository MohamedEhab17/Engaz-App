import 'package:easy_localization/easy_localization.dart';
import 'package:engaz_app/core/theme/app_text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<dynamic> customDialog(
  BuildContext context, {
  required String title,
  Widget? content,
  Function()? onPressed,
  String buttonText = "yes",
  String buttonText2 = "cancel",
}) async {

  return await showCupertinoDialog(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title.tr(), style: AppTextStyles.body16SemiBold(context)),
      content: content,
      actions: [
        CupertinoDialogAction(
          onPressed: onPressed,
          child: Text(buttonText.tr(), style: TextStyle(color: Colors.green)),
        ),
        CupertinoDialogAction(
          child: Text(buttonText2.tr(), style: TextStyle(color: Colors.red)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
