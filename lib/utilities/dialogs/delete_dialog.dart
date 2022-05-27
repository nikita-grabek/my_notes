import 'package:flutter/material.dart';
import 'package:success_planner/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Delete",
    content: "Are you sure to delete this item?",
    optionBuilder: () => {
      "Cancel": false,
      "Yes": true,
    },
  ).then(
    (value) => value ?? false,
  );
}
