import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class VendorController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Pick image from gallery or camera
  pickStoreImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? file = await imagePicker.pickImage(source: source);

    if (file != null) {
      return await file.readAsBytes();
    } else {
      debugPrint('No image selected.');
      return null;
    }
  }

  // Upload image to Firebase Storage
  Future<String> uploadVendorStoreImage(Uint8List? image) async {
    String imageUrl = '';
    try {
      final ref = _storage
          .ref()
          .child('storeImage')
          .child(_auth.currentUser!.uid);
      final uploadTask = ref.putData(image!);
      final snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
    } catch (e) {
      return '--- Error uploading image: $e ---';
    }
    debugPrint('--- Image uploaded successfully: $imageUrl');
    return imageUrl;
  }

  Future<String> vendorRegistrationForm({
    required String businessName,
    required String emailAddress,
    required String phoneNumber,
    required String countryValue,
    required String stateValue,
    required String cityValue,
    required Uint8List? image,
  }) async {
    String result = 'error';
    try {
      final String imgUrl = await uploadVendorStoreImage(image);
      await _firestore.collection('vendors').doc(_auth.currentUser!.uid).set({
        'businessName': businessName,
        'emailAddress': emailAddress,
        'phoneNumber': phoneNumber,
        'countryValue': countryValue,
        'stateValue': stateValue,
        'cityValue': cityValue,
        'storeImage': imgUrl,
        'vendorId': _auth.currentUser!.uid,
        'approved': false,
      });

      result = '--- success ---';
    } catch (e) {
      result = e.toString();
    }
    debugPrint('--- Vendor registration result: $result');
    return result;
  }
}
