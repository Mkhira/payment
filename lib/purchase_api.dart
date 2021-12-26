//
//
//
// import 'package:purchases_flutter/object_wrappers.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
//
// class PurchaseApi {
//
//  static const _apiKey ="";
//   static Future init() async{
//     await Purchases.setDebugLogsEnabled(true);
//     await Purchases.setup(_apiKey);
//   }
//   static Future<List<Offering>> fetchOffers()async{
//     try {
//       final offers = await Purchases.getOfferings();
//       final currentOffer = offers.current;
//
//       return currentOffer == null ? []:[currentOffer];
//     } on Exception catch (e) {
//     print(e);
//     return [];
//     }
//   }
// }