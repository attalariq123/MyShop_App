import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/user_product_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child: Drawer(
        elevation: 20,
        child: Column(
          children: [
            AppBar(
              // leading: Text(''),
              title: Text(
                'Go Healthy Go Life',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      fontSize: 18,
                      letterSpacing: 1.4,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
              ),
              automaticallyImplyLeading: false,
            ),
            ListTile(
              leading: Icon(
                Icons.shopping_bag_outlined,
                color: Theme.of(context).colorScheme.secondary,
                size: 28,
              ),
              title: Text(
                'Shop',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 16,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.payment,
                color: Theme.of(context).colorScheme.secondary,
                size: 28,
              ),
              title: Text(
                'Orders',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 16,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(OrdersScreen.routeName);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.mode_edit_outline,
                color: Theme.of(context).colorScheme.secondary,
                size: 28,
              ),
              title: Text(
                'Manage Products',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 16,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(UserProductScreen.routeName);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.exit_to_app_rounded,
                color: Theme.of(context).colorScheme.secondary,
                size: 28,
              ),
              title: Text(
                'Logout',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 16,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<Auth>(context, listen: false).logout();
              },
            ),
            const Spacer(),
            Container(
              height: 260,
              width: 260,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: new AssetImage("assets/images/farmer_ccexpress.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
