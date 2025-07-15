import 'package:http_parser/http_parser.dart'; // Required for MediaType

class AccountUtils {

  static  MediaType getMediaType(String filePath) {
    final ext = filePath.toLowerCase();
    if (ext.endsWith('.png')) return MediaType('image', 'png');
    return MediaType('image', 'jpeg'); // default fallback
  }

}