import 'package:flutter/material.dart';
import 'dart:async';

class TimerProvider extends ChangeNotifier {
  int _timeLeft = 600;
  late Timer _timer;

  int get timeLeft => _timeLeft;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        _timeLeft--;
        notifyListeners();
      } else {
        _timer.cancel();
      }
    });
  }

  void stopTimer() {
    _timer.cancel();
  }
}
