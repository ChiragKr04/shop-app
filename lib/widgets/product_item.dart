import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/screens/product_details_screen.dart';

import '../providers/products.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Products>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ProductDetailsScreen.routeName,
                arguments: product.id,
              );
            },
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black.withOpacity(0.82),
            leading: IconButton(
              color: Theme.of(context).accentColor,
              onPressed: () {
                product.isFavoriteToggle();
              },
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_outline,
              ),
            ),
            trailing: IconButton(
              color: Theme.of(context).accentColor,
              onPressed: () {
                cart.addItems(product.id, product.price, product.title);
              },
              icon: Icon(Icons.add_shopping_cart),
            ),
            title: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                product.title,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
