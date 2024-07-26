import 'package:intl/intl.dart';

class RFormatter {
  static String formatDate(DateTime? date) {
    date ??= DateTime.now();
    DateTime now = DateTime.now();
    DateTime given = DateTime(date.year, date.month, date.day);
    DateTime today = DateTime(now.year, now.month, now.day);
    return given == today
        ? "Today ${DateFormat('hh:mma').format(date)}"
        : DateFormat('EEE, d MMM y, hh:mma')
            .format(date); // Customize the date format as needed
  }

  static String formatDuration(Duration duration) {
    // return duration.inDays != 0
    //     ? duration.inDays == 1
    //         ? '${duration.inDays} day ago'
    //         : '${duration.inDays} days ago'
    //     : duration.inHours != 0
    //         ? duration.inHours == 1
    //             ? '${duration.inHours} hour ago'
    //             : '${duration.inHours} hours ago'
    //         : duration.inMinutes != 0
    //             ? duration.inMinutes == 1
    //                 ? '${duration.inMinutes} minute ago'
    //                 : '${duration.inMinutes} minutes ago'
    //             : '${duration.inSeconds} seconds ago';

    return duration.inDays != 0
        ? '${duration.inDays}d'
        : duration.inHours != 0
            ? '${duration.inHours}h'
            : duration.inMinutes != 0
                ? '${duration.inMinutes}m'
                : '${duration.inSeconds}s';
  }

  static String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'en_US', symbol: '\$')
        .format(amount); // Customize the currency locale and symbol as needed
  }

  static String formatPhoneNumber(String phoneNumber) {
    // Assuming a 10-digit US phone number format: (123) 456-7890
    if (phoneNumber.length == 10) {
      return '(${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3, 6)} ${phoneNumber.substring(6)}';
    } else if (phoneNumber.length == 11) {
      return '(${phoneNumber.substring(0, 4)}) ${phoneNumber.substring(4, 7)} ${phoneNumber.substring(7)}';
    }
    // Add more custom phone number formatting logic for different formats if needed.
    return phoneNumber;
  }

  // Not fully tested.
  static String internationalFormatPhoneNumber(String phoneNumber) {
    // Remove any non-digit characters from the phone number
    var digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // Extract the country code from the digitsOnly
    String countryCode = '+${digitsOnly.substring(0, 2)}';
    digitsOnly = digitsOnly.substring(2);

    // Add the remaining digits with proper formatting
    final formattedNumber = StringBuffer();
    formattedNumber.write('($countryCode) ');

    int i = 0;
    while (i < digitsOnly.length) {
      int groupLength = 2;
      if (i == 0 && countryCode == '+1') {
        groupLength = 3;
      }

      int end = i + groupLength;
      formattedNumber.write(digitsOnly.substring(i, end));

      if (end < digitsOnly.length) {
        formattedNumber.write(' ');
      }
      i = end;
    }

    return formattedNumber.toString();
  }

  // for chat
  static String formatTime(DateTime date) {
    return DateFormat('d/M, hh:mm a')
        .format(date); // Customize the date format as needed
  }
}


/*
*
*
* */
