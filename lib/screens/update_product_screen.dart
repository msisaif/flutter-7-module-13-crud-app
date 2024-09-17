import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../models/product.dart';

class UpdateProductScreen extends StatefulWidget {
  final Product product;

  const UpdateProductScreen({super.key, required this.product});

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  late TextEditingController _productNameTEController = TextEditingController();
  late TextEditingController _unitPriceTEController = TextEditingController();
  late TextEditingController _totalPriceTEController = TextEditingController();
  late TextEditingController _imageTEController = TextEditingController();
  late TextEditingController _codeTEController = TextEditingController();
  late TextEditingController _quantityTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _inProgress = false;

  @override
  void initState() {
    super.initState();

    _productNameTEController = TextEditingController(text: widget.product.name);
    _unitPriceTEController =
        TextEditingController(text: widget.product.unitPrice);
    _totalPriceTEController =
        TextEditingController(text: widget.product.totalPrice);
    _imageTEController = TextEditingController(text: widget.product.photo);
    _codeTEController = TextEditingController(text: widget.product.code);
    _quantityTEController =
        TextEditingController(text: widget.product.quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildNewProductForm(),
      ),
    );
  }

  Widget _buildNewProductForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              controller: _productNameTEController,
              decoration: const InputDecoration(
                  hintText: 'Name', labelText: 'Product Name'),
            ),
            TextFormField(
              controller: _unitPriceTEController,
              decoration: const InputDecoration(
                  hintText: 'Unit Price', labelText: 'Unit Price'),
            ),
            TextFormField(
              controller: _totalPriceTEController,
              decoration: const InputDecoration(
                  hintText: 'Total Price', labelText: 'Total Price'),
            ),
            TextFormField(
              controller: _imageTEController,
              decoration: const InputDecoration(
                  hintText: 'Image', labelText: 'Product Image'),
            ),
            TextFormField(
              controller: _codeTEController,
              decoration: const InputDecoration(
                  hintText: 'Product code', labelText: 'Product Code'),
            ),
            TextFormField(
              controller: _quantityTEController,
              decoration: const InputDecoration(
                  hintText: 'Quantity', labelText: 'Quantity'),
            ),
            const SizedBox(height: 16),
            _inProgress
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size.fromWidth(double.maxFinite),
                    ),
                    onPressed: _onTapUpdateProductButton,
                    child: const Text('UPDATE'),
                  )
          ],
        ),
      ),
    );
  }

  void _onTapUpdateProductButton() {
    if (_formKey.currentState!.validate()) {
      updateProduct();
    }
  }

  Future<void> updateProduct() async {
    setState(() {
      _inProgress = true;
    });

    Uri uri = Uri.parse(
      'http://164.68.107.70:6060/api/v1/UpdateProduct/${widget.product.id}',
    );

    Map<String, dynamic> requestBody = {
      "Img": _imageTEController.text,
      "ProductCode": _codeTEController.text,
      "ProductName": _productNameTEController.text,
      "Qty": _quantityTEController.text,
      "TotalPrice": _totalPriceTEController.text,
      "UnitPrice": _unitPriceTEController.text
    };

    Response response = await post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      _showSnackBarMessage('Product updated');
    }

    setState(() {
      _inProgress = false;
    });
  }

  void _showSnackBarMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void dispose() {
    _productNameTEController.dispose();
    _quantityTEController.dispose();
    _totalPriceTEController.dispose();
    _unitPriceTEController.dispose();
    _imageTEController.dispose();
    _codeTEController.dispose();
    super.dispose();
  }
}
