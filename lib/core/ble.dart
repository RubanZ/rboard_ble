class BLEManager {
  static final BLEManager _instance = BLEManager._();

  factory BLEManager() => _instance;

  BLEManager._();

  Future<void> init() async {
    return;
  }
}
