// Copyright (c) 2015, Michael Maier. All rights reserved. Use of this source code
// is governed by a MIT-style license that can be found in the LICENSE file.

library stream_test_scheduler.example;

import 'package:stream_ext/stream_ext.dart';
import 'package:stream_test_scheduler/stream_test_scheduler.dart';
import 'package:test/test.dart';

main() async {
  test('delay preserves relative time intervals between the values', () async {
    var scheduler = new TestScheduler();

    var source = scheduler.createStream(
        [onNext(150, 1), onNext(200, 2), onNext(230, 3), onCompleted(260)]);

    var result = await scheduler
        .startWithCreate(() => StreamExt.delay(source, ms(1000)));

    expect(
        result,
        equalsRecords([
          onNext(1150, 1),
          onNext(1200, 2),
          onNext(1230, 3),
          onCompleted(1260)
        ], maxDeviation: 20));
  });
}
