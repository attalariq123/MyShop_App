import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constant.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProducts = Provider.of<ProductsProvider>(context, listen: false)
        .findById(productId);
    final cart = Provider.of<Cart>(context, listen: false);
    final priceLen = loadedProducts.price.toString().length;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            floating: false,
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  child: Hero(
                    tag: loadedProducts.id,
                    child: Image.network(
                      loadedProducts.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.55,
                        child: Text(
                          loadedProducts.title,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: 18,
                                    letterSpacing: 0.8,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black87,
                                  ),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: Text(
                            '\$${loadedProducts.price.toStringAsFixed(2)}',
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      fontSize: 18,
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.deepOrangeAccent,
                                    ),
                            textScaleFactor: priceLen >= 7 ? 0.85 : 1,
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            textAlign: TextAlign.end,
                            maxLines: 2,
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    decoration: BoxDecoration(),
                    padding: EdgeInsets.only(right: 64, left: 16, bottom: 16),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      loadedProducts.description,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: 16,
                            letterSpacing: 0.1,
                            wordSpacing: 0.5,
                            fontWeight: FontWeight.w500,
                            color: Color(0xCC000000),
                          ),
                      textAlign: TextAlign.left,
                      softWrap: true,
                    )),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        backgroundColor: colorCustom,
        foregroundColor: Colors.black87,
        onPressed: () {
          cart.addItem(loadedProducts.id, loadedProducts.title,
              loadedProducts.price, loadedProducts.imageUrl);

          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Added to cart',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: colorCustom,
                    ),
              ),
              duration: Duration(milliseconds: 1700),
              action: SnackBarAction(
                label: 'UNDO',
                onPressed: () {
                  cart.removeSingleItem(loadedProducts.id);
                },
              ),
            ),
          );
        },
        child: const Icon(
          Icons.add_shopping_cart_rounded,
          size: 26,
        ),
      ),
    );
  }
}
