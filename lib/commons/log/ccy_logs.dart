import 'dart:io';

import 'package:logger/logger.dart';

import '../global.dart';
import 'ccy_log_filter.dart';
import 'ccy_logs_output.dart';

class CcyLogs {
  static CcyLogs? _instance;

  static CcyLogs get instance => initialize();
  late final Logger _logger;

  CcyLogs._() {
    _logger = Logger(
        filter: MyFilter(),
        printer: PrettyPrinter(methodCount: 20,errorMethodCount: 20, colors: false));
  }

  static CcyLogs initialize() {
    return _instance ??= CcyLogs._();
  }

  _tag(String tag) {
    return "${Global.getUserId()}  - ${DateTime.now().toString()} - [ $tag ] \n";
  }

  debug(String logs) {
    _logger.d("${_tag("DEBUG")}$logs");
  }

  info(String logs) {
    _logger.i("${_tag("INFO")}$logs");
  }

  warn(String logs) {
    _logger.w("${_tag("WARN")}$logs");
  }

  error(String logs, [dynamic error, StackTrace? stackTrace]) {
    _logger.e("${_tag("ERROR")}$logs", error, stackTrace);
  }
}
