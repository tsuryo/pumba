import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pumba_project/dao/shared_prefs.dart';
import 'package:pumba_project/dao/users_repository.dart';
import 'package:pumba_project/utils/location_manager.dart';
import 'package:pumba_project/utils/notifications_manager.dart';

class MainViewModel extends ChangeNotifier {
  final SharedPrefs _sharedPrefs;
  final LocationManager _locationManager;
  final UsersRepository _usersRepository;
  final NotificationsManager _notificationsManager;

  bool _isLoadingGeo = false;
  bool _isDeleting = false;
  bool _shouldShowNotificationBtn = true;

  String? _helloText;
  String? _locationText;

  MainViewModel(this._sharedPrefs)
      : _locationManager = LocationManager(),
        _usersRepository = UsersRepository(),
        _notificationsManager = NotificationsManager() {
    _fetchUser();
    _checkForGeoPermission();
  }

  bool get isLoadingGeo => _isLoadingGeo;

  bool get isDeleting => _isDeleting;

  bool get shouldShowNotificationBtn => _shouldShowNotificationBtn;

  String? get helloText => _helloText;

  String? get locationText => _locationText;

  void _checkForGeoPermission() async {
    final hasPermission = await _locationManager.isPermissionGranted();
    if (hasPermission) {
      fetchLocation();
    } else {
      // _shouldShowGeoBtn = true;
      _isLoadingGeo = false;
      notifyListeners();
    }
  }

  Future<void> fetchLocation() async {
    _isLoadingGeo = true;
    notifyListeners();
    try {
      final position = await _locationManager.getCurrentLocation();
      _locationText = "Location: ${position.latitude}, ${position.longitude}";
    } catch (e) {
      _locationText = e.toString();
    }
    _isLoadingGeo = false;
    notifyListeners();
  }

  void _fetchUser() async {
    final user = await _usersRepository.getUser(_sharedPrefs.userId!);
    if (user != null) {
      _helloText =
          "Hello ${user.firstName}, ${user.lastName} how are you today?";
    } else {
      _helloText = "No User Found";
    }
    notifyListeners();
  }

  Future<void> showNotification() async {
    DateTime? scheduledTime =
        await _notificationsManager.scheduleNotification();
    if (scheduledTime != null) {
      _shouldShowNotificationBtn = false;
      notifyListeners();
      Timer.periodic(
        Duration(seconds: 1),
        (timer) {
          final now = DateTime.now();
          final remainingDuration = scheduledTime.difference(now);

          if (remainingDuration.isNegative) {
            timer.cancel();
            _helloText = "Notification is shown!";
            notifyListeners();
            return;
          }

          final hours = remainingDuration.inHours;
          final minutes = remainingDuration.inMinutes.remainder(60);
          final seconds = remainingDuration.inSeconds.remainder(60);
          final formattedTime = DateFormat("HH:mm:ss").format(
            DateTime(0, 0, 0, hours, minutes, seconds),
          );
          _helloText = "The notification will appear at: $formattedTime";
          notifyListeners();
        },
      );
    }
  }

  void deleteUser() async {
    _isDeleting = true;
    notifyListeners();
    bool deleted = await _usersRepository.deleteUser(_sharedPrefs.userId!);
    if (deleted) {
      _sharedPrefs.setUserId(null);
    } else {
      _helloText = "Failed to delete user.";
    }
    _isDeleting = false;
    notifyListeners();
  }
}
