import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/vendor/provider/product_provider.dart';

class GeneralScreen extends StatefulWidget {
  const GeneralScreen({super.key});

  @override
  State<GeneralScreen> createState() => _GeneralScreenState();
}

class _GeneralScreenState extends State<GeneralScreen>
    with AutomaticKeepAliveClientMixin<GeneralScreen> {
  @override
  bool get wantKeepAlive => true;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<String> _categories = [];

  _getCategories() async {
    try {
      return _firestore.collection('categories').get().then((
        QuerySnapshot querySnapshot,
      ) {
        _categories.clear();
        for (var doc in querySnapshot.docs) {
          setState(() {
            _categories.add(doc['categoryName'] as String);
          });
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching categories: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getCategories();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Store the product information in the ProductProvider
    // so that it can be accessed later when the user submits the form.
    final ProductProvider productProvider = Provider.of<ProductProvider>(
      context,
    );

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Please enter product informations',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Product Name',
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter product name';
                }
                return null;
              },
              onChanged: (value) {
                productProvider.getFormdata(productName: value);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Product Price',
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter product price';
                }
                return null;
              },
              onChanged: (value) {
                productProvider.getFormdata(
                  productPrice: double.tryParse(value),
                );
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Product Quantity',
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter product quantity';
                }
                return null;
              },
              onChanged: (value) {
                productProvider.getFormdata(
                  productQuantity: int.tryParse(value),
                );
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField(
              hint: const Text('Select Category'),
              items: _categories.map<DropdownMenuItem<dynamic>>((e) {
                return DropdownMenuItem(value: e, child: Text(e));
              }).toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a category';
                }
                return null;
              },
              onChanged: (value) {
                productProvider.getFormdata(productCategory: value);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              maxLines: 10,
              minLines: 3,
              maxLength: 500,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: 'Product Description',
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                hintText: 'Enter product description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter product description';
                }
                return null;
              },
              onChanged: (value) {
                productProvider.getFormdata(productDescription: value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
