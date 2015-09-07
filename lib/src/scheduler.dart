// Copyright (c) 2015, Michael Maier. All rights reserved. Use of this source code
// is governed by a MIT-style license that can be found in the LICENSE file.

library stream_test_scheduler.scheduler;

import 'dart:async';

import 'package:stream_test_scheduler/src/record.dart';
import 'package:stream_test_scheduler/src/record_aux.dart';

class TestScheduler {
  final _SchedulerTasks _tasks;

  TestScheduler() : _tasks = new _SchedulerTasks();

  Stream createStream(List<Record> records) {
    final controller = new StreamController(sync: true);
    _tasks.add(controller, records);
    return controller.stream;
  }

  Future<List<Record>> startWithCreate(Stream createStream()) {
    final completer = new Completer<List<Record>>();
    final records = <Record>[];
    final start = new DateTime.now();
    int timeStamp() {
      final current = new DateTime.now();
      return current.difference(start).inMilliseconds;
    }
    createStream().listen((event) => records.add(onNext(timeStamp(), event)),
        onError: (exception) => records.add(onError(timeStamp(), exception)),
        onDone: () {
      records.add(onCompleted(timeStamp()));
      completer.complete(records);
    });
    _tasks.run();
    return completer.future;
  }
}

class _SchedulerTasks {
  Map<Record, StreamController> _controllers = {};
  List<Record> _records = [];

  void add(StreamController controller, List<Record> records) {
    for (var record in records) {
      _controllers[record] = controller;
    }
    _records.addAll(records);
  }

  void run() {
    _records.sort();
    for (var record in _records) {
      final controller = _controllers[record];
      new Future.delayed(record.ticks, () {
        if (record is OnNextRecord) {
          controller.add(record.value);
        } else if (record is OnErrorRecord) {
          controller.addError(record.exception);
        } else if (record is OnCompletedRecord) {
          controller.close();
        }
      });
    }
  }
}
