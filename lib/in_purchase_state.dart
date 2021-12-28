

abstract class InPurchaseState {}

class InPurchaseStateInitial extends InPurchaseState{}
class InPurchaseStateVerifyPreviousPurchases extends InPurchaseState{}
class InPurchaseStateRemoveAds extends InPurchaseState{}
class InPurchaseStateSilverSubscription extends InPurchaseState{}
class InPurchaseStateGoldSubscription extends InPurchaseState{}
class InPurchaseStateFinishedLoad extends InPurchaseState{}
class InPurchaseStateInitStoreInfo extends InPurchaseState{}
class InPurchaseStateConsume extends InPurchaseState{}