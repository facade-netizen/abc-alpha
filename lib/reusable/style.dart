import 'package:flutter/material.dart';

import 'colors.dart';

const TextStyle tfLabelStyle = TextStyle(fontSize: 20, color: green, fontWeight: FontWeight.bold);

const TextStyle tfLabelStyle2 = TextStyle(color: green);

InputDecoration tfInputDecoration = InputDecoration(
  filled: true,
  fillColor: white,
  hintStyle: TextStyle(color: grey, fontSize: 14),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: black, width: 2),
    borderRadius: BorderRadius.circular(5),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide(color: grey),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide(color: grey),
  ),
);

InputDecoration passwordInputDecoration = const InputDecoration(
  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: green)),
  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: grey)),
  border: OutlineInputBorder(borderSide: BorderSide(color: green)),
);
const TextStyle defaultCellStyle = TextStyle(color: black, fontSize: 12, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w300);
TextStyle n12ts = TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: black);
TextStyle n15ts = TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: black);
TextStyle b14ts = TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: black);
TextStyle b22ts = const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: black);
TextStyle b12ts = const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: black);
TextStyle b16ts = const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: black);
TextStyle b13ts({Color? color}) {
  return TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color ?? black);
}