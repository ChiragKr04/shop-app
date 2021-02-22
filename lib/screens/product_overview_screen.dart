import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
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
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Product Overview"),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
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
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              position: BadgePosition(end: -2, top: 0),
              animationType: BadgeAnimationType.scale,
              animationDuration: Duration(milliseconds: 1),
              badgeContent: _count <= 9
                  ? Text(
                      cart.itemCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      cart.itemCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
              child: child,
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  CartScreen.routeName,
                );
              },
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(_showOnlyFavorite),
    );
  }
}
