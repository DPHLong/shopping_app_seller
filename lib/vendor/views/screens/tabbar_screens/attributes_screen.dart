import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/vendor/provider/product_provider.dart';

class AttributesScreen extends StatefulWidget {
  const AttributesScreen({super.key});

  @override
  State<AttributesScreen> createState() => _AttributesScreenState();
}

class _AttributesScreenState extends State<AttributesScreen>
    with AutomaticKeepAliveClientMixin<AttributesScreen> {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  bool isTyping = false;
  List<String> sizes = [];

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
            const Text('Attributes Screen', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            TextFormField(
              controller: _brandController,
              decoration: InputDecoration(labelText: 'Brand'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter brand name';
                }
                return null;
              },
              onChanged: (value) {
                productProvider.getFormdata(brandName: value);
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    controller: _sizeController,
                    decoration: InputDecoration(labelText: 'Size'),
                    onChanged: (value) {
                      setState(() => isTyping = true);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                (isTyping)
                    ? ElevatedButton(
                        onPressed: () {
                          if (_sizeController.text.isNotEmpty) {
                            sizes.add(_sizeController.text);
                            _sizeController.clear();
                            setState(() => isTyping = false);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please enter a size')),
                            );
                          }
                        },
                        child: Text('Add Size'),
                      )
                    : Container(),
              ],
            ),
            const SizedBox(width: 16),
            if (sizes.isNotEmpty) ...[
              Text(
                'Added Sizes:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: sizes.length,
                  itemBuilder: (_, index) {
                    return ListTile(
                      title: Text(sizes[index]),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            sizes.removeAt(index);
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                    ),
                    onPressed: () {
                      productProvider.getFormdata(sizeList: sizes);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('All Sizes were saved')),
                      );
                    },
                    child: Text(
                      'Save all sizes',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() => sizes.clear());
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('All sizes removed')),
                      );
                    },
                    child: Text('Remove all Sizes'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
