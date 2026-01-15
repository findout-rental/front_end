import 'dart:convert';
import 'dart:typed_data';

class PhotoHelper {
  /// يرجّع bytes إذا كانت الصورة Base64 (حتى لو كانت ضمن URL فيه /storage//9j/..)
  static Uint8List? decodeFromAnything(String raw) {
    final payload = _extractBase64Payload(raw);
    if (payload == null) return null;

    try {
      return base64Decode(base64.normalize(payload));
    } catch (_) {
      return null;
    }
  }

  /// يستخرج base64 من:
  /// - data:image/...;base64,xxxx
  /// - /storage//9j/...
  /// - http://host/storage//9j/...
  static String? _extractBase64Payload(String input) {
    var s = input.trim();
    if (s.isEmpty) return null;

    // data:image/...;base64,xxxx
    if (s.startsWith('data:image')) {
      final comma = s.indexOf(',');
      if (comma == -1) return null;
      s = s.substring(comma + 1).trim();
    }

    // إذا كان ضمن URL أو مسار فيه /storage/ خذ كل شي بعد /storage/
    final idx = s.indexOf('/storage/');
    if (idx != -1) {
      s = s.substring(idx + '/storage/'.length).trim();
    }

    // شيل أسطر
    s = s.replaceAll('\n', '').replaceAll('\r', '').trim();

    // إذا بقي URL هون معناها مو base64
    if (s.startsWith('http://') || s.startsWith('https://')) return null;

    // لازم يبدأ ببدايات معروفة
    if (s.startsWith('/9j/') || s.startsWith('iVBORw0KGgo')) return s;

    return null;
  }
}
