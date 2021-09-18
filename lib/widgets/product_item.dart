import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constant.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/product_detail_screen.dart';


class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName, arguments: product.id);
          },
          child: Hero(
              tag: product.id,
              child: Image.network(product.imageUrl, fit: BoxFit.cover)),
        ),
        footer: Container(
          height: 36,
          // padding: const EdgeInsets.only(top: 4),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28), topRight: Radius.circular(28)),
              color: Colors.black54),
          child: GridTileBar(
            backgroundColor: Colors.transparent,
            leading: Container(
              width: 20,
              child: Consumer<Product>(
                builder: (ctx, product, _) => IconButton(
                  padding: const EdgeInsets.only(left: 2),
                  alignment: Alignment.centerLeft,
                  icon: Icon(
                    product.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_outline,
                    color: Theme.of(context).accentColor,
                    size: 20,
                  ),
                  onPressed: () {
                    product.toggleFovoriteStatus(
                        authData.token, authData.userId);
                  },
                ),
              ),
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              maxLines: 2,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: colorCustom,
                  ),
            ),
            trailing: Container(
              width: 20,
              child: Consumer<Product>(
                builder: (ctx, product, _) => IconButton(
                  padding: const EdgeInsets.only(right: 2),
                  alignment: Alignment.centerRight,
                  icon: Icon(
                    Icons.add_shopping_cart,
                    color: Theme.of(context).accentColor,
                    size: 20,
                  ),
                  onPressed: () {
                    cart.addItem(product.id, product.title, product.price,
                        product.imageUrl);

                    ScaffoldMessenger.of(context).hideCurrentSnackBar();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Added to cart',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: colorCustom,
                                  ),
                        ),
                        duration: Duration(milliseconds: 1700),
                        action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () {
                            cart.removeSingleItem(product.id);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
