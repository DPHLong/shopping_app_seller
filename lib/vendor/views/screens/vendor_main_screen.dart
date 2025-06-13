import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vendor_app/vendor/views/screens/earning_screen.dart';
import 'package:vendor_app/vendor/views/screens/edit_product_screen.dart';
import 'package:vendor_app/vendor/views/screens/logout_screen.dart';
import 'package:vendor_app/vendor/views/screens/upload_screen.dart';
import 'package:vendor_app/vendor/views/screens/vendor_orders_screen.dart';

class VendorMainScreen extends StatefulWidget {
  const VendorMainScreen({super.key});

  @override
  State<VendorMainScreen> createState() => _VendorMainScreenState();
}

class _VendorMainScreenState extends State<VendorMainScreen> {
  int _pageIndex = 0;
  // final PageController _pageController = PageController();
  final List<Widget> _pages = [
    EarningScreen(),
    UploadScreen(),
    VendorOrdersScreen(),
    EditProductScreen(),
    LogoutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.pink,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.money_dollar),
            label: 'Earnings',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.upload), label: 'Upload'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Edit'),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Logout'),
        ],
        currentIndex: _pageIndex,
        onTap: (idx) {
          setState(() {
            _pageIndex = idx;
            //_pageController.jumpToPage(idx);
          });
        },
      ),
    );
  }
}
