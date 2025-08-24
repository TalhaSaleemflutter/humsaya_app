import 'package:hive/hive.dart';
import 'package:humsaya_app/models/ad_product_model.dart';

class AdHive {
  static const String _adBoxName = 'adBox';

  Future<Box<AdModel>> _getAdBox() async {
    return await Hive.openBox<AdModel>(_adBoxName);
  }

  static Future<void> initHive() async {
    Hive.registerAdapter(AdModelAdapter());
    await Hive.openBox<AdModel>(_adBoxName);
  }

  Future<void> saveAd(AdModel product) async {
    var box = await _getAdBox();
    await box.put(product.addId, product);
    print('Ad saved to Hive: ${product.toMap()}');
  }

  Future<List<AdModel>> loadAllAds(String uId) async {
    var box = await _getAdBox();
    var ads = box.values.where((item) => item.uid == uId).toList();
    print('Ads loaded from Hive: ${ads.length}');
    return ads;
  }

  Future<void> deleteAd(String addId) async {
    var box = await _getAdBox();
    await box.delete(addId);
  }

  Future<void> clearAllAds() async {
    var box = await _getAdBox();
    await box.clear();
  }
}
