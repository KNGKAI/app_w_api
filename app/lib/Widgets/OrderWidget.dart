import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:skate/Models/Order.dart';
import 'package:skate/Models/Product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skate/Services/ProfileService.dart';

class OrderWidget extends StatefulWidget {
  final Order order;
  final Function(int) onOrderAproved;
  final Function onOrderConfirmUserPayment;
  final Function onOrderShipped;

  const OrderWidget({
    @required this.order,
    this.onOrderAproved,
    this.onOrderConfirmUserPayment,
    this.onOrderShipped,
    Key key,
  }) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<OrderWidget> {
  Widget adminActionAproveOrder() {
    TextEditingController textEditingController =
        TextEditingController(text: "0");
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          width: 128,
          child: TextField(
            controller: textEditingController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Delivery Fee",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        TextButton(
          child: Text("Aprove Order"),
          onPressed: () =>
              widget.onOrderAproved(int.parse(textEditingController.text)),
        )
      ],
    );
  }

  Widget get adminActionConfirmUserPayment => TextButton(
        child: Text("Confirm User Paymnet"),
        onPressed: widget.onOrderConfirmUserPayment,
      );

  Widget get adminActionShipOrder => TextButton(
        child: Text("Shipped Order"),
        onPressed: widget.onOrderShipped,
      );

  Widget get adminAction => widget.order.status == "placed"
      ? adminActionAproveOrder()
      : widget.order.status == "approved"
          ? adminActionConfirmUserPayment
          : widget.order.status == "paid"
              ? adminActionShipOrder
              : widget.order.status == "shipped"
                  ? Text("Order has been shipped")
                  : Text("Unknown");

  String get userMessage => widget.order.status == "placed"
      ? "Waiting for approval"
      : widget.order.status == "approved"
          ? "Order approved, Please make a payment of R${widget.order.total.toString()} to [banking details] with reference: ${widget.order.reference}"
          : widget.order.status == "paid"
              ? "Thank you, your order is being prepared for delivery"
              : widget.order.status == "shipped"
                  ? "Your order is on its way"
                  : "Unknown";

  List<Widget> get adminPanel => [
        Text("Admin:"),
        Divider(),
        Expanded(child: adminAction),
        Divider(),
      ];

  List<Widget> get userPanel =>
      [Text("Details:"), Text(userMessage), Divider()];

  @override
  Widget build(BuildContext context) {
    ProfileService profileService = Provider.of<ProfileService>(context);
    String deliveryFee = widget.order.status == "placed"
        ? "Waiting for Approval"
        : widget.order.fee.toString();
    return Column(
      children: [
        Divider(),
        Text("Order: ${widget.order.reference}"),
        Text("Address: ${widget.order.address}"),
        Text("Status: ${widget.order.status}"),
        Text("Delivery Fee: $deliveryFee"),
        Divider(),
        Text("User: ${widget.order.user.username}"),
        Text("Phone: ${widget.order.user.phone}"),
        Text("Email: ${widget.order.user.email}"),
        Divider(),
        Text("Products:"),
        ...widget.order.products.map((order) => Text(
            " - ${order.product.name} - ${order.size} : R${order.product.price.toString()} X ${order.value.toString()}")),
        Divider(),
        Text("Total: R${widget.order.total}"),
        Divider(),
        ...(profileService.user.role == "admin" ? adminPanel : userPanel)
      ],
    );
  }
}
