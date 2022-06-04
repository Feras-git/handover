import 'package:flutter/material.dart';
import 'package:handover/core/models/product.dart';
import 'package:sizer/sizer.dart';

class SelectProductWidget extends StatefulWidget {
  final List<Product> productsList;
  final Function onChanged;
  SelectProductWidget({
    required this.productsList,
    required this.onChanged(Product value),
  });

  @override
  State<SelectProductWidget> createState() => _SelectProductWidgetState();
}

class _SelectProductWidgetState extends State<SelectProductWidget> {
  Product? _selected;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<Product>(
      value: _selected,
      items: widget.productsList.map((product) {
        return DropdownMenuItem(
          value: product,
          child: Row(
            children: [
              Text(product.name),
              Text(
                '  |  ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                ),
              ),
              Text(product.price.toString() + ' \$'),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selected = value;
        });
        widget.onChanged(_selected);
      },
    );
  }
}
