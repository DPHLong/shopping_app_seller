import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vendor_app/models/vendor_model.dart';
import 'package:vendor_app/vendor/views/auth/vendor_auth_screen.dart';
import 'package:vendor_app/vendor/views/screens/vendor_main_screen.dart';

class LandingScreen extends StatelessWidget {
  LandingScreen({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final CollectionReference vendorStream = FirebaseFirestore.instance
        .collection('vendors');

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: vendorStream.doc(_auth.currentUser!.uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.data!.exists) {
            return VendorAuthScreen();
          }

          VendorUserModel vendorUserModel = VendorUserModel.fromJson(
            snapshot.data!.data() as Map<String, dynamic>,
          );

          // If the vendor is approved, show the main screen
          if (vendorUserModel.approved) {
            return VendorMainScreen();
          }
          // If the vendor is not approved, show the landing screen with details
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    vendorUserModel.storeImage,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  vendorUserModel.businessName,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Email: ${vendorUserModel.emailAddress}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 5),
                Text(
                  'Phone: ${vendorUserModel.phoneNumber}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 5),
                Text(
                  'Location: ${vendorUserModel.cityValue}, ${vendorUserModel.stateValue}, ${vendorUserModel.countryValue}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 5),
                Text(
                  'Your Application has been sent to the admin for approval. We will notify you later.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink, // Background color
                  ),
                  onPressed: () async {
                    await _auth.signOut();
                    // Navigator.of(context).pushReplacementNamed('/login');
                  },
                  child: Text(
                    'Sign Out',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
