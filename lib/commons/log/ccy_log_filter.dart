import 'package:logger/logger.dart';

class MyFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    // if(event.level == Level.debug || event.level == Level.info){
    //   return false;
    // }
    return true;
  }
}