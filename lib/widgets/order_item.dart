// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' as ord;

import '../constant.dart';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final String quantityLabel = widget.order.itemQty.toString() +
        ' item${widget.order.itemQty == 1 ? '' : 's'}';
    final int orderLength = widget.order.products.length;
    final double containerSize = orderLength == 1 ? 58 : 112;
    final formatter = NumberFormat.simpleCurrency(locale: "id_ID", decimalDigits: 0);
    return Dismissible(
      key: ValueKey(widget.order.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        try {
          await Provider.of<ord.Orders>(context, listen: false)
              .deleteOrder(widget.order.id);
        } catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Deleting Failed',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: colorCustom,
                    ),
              ),
              duration: Duration(milliseconds: 1200),
            ),
          );
        }
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        margin: const EdgeInsets.all(12),
        child: Column(
          children: [
            ListTile(
              title: Text(
                '${formatter.format(widget.order.amount).toString()} /  $quantityLabel',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 14,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
              ),
              subtitle: Text(
                DateFormat('dd/MM/yyy - hh:mm').format(widget.order.dateTime),
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 12,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w500,
                      color: Colors.black38,
                    ),
              ),
              trailing: IconButton(
                icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
              ),
            ),
            if (_isExpanded)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                height: containerSize,
                child: ListView(
                  children: widget.order.products
                      .map(
                        (prod) => Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 22,
                              backgroundImage: NetworkImage(prod.imageUrl),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 160,
                                  child: Text(
                                    prod.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          fontSize: 12,
                                          letterSpacing: 0.8,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black87,
                                        ),
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                Text(
                                  'Qty: ${prod.quantity}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        fontSize: 12,
                                        letterSpacing: 0.8,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black54,
                                      ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Container(
                              width: 80,
                              child: Text(
                                formatter.format(prod.price).toString(),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                                softWrap: true,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      fontSize: 12,
                                      letterSpacing: 0.8,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black87,
                                    ),
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
