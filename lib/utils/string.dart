int compareVersion(String version1, String version2, [int length = 3]) {
  var v1 = version1.split('.')
    ..remove('')
    ..addAll(List<String>.filled(length, '0'))
    ..sublist(0, length);
  var v2 = version2.split('.')
    ..remove('')
    ..addAll(List<String>.filled(length, '0'))
    ..sublist(0, length);

  for (var i in List<int>.generate(length, (i) => i)) {
    var v11 = int.parse(v1[i]);
    var v22 = int.parse(v2[i]);
    if (v11 > v22) {
      return 1;
    } else if (v11 < v22) {
      return -1;
    }
  }
  return 0;
}
