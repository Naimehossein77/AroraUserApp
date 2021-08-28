import 'package:flutter/material.dart';
import 'package:user/model/customer.dart';
import 'package:user/model/supplier.dart';

class Invoice {
  final InvoiceInfo info;
  final Supplier supplier;
  final Customer customer;
  final InvoiceDetails details;
  final List<InvoiceItem> items;

  addItem(InvoiceItem item) {
    items.add(item);
  }

  const Invoice(
      {@required this.info,
      @required this.supplier,
      @required this.customer,
      @required this.items,
      @required this.details});
}

class InvoiceInfo {
  final String description;
  final String number;
  final DateTime date;

  const InvoiceInfo({
    @required this.description,
    @required this.number,
    @required this.date,

    //required this.dueDate,
  });
}

class InvoiceDetails {
  //final int gst;
  final double cartTotal;
  final double total;
  final int shipping;

  const InvoiceDetails(
      {@required this.cartTotal,
      // @required this.gst,
      @required this.total,
      @required this.shipping});
}

class InvoiceItem {
  final String description;

  final int quantity;

  final double unitPrice;

  const InvoiceItem({
    @required this.description,
    @required this.quantity,
    @required this.unitPrice,
  });
}
