import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_projcets/views/bottomnav/bottomnav.dart';
import 'package:get/get.dart';

class AddUsersDetails extends StatefulWidget {
  const AddUsersDetails({super.key});

  @override
  State<AddUsersDetails> createState() => _AddUsersDetailsState();
}

class _AddUsersDetailsState extends State<AddUsersDetails> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref().child("users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Users"),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                hintText: "Enter Your Name",
                prefixIcon: Icon(Icons.person)
            ),
          ),
          SizedBox(height: 10,),
          TextField(
            controller: addressController,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                hintText: "Enter Your Address",
                prefixIcon: Icon(Icons.home)
            ),
          ),
          SizedBox(height: 10,),
          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                hintText: "Enter Your Phone Number",
                prefixIcon: Icon(Icons.phone)
            ),
          ),
          SizedBox(height: 10,),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                hintText: "Enter Your Email Address",
                prefixIcon: Icon(Icons.email)
            ),
          ),
          SizedBox(height: 20,),
          ElevatedButton.icon(onPressed: (){
            if (nameController.text.isEmpty || addressController.text.isEmpty || phoneController.text.isEmpty || emailController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all the fields")));

            }

            User? user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              String id = databaseRef.push().key ?? "";
              databaseRef.child(id).set({
                "id":id,
                "name": nameController.text.toString(),
                "address": addressController.text.toString(),
                "phonenumber": phoneController.text.toString(),
                "email": emailController.text.toString(),
              }).then((value) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data added successfully")));
                Get.to(BottomNavigationsPages());
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to add data: $error")));
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No user is logged in")));
            }
          }, label: Text("Sign Up") ,icon: Icon(Icons.app_registration),)
        ],
      ),
    );
  }
}
