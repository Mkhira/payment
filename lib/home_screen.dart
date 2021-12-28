import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase_ios/in_app_purchase_ios.dart';
import 'package:testpayment/in_purchase_state.dart';

import 'payment_screen.dart';
import 'provider_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {

    SchedulerBinding.instance!.addPostFrameCallback((_) async {
      initInApp(InAppPurchaseCubit.get(context));
    });

    super.initState();
  }

  initInApp(provider) async {
    await provider.initInApp();
  }
  @override
  void dispose() {
    if (Platform.isIOS) {
      var iosPlatformAddition = InAppPurchaseCubit.get(context).inAppPurchase
          .getPlatformAddition<InAppPurchaseIosPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    InAppPurchaseCubit.get(context).subscription.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.green)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaymentScreen()),
                  );
                },
                child: Text('Pay')),
          )
        ],
      ),
      body: BlocBuilder<InAppPurchaseCubit,InPurchaseState>(
        builder: (context,state){
          return ListView(
            padding: EdgeInsets.all(8),
            children: [
              Text(
                'Non Consumable:',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                !InAppPurchaseCubit.get(context).finishedLoad
                    ? ''
                    : InAppPurchaseCubit.get(context).removeAds
                    ? 'You paid for removing Ads.'
                    : 'You have not paid for removing Ads.',
                style: TextStyle(
                    color: InAppPurchaseCubit.get(context).removeAds ? Colors.green : Colors.grey,
                    fontSize: 20),
              ),
              Container(
                height: 30,
              ),
              Text(
                'Silver Subscription:',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                !InAppPurchaseCubit.get(context).finishedLoad
                    ? ''
                    : InAppPurchaseCubit.get(context).silverSubscription
                    ? 'You have Silver Subscription.'
                    : 'You have not paid for Silver Subscription.',
                style: TextStyle(
                    color: InAppPurchaseCubit.get(context).silverSubscription ? Colors.green : Colors.grey,
                    fontSize: 20),
              ),
              Container(
                height: 30,
              ),
              Text(
                'Gold Subscription:',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                !InAppPurchaseCubit.get(context).finishedLoad
                    ? ''
                    : InAppPurchaseCubit.get(context).goldSubscription
                    ? 'You have Gold Subscription.'
                    : 'You have not paid for Gold Subscription.',
                style: TextStyle(
                    color: InAppPurchaseCubit.get(context).goldSubscription ? Colors.green : Colors.grey,
                    fontSize: 20),
              ),
              Container(
                height: 30,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Purchased consumables:${InAppPurchaseCubit.get(context).consumables.length}',
                      style: TextStyle(fontSize: 20)),
                  _buildConsumableBox(),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  Card _buildConsumableBox() {
    if (InAppPurchaseCubit.get(context).loading) {
      return Card(
          child: (ListTile(
              leading: CircularProgressIndicator(),
              title: Text('Fetching consumables...'))));
    }
    if (!InAppPurchaseCubit.get(context).isAvailable || InAppPurchaseCubit.get(context).notFoundIds.contains(kConsumableId)) {
      return Card();
    }

    final List<Widget> tokens = InAppPurchaseCubit.get(context).consumables.map<Widget>((String id) {
      return GridTile(
        child: IconButton(
          icon: Icon(
            Icons.stars,
            size: 42.0,
            color: Colors.orange,
          ),
          splashColor: Colors.yellowAccent,
          onPressed: () {
            InAppPurchaseCubit.get(context).consume(id);
          },
        ),
      );
    }).toList();
    return Card(
        elevation: 0,
        child: Column(children: <Widget>[
          GridView.count(
            crossAxisCount: 5,
            children: tokens,
            shrinkWrap: true,
          )
        ]));
  }
}