import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

/// Удобное отладочное меню
class DebugPopupMenu extends StatelessWidget {
  const DebugPopupMenu({
    Key key,
    this.items,
    this.top,
    this.bottom,
    this.left,
    this.right,
  }) : super(key: key);

  final Map<String, void Function()> items;
  final double top;
  final double bottom;
  final double left;
  final double right;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: PopupMenuButton(
        icon: const Icon(Icons.pan_tool_outlined),
        onSelected: (v) => v.value?.call(),
        itemBuilder: (context) {
          return items.entries.map((e) {
            return PopupMenuItem(
              child: Text(e.key),
              value: e,
            );
          }).toList();
        },
      ),
    );
  }
}

/// Постройка виджетов с элементом отладки
class DebuggableWidget extends StatelessWidget {
  const DebuggableWidget({
    Key key,
    @required this.mainWidget,
    this.debugItems,
    this.top = 25,
    this.bottom,
    this.left,
    this.right = 5,
  }) : super(key: key);

  final Widget mainWidget;
  final Map<String, void Function()> debugItems;
  final double top;
  final double bottom;
  final double left;
  final double right;

  @override
  Widget build(BuildContext context) {
    if (debugItems != null && kDebugMode) {
      return Stack(
        children: [
          mainWidget,
          DebugPopupMenu(
            right: right,
            top: top,
            items: debugItems,
          ),
        ],
      );
    } else {
      return mainWidget;
    }
  }
}
