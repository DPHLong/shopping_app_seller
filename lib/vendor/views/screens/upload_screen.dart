import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vendor_app/vendor/provider/product_provider.dart';
import 'package:vendor_app/vendor/views/screens/tabbar_screens/attributes_screen.dart';
import 'package:vendor_app/vendor/views/screens/tabbar_screens/general_screen.dart';
import 'package:vendor_app/vendor/views/screens/tabbar_screens/images_screen.dart';
import 'package:vendor_app/vendor/views/screens/tabbar_screens/shipping_screen.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _formatedDate(DateTime date) {
    final outputDateFormat = DateFormat("dd/MM/yyyy").format(date);
    return outputDateFormat;
  }

  @override
  Widget build(BuildContext context) {
    final ProductProvider productProvider = Provider.of<ProductProvider>(
      context,
    );

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Upload', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.pink,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                child: Text('General', style: TextStyle(color: Colors.white)),
              ),
              Tab(
                child: Text('Shipping', style: TextStyle(color: Colors.white)),
              ),
              Tab(
                child: Text(
                  'Attributes',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Tab(
                child: Text('Images', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
        body: Form(
          key: _formKey,
          child: TabBarView(
            children: <Widget>[
              GeneralScreen(),
              ShippingScreen(),
              AttributesScreen(),
              ImagesScreen(),
            ],
          ),
        ),
        bottomSheet: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            minimumSize: Size(double.infinity, 50),
          ),
          onPressed: () async {
            // Validate the form and upload product data to Firestore
            final productId = Uuid().v4();
            final userDoc = await _firestore
                .collection('vendors')
                .doc(_auth.currentUser!.uid)
                .get();
            if (_formKey.currentState?.validate() ?? false) {
              EasyLoading.show(status: 'Uploading product');
              await _firestore
                  .collection('products')
                  .doc(productId)
                  .set({
                    'productId': productId,
                    'productName': productProvider.productData['productName'],
                    'productPrice': productProvider.productData['productPrice'],
                    'productQuantity':
                        productProvider.productData['productQuantity'],
                    'productDescription':
                        productProvider.productData['productDescription'],
                    'productCategory':
                        productProvider.productData['productCategory'],
                    'shippingCost': productProvider.productData['shippingCost'],
                    'isShippingCharged':
                        productProvider.productData['isShippingCharged'],
                    'brandName': productProvider.productData['brandName'],
                    'sizeList': productProvider.productData['sizeList'],
                    'productImagesUrls':
                        productProvider.productData['productImagesUrls'],
                    'businessName':
                        (userDoc.data()
                            as Map<String, dynamic>)['businessName'],
                    'storeImage':
                        (userDoc.data() as Map<String, dynamic>)['storeImage'],
                    'countryValue':
                        (userDoc.data()
                            as Map<String, dynamic>)['countryValue'],
                    'cityValue':
                        (userDoc.data() as Map<String, dynamic>)['cityValue'],
                    'stateValue':
                        (userDoc.data() as Map<String, dynamic>)['stateValue'],
                    'phoneNumber':
                        (userDoc.data() as Map<String, dynamic>)['phoneNumber'],
                    'vendorId': _auth.currentUser!.uid,
                    'createDate': _formatedDate(DateTime.now()),
                  })
                  .whenComplete(() {
                    EasyLoading.dismiss();
                    productProvider.clearData();
                  });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please fill all fields correctly.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Text(
            'Upload Product',
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
        ),
      ),
    );
  }
}
