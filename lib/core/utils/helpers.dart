import 'dart:math';

import 'package:intl/intl.dart';

class Helpers {
  static String generateOtp() {
    final random = Random();
    int number = 1000 + random.nextInt(9000);
    return number.toString();
  }

  static String timeAgo(int millisecondsSinceEpoch) {
    // Convert milliseconds to DateTime object
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);

    Duration diff = DateTime.now().difference(dateTime);

    if (diff.inDays > 365) return DateFormat.yMMMd().format(dateTime);
    if (diff.inDays > 30) return DateFormat.yMMMd().format(dateTime);
    if (diff.inDays > 7) {
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
    }
    if (diff.inDays > 0) {
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
    }
    if (diff.inHours > 0) {
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
    }
    if (diff.inMinutes > 0) {
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
    }
    return "just now";
  }

  static String timeLeft(dynamic input) {
    DateTime targetDateTime;

    // Check if input is a timestamp (in milliseconds) or DateTime
    if (input is int) {
      targetDateTime = DateTime.fromMillisecondsSinceEpoch(input);
    } else if (input is DateTime) {
      targetDateTime = input;
    } else {
      return "Invalid input";
    }

    // Get the difference between now and the target time
    Duration diff = targetDateTime.difference(DateTime.now());

    // Debugging print
    print("Current time: ${DateTime.now()}");
    print("Target DateTime: $targetDateTime");
    print("Difference in seconds: ${diff.inSeconds}");

    // If the deadline has passed
    if (diff.isNegative) {
      return "Expired";
    }

    if (diff.inSeconds <= 60) {
      return "less than a minute left";
    }

    if (diff.inMinutes < 60) {
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} left";
    }

    if (diff.inHours < 24) {
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} left";
    }

    if (diff.inDays < 30) {
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} left";
    }

    if (diff.inDays < 365) {
      return "${(diff.inDays / 30).floor()} ${((diff.inDays / 30).floor() == 1) ? "month" : "months"} left";
    }

    return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} left";
  }

  static String formatTimeDifference(Duration timeDifference, String time) {
    int totalMinutes = timeDifference.inMinutes.abs();

    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;

    if (timeDifference.isNegative) {
      if (hours > 0) {
        return '$hours hour${hours > 1 ? 's' : ''} ${minutes > 0 ? '$minutes minute${minutes > 1 ? 's' : ''}' : ''} before $time';
      } else {
        return '$minutes minute${minutes > 1 ? 's' : ''} before $time';
      }
    }

    if (hours > 0) {
      if (minutes > 0) {
        return '$hours hour${hours > 1 ? 's' : ''} $minutes minute${minutes > 1 ? 's' : ''} after $time';
      } else {
        return '$hours hour${hours > 1 ? 's' : ''} after $time';
      }
    } else {
      return '$minutes minute${minutes > 1 ? 's' : ''} after $time';
    }
  }

  static String formatTime(Duration timeDifference) {
    int totalMinutes = timeDifference.inMinutes.abs();

    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;

    if (timeDifference.isNegative) {
      if (hours > 0) {
        return '$hours hour${hours > 1 ? 's' : ''} ${minutes > 0 ? '$minutes minute${minutes > 1 ? 's' : ''}' : ''}';
      } else {
        return '$minutes minute${minutes > 1 ? 's' : ''}';
      }
    }

    if (hours > 0) {
      if (minutes > 0) {
        return '$hours hour${hours > 1 ? 's' : ''} $minutes minute${minutes > 1 ? 's' : ''}';
      } else {
        return '$hours hour${hours > 1 ? 's' : ''}';
      }
    } else {
      return '$minutes minute${minutes > 1 ? 's' : ''}';
    }
  }

  int _sequenceCounter = 0;
  String generateUid() {
    _sequenceCounter++;
    return 'SIS-${_sequenceCounter.toString().padLeft(4, '0')}';
  }
}
