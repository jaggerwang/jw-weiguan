Duration durationFromMillseconds(int milliseconds) =>
    Duration(milliseconds: milliseconds);

int durationToMilliseconds(Duration duration) => duration.inMilliseconds;

DateTime dateTimeFromEpochMillseconds(int us) =>
    DateTime.fromMillisecondsSinceEpoch(us);

int dateTimeToEpochMillseconds(DateTime dateTime) =>
    dateTime.millisecondsSinceEpoch;
