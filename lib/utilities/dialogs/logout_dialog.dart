import 'package:flutter/material.dart';
import 'package:success_planner/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Log out",
    content: "Are you sure to log out?",
    optionBuilder: () => {
      "Cancel": false,
      "Log out": true,
    },
  ).then(
    (value) => value ?? false,
  );
}
