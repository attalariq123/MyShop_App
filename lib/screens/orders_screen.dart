import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' show Orders;
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/order-screen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future<dynamic>
      _obtainedEarlier; // to prevent widget rebuild in some case (but here is not)

  Future _obtainOrdersFuture() async {
    return await Provider.of<Orders>(context, listen: false).fetchSetOrders();
  }

  @override
  void initState() {
    _obtainedEarlier = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    print('build orders');
    return Scaffold(
        appBar: AppBar(
          // iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            'Your Orders',
            style: Theme.of(context).textTheme.headline4!.copyWith(
                  fontSize: 26,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                ),
          ),
          centerTitle: true,
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
            future: _obtainedEarlier,
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: const CircularProgressIndicator.adaptive());
              } else {
                // print(dataSnapshot.error);
                if (dataSnapshot.error != null) {
                  // Do some error handling...
                  return Center(
                    child: Text('An error occured'),
                  );
                } else {
                  return Consumer<Orders>(
                      builder: (ctx, orderData, child) =>
                          orderData.orders.isNotEmpty
                              ? ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: orderData.orders.length,
                                  itemBuilder: (ctx, i) => OrderItem(
                                    orderData.orders[i],
                                  ),
                                )
                              : Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.shopping_bag_outlined,
                                        color: Colors.deepOrangeAccent,
                                        size: 70,
                                      ),
                                      const Divider(
                                        thickness: 0,
                                        color: Colors.transparent,
                                      ),
                                      Center(
                                        child: Text(
                                          'Sorry, you don\'t have an order',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4!
                                              .copyWith(
                                                fontSize: 16,
                                                letterSpacing: 0.5,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black87,
                                              ),
                                          softWrap: true,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                }
              }
            }));
  }
}
