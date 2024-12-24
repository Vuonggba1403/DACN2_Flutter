import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void showCustomDelightToastBar(BuildContext context, String message) {
  DelightToastBar(
    builder: (context) {
      return ToastCard(
          color: Colors.grey,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FaIcon(
                FontAwesomeIcons.android,
                color: Colors.black,
                size: 20,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                message,
                style: const TextStyle(
                  fontFamily: "OpenSans",
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ));
    },
    position: DelightSnackbarPosition.bottom,
    autoDismiss: true,
    snackbarDuration: const Duration(seconds: 2),
  ).show(context);
}
