import 'package:uuid/uuid.dart';

class CommonUuid {
  static final Uuid _uuid = Uuid();

  /// Generate a random UUID (v4)
  static String generateUUID() {
    return _uuid.v4();
  }

  /// Generate a time-based UUID (v1)
  static String generateTimeUUID() {
    return _uuid.v1();
  }

 // String id = CommonUtils.generateUUID();
}
