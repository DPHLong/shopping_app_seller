import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vendor_app/vendor/views/screens/inner_screens/vendor_chat_screen.dart';

class VendorMessagesScreen extends StatefulWidget {
  const VendorMessagesScreen({super.key});

  @override
  State<VendorMessagesScreen> createState() => _VendorMessagesScreenState();
}

class _VendorMessagesScreenState extends State<VendorMessagesScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Stream<QuerySnapshot> _chatsStream;
  late String vendorId;

  @override
  void initState() {
    super.initState();
    vendorId = _auth.currentUser!.uid;
    _chatsStream = _firestore
        .collection('chats')
        .where('vendorId', isEqualTo: vendorId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.pink),
        title: Text(
          'Messages Box',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.pink,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _chatsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          Map<String, dynamic> lastProductByBuyer = {};

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
              Map<String, dynamic> data =
                  documentSnapshot.data()! as Map<String, dynamic>;

              String message = data['message'].toString();
              String senderId = data['senderId'].toString();
              String productId = data['productId'].toString();
              String buyerId = data['buyerId'].toString();
              String productName = data['productName'].toString();
              String buyerName = data['buyerName'].toString();

              // check if message is from seller
              bool isSellerMessage = senderId == vendorId;

              if (!isSellerMessage) {
                String key = '$senderId-$productId';
                if (!lastProductByBuyer.containsKey(key)) {
                  lastProductByBuyer.addAll({key: productId});
                  return ListTile(
                    leading: CircleAvatar(child: Icon(Icons.person)),
                    title: Text(message, overflow: TextOverflow.ellipsis),
                    subtitle: Text(
                      '$buyerName by $productName',
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VendorChatScreen(
                            vendorId: vendorId,
                            buyerId: buyerId,
                            productId: productId,
                            productName: productName,
                            // data: data,
                          ),
                        ),
                      );
                    },
                  );
                }
              }
              return SizedBox();
            },
          );
        },
      ),
    );
  }
}
