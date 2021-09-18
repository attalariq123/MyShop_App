import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:shop_app/helpers/custom_route.dart';
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
              leading: Container(
                margin: EdgeInsets.all(6),
                child: ClipOval(
                    child: Image.network(
                  'https://images.unsplash.com/photo-1517849845537-4d257902454a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=375&q=80',
                  fit: BoxFit.cover,
                  width: 4,
                  height: 4,
                )),
              ),
              title: Text(
                'Hello Shoppers',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      fontSize: 18,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
              ),
              // automaticallyImplyLeading: false,
            ),
            ListTile(
              leading: const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.black87,
                size: 28,
              ),
              title: Text(
                'Shop',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 16,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFe0bf00),
                    ),
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
            Divider(),
            ListTile(
              leading: const Icon(
                Icons.payment,
                color: Colors.black87,
                size: 28,
              ),
              title: Text(
                'Orders',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 16,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFe0bf00),
                    ),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(OrdersScreen.routeName);
              },
            ),
            Divider(),
            ListTile(
              leading: const Icon(
                Icons.mode_edit_outline,
                color: Colors.black87,
                size: 28,
              ),
              title: Text(
                'Manage Products',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 16,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFe0bf00),
                    ),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(UserProductScreen.routeName);
              },
            ),
            Divider(),
            ListTile(
              leading: const Icon(
                Icons.exit_to_app_rounded,
                color: Colors.black87,
                size: 28,
              ),
              title: Text(
                'Logout',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 16,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFe0bf00),
                    ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<Auth>(context, listen: false).logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
