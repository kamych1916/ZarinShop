import 'dart:async';

import 'package:rxdart/rxdart.dart';

class Event<T> {
  BehaviorSubject<T> _subject = new BehaviorSubject<T>();

  Event({T initValue}) {
    if (initValue != null) _subject.sink.add(initValue);
  }

  Stream<T> get stream => _subject.stream;

  T get value => _subject.value;

  StreamSubscription<T> listen(void callback(T event)) =>
      stream.listen(callback);

  publish(T event) => _subject.sink.add(event);

  error(T error) => _subject.addError(error);

  dispose() async {
    await _subject.drain();
    _subject.close();
  }
}
