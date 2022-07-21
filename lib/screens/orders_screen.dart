import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import '../providers/orders.dart' as ord;
import '../widgets//order_item.dart';

class OrderScreen extends StatefulWidget {
  static final routeName = "/orders";

  OrderScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isLoading = false;
  late Future _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<ord.Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var ordersData = Provider.of<ord.Orders>(context);
    return Scaffold(
        appBar: AppBar(),
        drawer: AppDrawer(),
        body: FutureBuilder(
            future: _ordersFuture,
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (dataSnapshot.error != null) {
                  return Center(
                    child: Text("An error occured!"),
                  );
                } else {
                  return ListView.builder(
                    itemBuilder: ((context, index) => Order_Item(
                          order: ordersData.orders[index],
                        )),
                    itemCount: ordersData.orders.length,
                  );
                }
              }
            }));
  }
}
