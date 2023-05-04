import 'dart:async';
import 'package:isolate/isolate_runner.dart';
import 'package:isolate/load_balancer.dart';

class LoadBalancerManager {
  static LoadBalancerManager? _instance;

  static LoadBalancerManager get instance => initialize();
  static late Future<LoadBalancer> _loadBalancer;

  LoadBalancerManager._(){
    _loadBalancer = LoadBalancer.create(5, IsolateRunner.spawn);
  }

  static LoadBalancerManager initialize() {
    return _instance ??= LoadBalancerManager._();
  }

  Future<R> run<R, P>(FutureOr<R> Function(P argument) function, P argument,
      {Duration? timeout = const Duration(seconds: 10),
        FutureOr<R> Function()? onTimeout,
        int load = 100}) async {
    final lb = await _loadBalancer;
    return await lb.run<R, P>(function, argument,
        timeout: timeout, onTimeout: onTimeout, load: load);
  }

  Future<List<Future<R>>> runMultiple<R, P>(
      int count, FutureOr<R> Function(P argument) function, P argument,
      {Duration? timeout= const Duration(seconds: 10),
        FutureOr<R> Function()? onTimeout,
        int load = 100}) async {
    final lb = await _loadBalancer;
    return lb.runMultiple<R, P>(count, function, argument,
        timeout: timeout, onTimeout: onTimeout, load: load);
  }
}