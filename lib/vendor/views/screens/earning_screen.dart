import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vendor_app/vendor/views/screens/inner_screens/withdraw_earning_screen.dart';
import 'package:vendor_app/vendor/views/screens/vendor_messages_screen.dart';

class EarningScreen extends StatefulWidget {
  const EarningScreen({super.key});

  @override
  State<EarningScreen> createState() => _EarningScreenState();
}

class _EarningScreenState extends State<EarningScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference vendors = FirebaseFirestore.instance.collection(
      'vendors',
    );
    final Stream<QuerySnapshot> ordersStream = FirebaseFirestore.instance
        .collection('orders')
        .where('vendorId', isEqualTo: _auth.currentUser!.uid)
        .snapshots();

    return FutureBuilder<DocumentSnapshot>(
      future: vendors.doc(_auth.currentUser!.uid).get(),
      builder: (context, vendorSnapshot) {
        if (vendorSnapshot.hasError) {
          return Text("Something went wrong");
        }

        if (vendorSnapshot.hasData && !vendorSnapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (vendorSnapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> vendorData =
              vendorSnapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.pink,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(vendorData['storeImage']),
                  ),
                  Text(
                    'Welcome ${vendorData['businessName']}',
                    style: TextStyle(color: Colors.white),
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: ordersStream,
              builder: (context, ordersSnapshot) {
                if (ordersSnapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (ordersSnapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                final oderDocument = ordersSnapshot.data!.docs;
                final screenWidth = MediaQuery.of(context).size.width;
                double totalEarning = 0.0;
                int totalOrder = 0;
                for (var order in oderDocument) {
                  totalEarning += order['totalPrice'];
                  totalOrder++;
                }

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 100,
                        width: screenWidth * 0.5,
                        decoration: BoxDecoration(
                          color: Colors.pink.shade900,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Total Earning',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$${totalEarning.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(
                          color: Colors.pink.shade900,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Total Orders',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '$totalOrder',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WithdrawEarningScreen(),
                            ),
                          );
                        },
                        child: Container(
                          height: 50,
                          width: screenWidth - 60,
                          decoration: BoxDecoration(
                            color: Colors.pink.shade900,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'WITHDREW',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VendorMessagesScreen(),
                            ),
                          );
                        },
                        child: Container(
                          height: 50,
                          width: screenWidth - 60,
                          decoration: BoxDecoration(
                            color: Colors.pink.shade900,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'MESSAGES BOX',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                CupertinoIcons.chat_bubble,
                                color: Colors.white,
                              ),
                            ],
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
        return const CircularProgressIndicator();
      },
    );
  }
}
