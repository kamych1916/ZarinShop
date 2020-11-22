import 'dart:async';

import 'package:rxdart/rxdart.dart';

class Event<T> {
  BehaviorSubject<T> subject = new BehaviorSubject<T>();

  Event({T initValue}) {
    if (initValue != null) subject.sink.add(initValue);
  }

  Stream<T> get stream => subject.stream;

  T get value => subject.value;

  StreamSubscription<T> listen(void callback(T event)) =>
      stream.listen(callback);

  publish(T event) => subject.sink.add(event);

  error(T error) => subject.addError(error);

  dispose() async {
    await subject.drain();
    subject.close();
  }
}
