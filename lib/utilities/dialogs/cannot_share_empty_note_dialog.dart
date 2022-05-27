import 'package:flutter/material.dart';
import 'package:success_planner/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDIalog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: "Sharing",
    content: "You cannot share an empty note!",
    optionBuilder: () => {
      "OK": null,
    },
  );
}
