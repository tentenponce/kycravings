import 'package:injectable/injectable.dart';

abstract interface class DateTimeUtils {
  DateTime now();
  String ago(DateTime dateTime);
}

@LazySingleton(as: DateTimeUtils)
class DateTimeUtilsImpl implements DateTimeUtils {
  @override
  DateTime now() => DateTime.now();

  @override
  String ago(DateTime dateTime) {
    final date2 = DateTime.now();
    final difference = date2.difference(dateTime);

    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month${difference.inDays > 59 ? 's' : ''} ago';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else if (difference.inSeconds > 5) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
}
