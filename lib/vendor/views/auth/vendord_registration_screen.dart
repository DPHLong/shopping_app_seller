import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendor_app/vendor/controller/vendor_controller.dart';

class VendordRegistrationScreen extends StatefulWidget {
  const VendordRegistrationScreen({super.key});

  @override
  State<VendordRegistrationScreen> createState() =>
      _VendordRegistrationScreenState();
}

class _VendordRegistrationScreenState extends State<VendordRegistrationScreen> {
  // const VendordRegistrationScreen({super.key});
  final VendorController _vendorController = VendorController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Uint8List? _image;
  String? countryValue;
  String? stateValue;
  String? cityValue;
  String? businessName;
  String? emailAddress;
  String? phoneNumber;

  Future<void> selectGalleryImage() async {
    final Uint8List? image = await _vendorController.pickStoreImage(
      ImageSource.gallery,
    );
    setState(() {
      _image = image;
    });
  }

  Future<void> selectCameraImage() async {
    final Uint8List? image = await _vendorController.pickStoreImage(
      ImageSource.camera,
    );
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.pink,
            toolbarHeight: 200,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                return FlexibleSpaceBar(
                  background: Center(
                    child: Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(color: Colors.white),
                      child: _image != null
                          ? Image.memory(_image!, fit: BoxFit.cover)
                          : IconButton(
                              onPressed: () => selectGalleryImage(),
                              icon: Icon(CupertinoIcons.photo),
                            ),
                    ),
                  ),
                );
              },
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.person),
                        labelText: 'Business Name',
                        hintText: 'Enter your business name',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() => businessName = value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your business name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        icon: Icon(Icons.email),
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() => emailAddress = value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                        ).hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        icon: Icon(Icons.phone),
                        labelText: 'Phone Number',
                        hintText: 'Enter your phone number',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() => phoneNumber = value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        } else if (!RegExp(
                          r'^\+?[0-9]{10,15}$',
                        ).hasMatch(value)) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: SelectState(
                        onCountryChanged: (value) {
                          setState(() {
                            countryValue = value;
                          });
                        },
                        onStateChanged: (value) {
                          setState(() {
                            stateValue = value;
                          });
                        },
                        onCityChanged: (value) {
                          setState(() {
                            cityValue = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.pink,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                EasyLoading.show(status: 'Registering...');
                _vendorController
                    .vendorRegistrationForm(
                      businessName: businessName!,
                      emailAddress: emailAddress!,
                      phoneNumber: phoneNumber!,
                      countryValue: countryValue!,
                      stateValue: stateValue!,
                      cityValue: cityValue!,
                      image: _image,
                    )
                    .whenComplete(() {
                      EasyLoading.dismiss();
                    });
              } else {
                debugPrint('Form is not valid');
              }
            },
            child: Text(
              'Register',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
