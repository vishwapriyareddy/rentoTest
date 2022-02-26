import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:roi_test/constants.dart';
import 'package:roi_test/services/user_services.dart';

class UpdateProfile extends StatefulWidget {
  static const String id = 'update-profile';
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  User? user = FirebaseAuth.instance.currentUser;
  UserServices _user = UserServices();
  final _formKey = GlobalKey<FormState>();
  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var mobile = TextEditingController();
  var email = TextEditingController();
  Future<void> getuser() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      if (mounted) {
        if (value != null)
          setState(() {
            firstName.text = value.data()!['firstName'].toString();
            lastName.text = value.data()!['lastName'].toString();
            email.text = value.data()!['email'].toString();
            mobile.text = user!.phoneNumber.toString();
          });
      }
    });
  }

  updateProfile() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .update({
      'firstName': firstName.text,
      'lastName': lastName.text,
      'email': email.text,
    });
  }

  @override
  void initState() {
    getuser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //setState(() {
    //        mobile.text = user!.phoneNumber.toString();

    //});
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3c5784),
        title: Text(
          'Update Profile',
          style: TextStyle(color: white),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: white),
      ),
      bottomSheet: InkWell(
        onTap: () {
          if (_formKey.currentState!.validate()) {
            EasyLoading.show(status: 'Updating Profile...');
            updateProfile().then((value) {
              EasyLoading.showSuccess('Updated Successfully');
              Navigator.pop(context);
            });
          }
        },
        child: Container(
          width: double.infinity,
          height: 56,
          color: Colors.blueGrey[900],
          child: Center(
            child: Text(
              'Update',
              style: TextStyle(
                  color: white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    controller: firstName,
                    decoration: InputDecoration(
                        labelText: 'First Name',
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        contentPadding: EdgeInsets.zero),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter First Name';
                      }
                      return null;
                    },
                  )),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: TextFormField(
                    controller: lastName,
                    decoration: InputDecoration(
                        labelText: 'Last Name',
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        contentPadding: EdgeInsets.zero),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Last Name';
                      }
                      return null;
                    },
                  )),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: mobile,
                enabled: false,
                decoration: InputDecoration(
                    labelText: 'Mobile',
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    contentPadding: EdgeInsets.zero),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: email,
                decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    contentPadding: EdgeInsets.zero),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Email address';
                  }
                  return null;
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
