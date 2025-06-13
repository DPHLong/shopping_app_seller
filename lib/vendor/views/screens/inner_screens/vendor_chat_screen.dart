import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VendorChatScreen extends StatefulWidget {
  const VendorChatScreen({
    super.key,
    required this.vendorId,
    required this.buyerId,
    required this.productId,
    required this.productName,
    // required this.data,
  });

  final String vendorId;
  final String buyerId;
  final String productId;
  final String productName;
  // final dynamic data;

  @override
  State<VendorChatScreen> createState() => _VendorChatScreenState();
}

class _VendorChatScreenState extends State<VendorChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _messController = TextEditingController();
  late Stream<QuerySnapshot> _chatsStream;

  @override
  void initState() {
    super.initState();
    _chatsStream = _firestore
        .collection('chats')
        .where('vendorId', isEqualTo: _auth.currentUser!.uid)
        .where('buyerId', isEqualTo: widget.buyerId)
        .where('productId', isEqualTo: widget.productId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  String _formatedDate(DateTime date) {
    final outputDateFormat = DateFormat('dd/MM/yyyy HH:mm:ss').format(date);
    return outputDateFormat;
  }

  void _sendMessage() async {
    final DocumentSnapshot vendorDoc = await _firestore
        .collection('vendors')
        .doc(widget.vendorId)
        .get();
    final DocumentSnapshot buyerDoc = await _firestore
        .collection('buyers')
        .doc(widget.buyerId)
        .get();
    String message = _messController.text;

    if (message.isNotEmpty) {
      await _firestore
          .collection('chats')
          .add({
            'productId': widget.productId,
            'buyerName': (buyerDoc.data() as Map<String, dynamic>)['fullName'],
            'buyerPhoto':
                (buyerDoc.data() as Map<String, dynamic>)['profileImage'],
            'buyerId': widget.buyerId,
            'vendorName':
                (vendorDoc.data() as Map<String, dynamic>)['businessName'],
            'vendorPhoto':
                (vendorDoc.data() as Map<String, dynamic>)['storeImage'],
            'vendorId': widget.vendorId,
            'productName': widget.productName,
            'senderId': _auth.currentUser!.uid,
            'message': message,
            'timestamp': DateTime.now(),
          })
          .whenComplete(() {
            _messController.clear();
          });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.pink),
        title: Text(
          'Chat > ${widget.productName}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.pink,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _chatsStream,
              builder:
                  (
                    BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot,
                  ) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    return ListView(
                      reverse: true,
                      children: snapshot.data!.docs.map((
                        DocumentSnapshot document,
                      ) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        final String senderId = data['senderId'];
                        bool isVendor = senderId == _auth.currentUser!.uid;

                        return ListTile(
                          leading: CircleAvatar(
                            child: Image.network(
                              isVendor
                                  ? data['vendorPhoto']
                                  : data['buyerPhoto'],
                            ),
                          ),
                          title: Text(data['message']),
                          subtitle: Text(data['buyerName'].toString()),
                        );
                      }).toList(),
                    );
                  },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messController,
                    decoration: InputDecoration(hintText: 'type a message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.pink),
                  onPressed: () => _sendMessage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
