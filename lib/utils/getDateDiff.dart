import 'package:goods_hunter/common/myError.dart';

String getDateDiff(String lastTimeString) {
  DateTime lastTime = DateTime.parse(lastTimeString);
  DateTime currentTime = DateTime.now();
  Duration millisecondsInterval = currentTime.difference(lastTime);
  if (millisecondsInterval.isNegative) {
    throw HonmaMeikoError("Invalid previous time!");
  }
  if (millisecondsInterval.inSeconds < 60) {
    return "刚刚";
  }
  if (millisecondsInterval.inMinutes < 60) {
    return "${millisecondsInterval.inMinutes}分钟前";
  }
  if (millisecondsInterval.inHours < 24) {
    return "${millisecondsInterval.inHours}小时前";
  }
  if (millisecondsInterval.inDays < 28) {
    return "${millisecondsInterval.inDays}天前";
  }
  return "1个月以前";
}