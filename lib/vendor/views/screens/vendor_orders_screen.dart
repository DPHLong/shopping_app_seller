import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class VendorOrdersScreen extends StatefulWidget {
  const VendorOrdersScreen({super.key});

  @override
  State<VendorOrdersScreen> createState() => _VendorOrdersScreenState();
}

class _VendorOrdersScreenState extends State<VendorOrdersScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> orderssStream = FirebaseFirestore.instance
        .collection('orders')
        .where('vendorId', isEqualTo: _auth.currentUser!.uid)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text(
          'Orders',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: orderssStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // If no data was retrieved from a category:
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'You have no order',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView(
            shrinkWrap: true,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Slidable(
                // Specify a key if the Slidable is dismissible.
                key: const ValueKey(0),

                // The start action pane is the one at the left or the top side.
                startActionPane: ActionPane(
                  // A motion is a widget used to control how the pane animates.
                  motion: const ScrollMotion(),

                  // A pane can dismiss the Slidable.
                  dismissible: DismissiblePane(onDismissed: () {}),

                  // All actions are defined in the children parameter.
                  children: [
                    // A SlidableAction can have an icon and/or a label.
                    SlidableAction(
                      onPressed: (context) async {
                        await _firestore
                            .collection('orders')
                            .doc(data['orderId'])
                            .update({'accepted': false});
                      },
                      backgroundColor: Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Reject',
                    ),
                    SlidableAction(
                      onPressed: (context) async {
                        await _firestore
                            .collection('orders')
                            .doc(data['orderId'])
                            .update({'accepted': true});
                      },
                      backgroundColor: Color(0xFF21B7CA),
                      foregroundColor: Colors.white,
                      icon: Icons.share,
                      label: 'Accept',
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 40,
                        child: data['accepted'] == true
                            ? Icon(
                                Icons.delivery_dining,
                                color: Colors.green.shade300,
                                size: 40,
                              )
                            : Icon(
                                Icons.access_time,
                                color: Colors.pink.shade900,
                                size: 40,
                              ),
                      ),
                      title: Text(
                        data['productName'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink.shade900,
                        ),
                      ),
                      subtitle: Text(
                        data['accepted'] == true
                            ? 'On delivery'
                            : 'Waiting for accept',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: data['accepted'] == true
                              ? Colors.green.shade300
                              : Colors.pink.shade900,
                        ),
                      ),
                      trailing: Text(
                        '\$${data['totalPrice'].toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink.shade900,
                        ),
                      ),
                    ),
                    ExpansionTile(
                      title: const Text(
                        'View Order Details',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: [
                        Card(
                          child: Column(
                            children: [
                              const Text(
                                'Buyer info:',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    child: Image.network(data['buyerImage']),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(data['fullName']),
                                      Text('Email: ${data['email']}'),
                                    ],
                                  ),
                                ],
                              ),
                              const Divider(),
                              const Text(
                                'Product info:',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    child: Image.network(data['productImage']),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Single price: \$${data['productPrice'].toStringAsFixed(2)}',
                                      ),
                                      Text('Quantity: ${data['quantity']}'),
                                      Text(
                                        'Size: ${data['productSize'] ?? 'N/A'}',
                                      ),
                                      Text(
                                        'Date of order: ${data['orderDate']}',
                                        style: const TextStyle(
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
