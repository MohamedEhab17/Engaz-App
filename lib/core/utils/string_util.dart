String initials(String name) {
  var p = name.trim().split(' ').where((x) => x.isNotEmpty).toList();
  return p.length == 1
      ? p[0][0].toUpperCase()
      : (p[0][0] + p[1][0]).toUpperCase();
}
