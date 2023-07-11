import 'package:flutter/material.dart';

Container indicator(
    {String text = '',
    Color inActiveColor = Colors.pinkAccent,
    bool selected = false}) {
  return Container(
    height: 18,
    width: 18,
    margin: EdgeInsets.only(right: 8),
    decoration: BoxDecoration(
      color: selected ? Colors.white : inActiveColor,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.white),
    ),
    alignment: Alignment.center,
    child: Text(
      text,
      style: TextStyle(
        color: selected ? Colors.white : Colors.black,
      ),
    ),
  );
}

Container indicatorOld(
    {String text = '',
    Color activeColor = Colors.pinkAccent,
    bool selected = false}) {
  return Container(
    height: 18,
    width: 18,
    margin: EdgeInsets.only(right: 8),
    decoration: BoxDecoration(
      color: selected ? activeColor : Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    alignment: Alignment.center,
    child: Text(
      text,
      style: TextStyle(
        color: selected ? Colors.white : Colors.black,
      ),
    ),
  );
}
