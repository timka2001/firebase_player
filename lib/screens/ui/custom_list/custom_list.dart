import 'package:flutter/material.dart';

Widget customListTile(
    {required String title,
    required String single,
    required String cover,
    onTap}) {
  return ListTile(
      onTap: onTap,
      tileColor: Color.fromRGBO(18, 18, 18, 18),
      textColor: Colors.white,
      iconColor: Colors.white,
      leading: ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: 44, minHeight: 44, maxWidth: 64, minWidth: 64),
        child: Image.network(cover),
      ),
      title: Text(
        title,
        textAlign: TextAlign.left,
      ),
      subtitle: Text(
        single,
        textAlign: TextAlign.start,
      ));
}
