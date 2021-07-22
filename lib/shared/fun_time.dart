String readTimestamp(int timestamp) {
  var now = DateTime.now();
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  var diff = now.difference(date);
  var time = '';

  if (diff.inSeconds <= 0 ||
      diff.inSeconds > 0 && diff.inMinutes == 0 ||
      diff.inMinutes > 0 && diff.inHours == 0 ||
      diff.inHours > 0 && diff.inDays == 0) {
    if (diff.inHours > 0) {
      time = diff.inHours.toString() + ' jam lalu';
    } else if (diff.inMinutes > 0) {
      time = diff.inMinutes.toString() + ' menit lalu';
    } else if (diff.inSeconds > 0) {
      time = 'baru saja';
    } else if (diff.inMilliseconds > 0) {
      time = 'baru saja';
    } else if (diff.inMicroseconds > 0) {
      time = 'baru saja';
    } else {
      time = 'baru saja';
    }
  } else if (diff.inDays > 0 && diff.inDays < 7) {
    time = diff.inDays.toString() + ' hari lalu';
  } else if (diff.inDays > 6) {
    time = (diff.inDays / 7).floor().toString() + ' minggu lalu';
  } else if (diff.inDays > 29) {
    time = (diff.inDays / 30).floor().toString() + ' bulan lalu';
  } else if (diff.inDays > 365) {
    time = '${date.month} ${date.day}, ${date.year}';
  }
  return time;
}