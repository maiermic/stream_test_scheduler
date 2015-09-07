// Copyright (c) 2015, Michael Maier. All rights reserved. Use of this source code
// is governed by a MIT-style license that can be found in the LICENSE file.

library stream_test_scheduler.record_aux;

import 'package:stream_test_scheduler/src/record.dart';

onNext(int ticks, value) => new OnNextRecord(ms(ticks), value);

onCompleted(int ticks) => new OnCompletedRecord(ms(ticks));

onError(int ticks, exception) => new OnErrorRecord(ms(ticks), exception);

Duration ms(int milliseconds) => new Duration(milliseconds: milliseconds);
