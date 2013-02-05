// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library local_service;

import 'dart:isolate';
import 'package:services/src/serialization/json_serialization.dart';
import 'message.dart';

/**
 * A service proxy that forwards service calls over a [SendPort] to an isolate.
 * The receiving isolate must be running a service via the [host] function.
 */
class ServiceProxy {
  final Serializer serializer;
  final SendPort _sendPort;

  ServiceProxy(SendPort sendPort, this.serializer) : _sendPort = sendPort;

  noSuchMethod(InvocationMirror im) {
    var args = serializer.serialize(im.positionalArguments);
    return _sendPort.call(Message.invoke(im.memberName, args))
        .then((reply) => serializer.deserialize(reply['result']));
  }
}
