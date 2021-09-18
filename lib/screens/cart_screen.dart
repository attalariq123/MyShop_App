import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/cart_list_item.dart';

import '../constant.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final double taxes = cart.totalAmount * (5 / 100);
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          leading: IconButton(
            onPressed: Navigator.of(context).pop,
            icon: Icon(Icons.arrow_back_ios_new),
          ),
          title: Text(
            'Your Cart',
            style: Theme.of(context).textTheme.headline4!.copyWith(
                  fontSize: 22,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Card(
              color: colorCustom,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Subtotal :',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: 14,
                                    letterSpacing: 0.6,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                        ),
                        Spacer(),
                        Text(
                          '\$${cart.totalAmount.toStringAsFixed(2)}',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Taxes :',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: 14,
                                    letterSpacing: 0.6,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                        ),
                        Spacer(),
                        Text(
                          '\$${taxes.toStringAsFixed(2)}',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 1.4,
                      color: Theme.of(context).accentColor,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total :',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: 16,
                                    letterSpacing: 0.6,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                        ),
                        Spacer(),
                        Text(
                          '\$${(cart.totalAmount + taxes).toStringAsFixed(2)}',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: cart.items.length,
                itemBuilder: (ctx, i) => CartListItem(
                  cart.items.values.toList()[i],
                  cart.items.keys.toList()[i],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: colorCustom,
                borderRadius: BorderRadius.circular(16),
              ),
              child: OrderButton(cart: cart),
            ),
          ],
        ));
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? CircularProgressIndicator.adaptive(
            backgroundColor: Colors.black,
          )
        : TextButton(
            onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
                ? null
                : () async {
                    setState(() {
                      _isLoading = true;
                    });
                    widget.cart.itemCount >= 1
                        ? await Provider.of<Orders>(context, listen: false)
                            .addOrder(widget.cart.items.values.toList(),
                                widget.cart.totalAmount, widget.cart.itemCount)
                        : print('Cart Empty');
                    setState(() {
                      _isLoading = false;
                    });
                    widget.cart.clearCart();
                  },
            child: Text(
              'Order Now',
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontSize: 16,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
            ),
          );
  }
}
