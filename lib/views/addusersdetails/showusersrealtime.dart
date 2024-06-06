import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test_projcets/auth/phonesign.dart';
import 'package:flutter_test_projcets/views/addusersdetails/update.dart';

class ShowUserInfo extends StatefulWidget {
  const ShowUserInfo({Key? key}) : super(key: key);

  @override
  State<ShowUserInfo> createState() => _ShowUserInfoState();
}

class _ShowUserInfoState extends State<ShowUserInfo> {
  final auth = FirebaseAuth.instance;
  late DatabaseReference ref;
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = auth.currentUser?.uid;
    if (userId != null) {
      ref = FirebaseDatabase.instance.ref("users/$userId");
    } else {
      ref = FirebaseDatabase.instance.ref().child("no_users"); // Dummy reference
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE383B7),
        actions: [
          ElevatedButton.icon(
            onPressed: _showLogoutDialog,
            icon: const Icon(Icons.logout, color: Colors.white, size: 30,),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE383B7),
            ),
            label: const Text(""),
          ),
        ],
      ),
      body: Container(
        child: StreamBuilder<DatabaseEvent>(
          stream: ref.onValue,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
              var userData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (userData["image"] != null)
                          Center(
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(userData["image"]),
                              radius: 80,
                            ),
                          ),
                        const SizedBox(height: 10,),
                        TextFormField(
                          readOnly: true,
                          initialValue: userData["Username"] ?? "",
                          style: const TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        TextFormField(
                          readOnly: true,
                          initialValue: userData["Email"] ?? "",
                          style: const TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 25,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              height: 40,
                              width: 300,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UpdatePage(
                                        id: userData["Id"] ?? "",
                                        username: userData["Username"] ?? "",
                                        address: userData["Address"] ?? "",
                                        email: userData["Email"] ?? "",
                                        password: userData["Password"] ?? "",
                                        phone: userData["Phone"] ?? "",
                                        image: userData["image"] ?? "",
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.edit, color: Colors.white),
                                label: const Text(
                                  'Update',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text("No Data Found"),
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PhoneScreen()),
      );
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PhoneScreen(),));
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }
}
