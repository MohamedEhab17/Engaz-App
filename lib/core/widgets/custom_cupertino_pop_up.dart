import 'package:easy_localization/easy_localization.dart';
import 'package:engaz_app/core/theme/app_text_styles.dart';
import 'package:engaz_app/core/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<dynamic> customCupertinoPopUp(
  BuildContext context, {
  required String title,
  required Widget content,
  required final String buttonText,
  void Function()? onPressed,
  void Function()? cancelOnPressed,
  bool barrierDismissible = false,
}) {
  return showCupertinoModalPopup(
    barrierDismissible: barrierDismissible,

    context: context,
    builder: (context) {
      return CupertinoPopupSurface(
        child: Material(
          //!  using material design for TextFormField
          type: MaterialType.transparency,
          child: SingleChildScrollView(
            padding: MediaQuery.of(context).viewInsets.bottom.bottomPadding,
            child: Padding(
              padding: 16.allPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 6,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      title.tr(),
                      style: AppTextStyles.body20(context),
                    ),
                  ),
                  content,

                  12.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CupertinoButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          if (cancelOnPressed != null) {
                            cancelOnPressed();
                          }
                        },
                        child: Text("cancel".tr()),
                      ),
                      CupertinoButton.filled(
                        onPressed: onPressed,
                        child: Text(buttonText.tr()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
