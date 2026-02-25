// Stub for Ads service (Banner/Interstitial/Rewarded). Replace with google_mobile_ads or any provider.
abstract class AdsService {
  Future<void> init();
  Future<void> showInterstitial();
  Future<void> showRewarded(String placement);
}

class NoopAdsService implements AdsService {
  @override
  Future<void> init() async {}

  @override
  Future<void> showInterstitial() async {}

  @override
  Future<void> showRewarded(String placement) async {}
}
