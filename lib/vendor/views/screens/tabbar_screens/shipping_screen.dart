import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/vendor/provider/product_provider.dart';

class ShippingScreen extends StatefulWidget {
  const ShippingScreen({super.key});

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen>
    with AutomaticKeepAliveClientMixin<ShippingScreen> {
  @override
  bool get wantKeepAlive => true;

  bool _isShippingCharged = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final ProductProvider productProvider = Provider.of<ProductProvider>(
      context,
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Shipping Screen', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            CheckboxListTile(
              value: _isShippingCharged,
              title: const Text('Charge for Shipping'),
              onChanged: (value) {
                setState(() {
                  _isShippingCharged = value ?? false;
                  productProvider.getFormdata(
                    isShippingCharged: _isShippingCharged,
                  );
                });
              },
            ),

            if (_isShippingCharged)
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Shipping Cost',
                  prefixIcon: Icon(CupertinoIcons.money_dollar),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter shipping price';
                  }
                  return null;
                },
                onChanged: (value) {
                  productProvider.getFormdata(
                    shippingCost: double.tryParse(value),
                  );
                },
              ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
