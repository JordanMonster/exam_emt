import 'dart:async';
import 'dart:isolate';

class Worker {
  SendPort? _sendPort;
  Isolate? _isolate;
  final _isolateReady = Completer<void>();
  final Map<Capability, Completer> _completers = {};

  Worker() {
    init();
  }

  void dispose() {
    _isolate?.kill();
  }

  Future executor(dynamic message) async {
    await _isolateReady.future;
    final completer = Completer();
    final requestId = Capability();
    _completers[requestId] = completer;
    _sendPort!.send(_Request(requestId, message));
    return completer.future;
  }

  Future<void> init() async {
    final receivePort = ReceivePort();
    final errorPort = ReceivePort();
    errorPort.listen(print);
    receivePort.listen(_handleMessage);
    _isolate = await Isolate.spawn(
      _isolateEntry,
      receivePort.sendPort,
      onError: errorPort.sendPort,
    );
  }

  void _handleMessage(message) {
    if (message is SendPort) {
      _sendPort = message;
      _isolateReady.complete();
      return;
    }
    if (message is _Response) {
      final completer = _completers[message.requestId];
      if (completer == null) {
        print("Invalid request ID received.");
      } else if (message.success) {
        completer.complete(message.message);
      } else {
        completer.completeError(message.message);
      }
      return;
    }
    throw UnimplementedError("Undefined behavior for message: $message");
  }

  static void _isolateEntry(dynamic message) {
    SendPort? sendPort;
    final receivePort = ReceivePort();

    receivePort.listen((dynamic message) async {
      if (message is _Request) {

        var data = await message.message;

        sendPort?.send(_Response.ok(message.requestId, data));
        return;
      }
    });

    if (message is SendPort) {
      sendPort = message;
      sendPort.send(receivePort.sendPort);
      return;
    }
  }
}

class _Request {
  /// The ID of the request so the response may be associated to the request's future completer.
  final Capability requestId;

  /// The actual message of the request.
  final dynamic message;

  const _Request(this.requestId, this.message);
}

class _Response {
  /// The ID of the request this response is meant to.
  final Capability requestId;

  /// Indicates if the request succeeded.
  final bool success;

  /// If [success] is true, holds the response message.
  /// Otherwise, holds the error that occured.
  final dynamic message;

  const _Response.ok(this.requestId, this.message) : success = true;

  const _Response.error(this.requestId, this.message) : success = false;
}
