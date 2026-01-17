import 'dart:convert';
import 'dart:typed_data';

class PhotoHelper {
  static Uint8List? decodeFromAnything(String raw) {
    final payload = _extractBase64Payload(raw);
    if (payload == null) return null;

    try {
      return base64Decode(base64.normalize(payload));
    } catch (_) {
      return null;
    }
  }

  static String? _extractBase64Payload(String input) {
    var s = input.trim();
    if (s.isEmpty) return null;

    if (s.startsWith('data:image')) {
      final comma = s.indexOf(',');
      if (comma == -1) return null;
      s = s.substring(comma + 1).trim();
    }

    final idx = s.indexOf('/storage/');
    if (idx != -1) {
      s = s.substring(idx + '/storage/'.length).trim();
    }

    s = s.replaceAll('\n', '').replaceAll('\r', '').trim();

    if (s.startsWith('http://') || s.startsWith('https://')) return null;

    if (s.startsWith('/9j/') || s.startsWith('iVBORw0KGgo')) return s;

    return null;
  }
}
