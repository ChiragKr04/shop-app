import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProduct extends StatelessWidget {
  static const routeName = "/user-products-screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Consumer<ProductsProvider>(
          builder: (BuildContext context, products, Widget child) {
        return ListView.builder(
          itemCount: products.items.length,
          itemBuilder: (ctx, index) {
            return UserProductItem(
              products.items[index].id,
              products.items[index].title,
              products.items[index].imageUrl,
            );
          },
        );
      }),
    );
  }
}
