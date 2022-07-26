import 'package:flutter/material.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/badge.dart';
import 'package:shopapp/widgets/product_grid.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import '../providers/products.dart';
import '../widgets/product_item.dart';
import 'dart:convert';

enum FilterOptions {
  OnlyFavorites,
  ShowAll,
}

class ProductOverviewScreen extends StatefulWidget {
  static final routeName = "/productOverview";

  ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var showFavorites = false;
  var _init = true;
  var _isLoading = false;

  @override
  void initState() {
    setState(() {
      showFavorites = false;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_init) {
      setState(() {
        _isLoading = true;
      });
      final res =
          Provider.of<Products>(context).fetchAndSetProducts().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final ProductsContainer = Provider.of<Products>(context, listen: true);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "MyShop",
            style: TextStyle(
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
          actions: [
            PopupMenuButton(
                onSelected: (FilterOptions value) =>
                    {if (value == FilterOptions.OnlyFavorites) {} else {}},
                icon: Icon(Icons.more_vert),
                itemBuilder: (_) => [
                      PopupMenuItem(
                        child: Text("Only Favorites"),
                        value: FilterOptions.OnlyFavorites,
                        onTap: ProductsContainer.showFav,
                      ),
                      PopupMenuItem(
                        child: Text("Show All"),
                        value: FilterOptions.ShowAll,
                        onTap: ProductsContainer.showAll,
                      ),
                    ]),
            Consumer<Cart>(
              builder: (_, cart, ch) => Badge(
                value: cart.itemsCount.toString(),
                child: ch as Widget,
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
                icon: const Icon(Icons.shopping_cart),
              ),
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ProductsGrid());
  }
}
