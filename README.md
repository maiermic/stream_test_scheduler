# stream_test_scheduler

Test if a stream emits elements at a certain time (window). It works similar to [TestScheduler][1] in [RxJS][2], but it uses real time (milliseconds) instead of virtual time, since you can't fake time in Dart (see [Irn's comment][3] on stackoverflow). You can pass a maximum deviation to the matcher to specify a time window.

  [1]: https://github.com/Reactive-Extensions/RxJS/blob/master/doc/api/testing/testscheduler.md
  [2]: https://github.com/Reactive-Extensions/RxJS
  [3]: http://stackoverflow.com/questions/32345853/dart-how-to-test-if-stream-emits-elements-at-a-certain-time#comment52575633_32345853

## Usage

This example tests the function `Stream delay(Stream input, Duration duration)` (from [stream_ext][stream_ext] package) that time shifts elements on a stream `input` by `duration`. The relative time intervals between the values are preserved.

    import 'dart:async';
    
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

I use a maximum deviation of 20 milliseconds in this example. But deviation varies. You might have to use a different maximum deviation value for another test or on another (faster/slower) system.

  [stream_ext]: https://pub.dartlang.org/packages/stream_ext 

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

  [tracker]: https://github.com/maiermic/stream_test_scheduler/issues
