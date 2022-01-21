// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// import 'package:shop_app/constant.dart';
import 'package:shop_app/providers/cart.dart';

class CartListItem extends StatelessWidget {
  final CartItem cartItem;
  final String keyId;

  CartListItem(this.cartItem, this.keyId);

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.simpleCurrency(locale: "id_ID", decimalDigits: 0);

    return Dismissible(
      key: ValueKey(cartItem.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(keyId);
      },
      background: Container(
        child: Icon(
          Icons.delete,
          color: Theme.of(context).accentColor,
          size: 40,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.transparent,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 10),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: ClipOval(
              child: Image.network(
                cartItem.imageUrl,
                width: 56,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              cartItem.title,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
              softWrap: true,
              // overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              'Total : ${formatter.format(cartItem.price * cartItem.quantity).toString()}',
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.black38,
                  ),
            ),
            trailing: Container(
              decoration: BoxDecoration(
                color: Color(0x14e0bf00),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: (cartItem.quantity > 1)
                            ? () => {
                                  Provider.of<Cart>(context, listen: false)
                                      .addOrRemoveQuantity(
                                          keyId, false, cartItem.imageUrl)
                                }
                            : () => {
                                  Provider.of<Cart>(context, listen: false)
                                      .removeItem(keyId)
                                },
                        icon: Icon(Icons.remove, color: Colors.black),
                        splashRadius: 20,
                        alignment: Alignment.center,
                        iconSize: 16,
                      ),
                      // VerticalDivider(
                      //   thickness: 1.5,
                      //   color: Colors.black26,
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          'x${cartItem.quantity}',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.deepOrange,
                                  ),
                        ),
                      ),
                      // VerticalDivider(
                      //   thickness: 1.5,
                      //   color: Colors.black26,
                      // ),
                      IconButton(
                        onPressed: () {
                          Provider.of<Cart>(context, listen: false)
                              .addOrRemoveQuantity(
                                  keyId, true, cartItem.imageUrl);
                        },
                        icon: Icon(Icons.add, color: Colors.black),
                        splashRadius: 20,
                        alignment: Alignment.center,
                        iconSize: 16,
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
