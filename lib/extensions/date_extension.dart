extension DateTimeExtension on DateTime {

  String formatTime(){
    String hourStr = hour.toString().padLeft(2, "0");
    String minutesStr = minute.toString().padLeft(2, "0");
    String secondsStr = second.toString().padLeft(2, "0");
    return "$hourStr:$minutesStr:$secondsStr";
  }

}