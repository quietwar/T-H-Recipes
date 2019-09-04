import 'package:flutter/material.dart';

class Notifications {
  Notifications._();

  static void showSnackBarWithError(BuildContext context, String message,
      {Key key}) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        key: key,
        content: Text('${message ?? 'Sorry, an error has ocurred.'}'),
      ),
    );
  }

  static void showSnackBarWithSuccess(BuildContext context, String message,
      {Key key}) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        key: key,
        content: Text('${message ?? 'Success.'}'),
      ),
    );
  }
}
