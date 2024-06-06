import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_projcets/views/addusersdetails/profile.dart';

class UpdateScreens extends StatefulWidget {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String email;
  const UpdateScreens({super.key, required this.name, required this.address, required this.phone, required this.email, required this.id});

  @override
  State<UpdateScreens> createState() => _UpdateScreensState();
}

class _UpdateScreensState extends State<UpdateScreens> {
  TextEditingController unameController = TextEditingController();
  TextEditingController uAddressController = TextEditingController();
  TextEditingController uPhoneController = TextEditingController();
  TextEditingController uEmailController =TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
   unameController.text = widget.name;
   uAddressController.text = widget.address;
   uEmailController.text = widget.email;
   uPhoneController.text = widget.phone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Screens"),
        backgroundColor: Colors.blue,

      ),
      body: ListView(
        padding: EdgeInsets.all(10),

        children: [
          TextField(
            controller:unameController ,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
              )
            ),
          ),
          SizedBox(height: 10,),
          TextField(
            controller:uAddressController ,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                )
            ),
          ),
          SizedBox(height: 10,),
          TextField(
            controller: uEmailController,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                )
            ),
          ),
          SizedBox(height: 10,),
          TextField(
            controller: uPhoneController,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                )
            ),
          ),
          SizedBox(height: 10,),
          ElevatedButton.icon(onPressed: (){
            _updateData();
          }, label: Text("Edit"),icon: Icon(Icons.edit),)
        ],
      ),
    );
  }

  void _updateData() {
    // Update the data in Firebase Realtime Database
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child("users").child(widget.id); // Corrected reference path
    databaseReference.update({
      'name': unameController.text,
      'address': uAddressController.text,
      'phonenumber': uPhoneController.text,
      'email': uEmailController.text,
    }).then((_) {
      // Data updated successfully
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data updated successfully',),
          duration: Duration(seconds: 2 ),
          backgroundColor: Colors.deepOrange,
        ),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) =>const ProfileScreens() ,));

    }).catchError((error) {
      // Error occurred while updating data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update data: $error'),
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }
}
