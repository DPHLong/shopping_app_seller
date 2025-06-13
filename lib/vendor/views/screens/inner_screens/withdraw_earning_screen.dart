import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class WithdrawEarningScreen extends StatefulWidget {
  const WithdrawEarningScreen({super.key});

  @override
  State<WithdrawEarningScreen> createState() => _WithdrawEarningScreenState();
}

class _WithdrawEarningScreenState extends State<WithdrawEarningScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? bankName;
  String? accountName;
  String? accountNumber;
  double? amount;

  String _formatedDate(DateTime date) {
    final outputDateFormat = DateFormat("dd/MM/yyyy").format(date);
    return outputDateFormat;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Withdrew Earning',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.account_balance),
                  labelText: 'Bank Name',
                  hintText: 'Enter your bank name',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() => bankName = value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your bank name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: 'Account Name',
                  hintText: 'Enter your account name',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() => accountName = value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your account name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.account_balance_wallet),
                  labelText: 'Account Number',
                  hintText: 'Enter your account number',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() => accountNumber = value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your account number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  icon: Icon(CupertinoIcons.money_dollar),
                  labelText: 'Amount',
                  hintText: 'Enter an amount',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() => amount = double.tryParse(value));
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              InkWell(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    final userDoc = await _firestore
                        .collection('vendors')
                        .doc(_auth.currentUser!.uid)
                        .get();
                    final withdrawId = Uuid().v4();
                    EasyLoading.show(status: 'Uploading request');
                    await _firestore
                        .collection('withdrawal')
                        .doc(withdrawId)
                        .set({
                          'withdrawId': withdrawId,
                          'businessName':
                              (userDoc.data()
                                  as Map<String, dynamic>)['businessName'],
                          'vendorId': _auth.currentUser!.uid,
                          'bankName': bankName,
                          'accountName': accountName,
                          'accountNumber': accountNumber,
                          'amount': amount,
                          'createDate': _formatedDate(DateTime.now()),
                        })
                        .whenComplete(() {
                          EasyLoading.dismiss();
                        });
                  } else {
                    debugPrint('Form is not valid');
                  }
                },
                child: Container(
                  height: 50,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.pink.shade900,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'GET CASH',
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
            ],
          ),
        ),
      ),
    );
  }
}
