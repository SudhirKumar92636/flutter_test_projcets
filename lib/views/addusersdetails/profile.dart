import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_projcets/auth/phonesign.dart';
import 'package:flutter_test_projcets/views/addusersdetails/editscreens.dart';

class ProfileScreens extends StatefulWidget {
  const ProfileScreens({super.key});

  @override
  State<ProfileScreens> createState() => _ProfileScreensState();
}

class _ProfileScreensState extends State<ProfileScreens> {
  final auth = FirebaseAuth.instance;
  late DatabaseReference ref;

  @override
  void initState() {
    super.initState();
    if (auth.currentUser != null) {
      ref = FirebaseDatabase.instance.ref("users");
    } else {
      ref = FirebaseDatabase.instance.ref().child("no_users"); // Dummy reference
    }
  }

 // var data = FirebaseDatabase.instance.ref("users").child(FirebaseAuth.instance.currentUser!.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Show Users"),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(onPressed: (){
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PhoneScreen(),));
          }, icon: Icon(Icons.logout,color: Colors.white,))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FirebaseAnimatedList(
              query: ref,
              itemBuilder: (context, snapshot, animation, index) {
                return Material(
                  borderRadius: BorderRadius.circular(10),
                  elevation: 5.0,
                  
                  child: Container(

                    width: MediaQuery.of(context).size.width,
                   padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(36.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: CircleAvatar(
                              maxRadius: 50,
                              child: Icon(
                                Icons.person,
                                size: 50,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Name: ${snapshot.child("name").value.toString()}",
                                style: TextStyle(fontSize: 16),
                              ),
                              IconButton(onPressed: (){
                             Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateScreens(
                               id:snapshot.child("id").value.toString(),
                               name:snapshot.child("name").value.toString(),
                               address:snapshot.child("address").value.toString(),
                                 phone:snapshot.child("phonenumber").value.toString(),
                                 email:snapshot.child("email").value.toString()
                             ),));
                    
                              }, icon: Icon(Icons.edit))
                            ],
                          ),
                          Text(
                            "Address: ${snapshot.child("address").value.toString()}",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Phone Number: ${snapshot.child("phonenumber").value.toString()}",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Email: ${snapshot.child("email").value.toString()}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
