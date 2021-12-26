import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:in_app_purchase_ios/in_app_purchase_ios.dart';

import 'payment_screen.dart';
import 'provider_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ProviderModel _appProvider;

  @override
  void initState() {
    final provider = Provider.of<ProviderModel>(context, listen: false);
    _appProvider = provider;

    SchedulerBinding.instance!.addPostFrameCallback((_) async {
      initInApp(provider);
    });

    super.initState();
  }

  initInApp(provider) async {
    await provider.initInApp();
  }
  @override
  void dispose() {
    if (Platform.isIOS) {
      var iosPlatformAddition = _appProvider.inAppPurchase
          .getPlatformAddition<InAppPurchaseIosPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _appProvider.subscription.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderModel>(context);

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
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          Text(
            'Non Consumable:',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            !provider.finishedLoad
                ? ''
                : provider.removeAds
                ? 'You paid for removing Ads.'
                : 'You have not paid for removing Ads.',
            style: TextStyle(
                color: provider.removeAds ? Colors.green : Colors.grey,
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
            !provider.finishedLoad
                ? ''
                : provider.silverSubscription
                ? 'You have Silver Subscription.'
                : 'You have not paid for Silver Subscription.',
            style: TextStyle(
                color: provider.silverSubscription ? Colors.green : Colors.grey,
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
            !provider.finishedLoad
                ? ''
                : provider.goldSubscription
                ? 'You have Gold Subscription.'
                : 'You have not paid for Gold Subscription.',
            style: TextStyle(
                color: provider.goldSubscription ? Colors.green : Colors.grey,
                fontSize: 20),
          ),
          Container(
            height: 30,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Purchased consumables:${provider.consumables.length}',
                  style: TextStyle(fontSize: 20)),
              _buildConsumableBox(provider),
            ],
          )
        ],
      ),
    );
  }

  Card _buildConsumableBox(provider) {
    if (provider.loading) {
      return Card(
          child: (ListTile(
              leading: CircularProgressIndicator(),
              title: Text('Fetching consumables...'))));
    }
    if (!provider.isAvailable || provider.notFoundIds.contains(kConsumableId)) {
      return Card();
    }

    final List<Widget> tokens = provider.consumables.map<Widget>((String id) {
      return GridTile(
        child: IconButton(
          icon: Icon(
            Icons.stars,
            size: 42.0,
            color: Colors.orange,
          ),
          splashColor: Colors.yellowAccent,
          onPressed: () {
            provider.consume(id);
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