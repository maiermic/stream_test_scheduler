// Copyright (c) 2015, Michael Maier. All rights reserved. Use of this source code
// is governed by a MIT-style license that can be found in the LICENSE file.

library stream_test_scheduler.record;

abstract class Record implements Comparable {
  final Duration ticks;
  Record(this.ticks);

  @override
  int compareTo(other) => ticks.compareTo(other.ticks);
}

class OnNextRecord extends Record {
  final value;
  OnNextRecord(Duration ticks, this.value) : super(ticks);

  @override
  String toString() => 'onNext($value)@${ticks.inMilliseconds}';
}

class OnErrorRecord extends Record {
  final exception;
  OnErrorRecord(Duration ticks, this.exception) : super(ticks);

  @override
  String toString() => 'onError($exception)@${ticks.inMilliseconds}';
}

class OnCompletedRecord extends Record {
  OnCompletedRecord(Duration ticks) : super(ticks);

  @override
  String toString() => 'onCompleted()@${ticks.inMilliseconds}';
}
