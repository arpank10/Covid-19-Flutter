import 'package:flutter/material.dart';

Size screenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

double screenHeight(BuildContext context, {double dividedBy = 1}) {
  int h = screenSize(context).height~/dividedBy;
  return h.toDouble();
}

double screenWidth(BuildContext context, {double dividedBy = 1}) {
  int w = screenSize(context).width~/dividedBy;
  return w.toDouble();
}
