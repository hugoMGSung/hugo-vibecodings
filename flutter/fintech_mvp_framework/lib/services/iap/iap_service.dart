// Stub for In-App Purchase service to remove ads, sell hints, etc.
abstract class IapService {
  Future<void> init();
  Future<bool> purchaseRemoveAds();
  Future<bool> isAdsRemoved();
}

class NoopIapService implements IapService {
  bool _removed = false;

  @override
  Future<void> init() async {}

  @override
  Future<bool> isAdsRemoved() async => _removed;

  @override
  Future<bool> purchaseRemoveAds() async {
    _removed = true;
    return true;
  }
}
