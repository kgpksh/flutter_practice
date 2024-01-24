import 'package:flutter/cupertino.dart';
import 'package:mynotes/utilities/dialog/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog(
      context: context,
      title: 'Delete',
      content: 'Are you sure to want to delete this item',
      optionBuilder: () => {
        'Cancel' : false,
        'Yes' : true,
      },
  ).then(
      (value) => value ?? false
  );
}