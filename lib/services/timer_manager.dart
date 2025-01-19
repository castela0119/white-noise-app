import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerManager {
  Duration _remainingTime; // 현재 남은 시간
  bool _isTimerRunning = false; // 타이머 실행 여부
  Timer? _timer;

  // 타이머 상태를 UI와 동기화하기 위한 ValueNotifier
  final ValueNotifier<Duration> remainingTimeNotifier;
  final ValueNotifier<bool> isTimerRunningNotifier;

  // 타이머 상태 변경 시 호출되는 콜백
  Function(Duration remainingTime, bool isRunning)? onTimerUpdate;

  TimerManager({required Duration initialTime})
      : _remainingTime = initialTime,
        remainingTimeNotifier = ValueNotifier(initialTime),
        isTimerRunningNotifier = ValueNotifier(false);

  // 타이머 시작
  void startTimer() {
    if (_isTimerRunning || _remainingTime <= Duration.zero) return;

    _isTimerRunning = true;
    isTimerRunningNotifier.value = true; // 상태 업데이트
    onTimerUpdate?.call(_remainingTime, _isTimerRunning); // 콜백 호출
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > Duration.zero) {
        _remainingTime -= const Duration(seconds: 1);
        remainingTimeNotifier.value = _remainingTime; // 상태 업데이트
        onTimerUpdate?.call(_remainingTime, _isTimerRunning); // 콜백 호출
      } else {
        stopTimer(); // 타이머 종료
      }
    });
  }

  // 타이머 정지
  void stopTimer() {
    _isTimerRunning = false;
    isTimerRunningNotifier.value = false; // 상태 업데이트
    onTimerUpdate?.call(_remainingTime, _isTimerRunning); // 콜백 호출
    _timer?.cancel();
  }

  // 타이머 초기화
  void resetTimer(Duration newTime) {
    stopTimer();
    _remainingTime = newTime;
    remainingTimeNotifier.value = newTime; // 상태 업데이트
    onTimerUpdate?.call(_remainingTime, _isTimerRunning); // 콜백 호출
  }

  // 현재 상태 Getter
  Duration get remainingTime => _remainingTime;
  bool get isTimerRunning => _isTimerRunning;

  // 자원 해제
  void dispose() {
    _timer?.cancel();
    remainingTimeNotifier.dispose();
    isTimerRunningNotifier.dispose();
  }
}
