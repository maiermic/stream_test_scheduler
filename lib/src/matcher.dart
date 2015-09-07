// Copyright (c) 2015, Michael Maier. All rights reserved. Use of this source code
// is governed by a MIT-style license that can be found in the LICENSE file.

library stream_test_scheduler.matcher;

import 'package:matcher/matcher.dart';
import 'package:stream_test_scheduler/src/record.dart';

equalsRecords(List<Record> records, {int maxDeviation: 0}) {
  return pairwiseCompare(records, (Record r1, Record r2) {
    var deviation = (r1.ticks.inMilliseconds - r2.ticks.inMilliseconds).abs();
    if (deviation > maxDeviation) {
      return false;
    }
    if (r1 is OnNextRecord && r2 is OnNextRecord) {
      return r1.value == r2.value;
    }
    if (r1 is OnErrorRecord && r2 is OnErrorRecord) {
      return r1.exception == r2.exception;
    }
    return (r1 is OnCompletedRecord && r2 is OnCompletedRecord);
  }, 'equal with deviation of ${maxDeviation}ms to');
}
