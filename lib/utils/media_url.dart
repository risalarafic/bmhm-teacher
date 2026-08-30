class MediaUrl {
  MediaUrl._();

  static const String host = 'https://bmhm-qa.org/';

  static String? resolve(String? path) {
    if (path == null) return null;
    final clean = path.trim().replaceAll('\\', '/').replaceAll(RegExp(r'^/+'), '');
    if (clean.isEmpty) return null;
    if (clean.startsWith('http://') || clean.startsWith('https://')) return clean;
    return '$host$clean';
  }

  static List<String> candidates(String? path) {
    final resolved = resolve(path);
    if (resolved == null) return const [];
    if (path != null &&
        (path.startsWith('http://') || path.startsWith('https://'))) {
      return [resolved];
    }
    final clean = path!.trim().replaceAll('\\', '/').replaceAll(RegExp(r'^/+'), '');
    return [
      '$host$clean',
      '${host}backend_parent/$clean',
      '${host}backend_parent/api/$clean',
    ];
  }
}
