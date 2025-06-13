import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vendor_app/vendor/provider/product_provider.dart';

class ImagesScreen extends StatefulWidget {
  const ImagesScreen({super.key});

  @override
  State<ImagesScreen> createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen>
    with AutomaticKeepAliveClientMixin<ImagesScreen> {
  @override
  bool get wantKeepAlive => true;

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();
  final List<File> _selectedImages = [];
  final List<String> _imageUrls = [];

  Future<void> _pickImage() async {
    final XFile? pickedImg = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImg != null) {
      setState(() {
        _selectedImages.add(File(pickedImg.path));
      });
      debugPrint('Selected image path: ${pickedImg.path}');
    } else {
      debugPrint('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider productProvider = Provider.of<ProductProvider>(
      context,
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const Text('Images Screen', style: TextStyle(fontSize: 24)),
              const SizedBox(height: 20),
              GridView.builder(
                itemCount: _selectedImages.length + 1,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  childAspectRatio: 3 / 3,
                ),
                itemBuilder: (context, index) {
                  return index == 0
                      ? Center(
                          child: IconButton(
                            onPressed: () {
                              _pickImage();
                            },
                            icon: Icon(Icons.add_a_photo),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(_selectedImages[index - 1]),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        );
                },
              ),
              const SizedBox(height: 20),
              if (_selectedImages.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      // Save and upload images to Firebase Storage
                      // and update the productProvider with the image URLs
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                      ),
                      onPressed: () async {
                        try {
                          EasyLoading.show(status: 'Uploading images');
                          for (var img in _selectedImages) {
                            final ref = _storage
                                .ref()
                                .child('productImages')
                                .child(Uuid().v4());
                            await ref.putFile(img).whenComplete(() async {
                              await ref.getDownloadURL().then((url) {
                                setState(() => _imageUrls.add(url));
                              });
                              EasyLoading.dismiss();
                            });
                          }
                          productProvider.getFormdata(
                            productImagesUrls: _imageUrls,
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error uploading images: $e'),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Save & Upload Images',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() => _selectedImages.clear());
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Images were cleared successfully!'),
                          ),
                        );
                      },
                      child: const Text('Clear Images'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
