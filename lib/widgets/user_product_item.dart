import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

import '../constant.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      minVerticalPadding: 16,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontSize: 14,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 22,
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.deepOrangeAccent,
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductScreen.routeName, arguments: id);
                }),
            IconButton(
                icon: Icon(Icons.delete, color: Colors.deepOrangeAccent),
                onPressed: () async {
                  try {
                    await Provider.of<ProductsProvider>(context, listen: false)
                        .deleteProduct(id);
                    scaffold.hideCurrentSnackBar();
                    scaffold.showSnackBar(
                      SnackBar(
                        content: Text(
                          'Deleting Success',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: colorCustom,
                                  ),
                        ),
                        duration: Duration(milliseconds: 1200),
                      ),
                    );
                  } catch (error) {
                    scaffold.hideCurrentSnackBar();
                    scaffold.showSnackBar(
                      SnackBar(
                        content: Text(
                          'Deleting Failed!',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: colorCustom,
                                  ),
                        ),
                        duration: Duration(milliseconds: 1200),
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
