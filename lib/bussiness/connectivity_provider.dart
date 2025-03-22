import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider with ChangeNotifier {
  bool _isConnected = true;
  bool get isConnected => _isConnected;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  ConnectivityProvider() {
    _subscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    initializeConnectionStatus();
  }

  Future<void> initializeConnectionStatus() async {
    final status = await _connectivity.checkConnectivity();
    _updateConnectionStatus(status);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    _isConnected =
        results.isNotEmpty && !results.contains(ConnectivityResult.none);
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
