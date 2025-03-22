import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class DrawerProvider with ChangeNotifier {
  final ZoomDrawerController _zoomDrawerController = ZoomDrawerController();

  ZoomDrawerController get zoomDrawerController => _zoomDrawerController;

  void openDrawer() {
    _zoomDrawerController.toggle!();
    notifyListeners();
  }

  void closeDrawer() {
    _zoomDrawerController.close!();
    notifyListeners();
  }

  bool isOpen() {
    return _zoomDrawerController.isOpen!();
  }
}
