import 'dart:html';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/widgets/products_grid.dart';

enum FilterOptions {
  Favourite,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavorite = false;

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Overview"),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              print(selectedValue);
              setState(() {
                if (selectedValue == FilterOptions.Favourite) {
                  _showOnlyFavorite = true;
                }
                if (selectedValue == FilterOptions.All) {
                  _showOnlyFavorite = false;
                }
              });
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: Text("My Favorite"),
                value: FilterOptions.Favourite,
              ),
              PopupMenuItem(
                child: Text("Show All"),
                value: FilterOptions.All,
              ),
            ],
            icon: Icon(
              Icons.more_vert,
            ),
          ),
        ],
      ),
      body: ProductsGrid(_showOnlyFavorite),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.shopping_cart),
            ),
            Positioned(
              top: -15,
              right: -15,
              child: Container(
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 15,
                  child: FittedBox(
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "99+",
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
