import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_projcets/firebasefirestore/employee.dart';

class SignUpScreens extends StatefulWidget {
  const SignUpScreens({super.key});

  @override
  State<SignUpScreens> createState() => _SignUpScreensState();
}

class _SignUpScreensState extends State<SignUpScreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EmployeeScreens(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Flutter",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Firebase",
              style: TextStyle(
                color: Colors.orange,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Employee").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.hasData) {
            final employees = snapshot.data!.docs;
            return ListView.builder(
              itemCount: employees.length,
              itemBuilder: (context, index) {
                final employee = employees[index].data() as Map<String, dynamic>;
                return  Container(
                  margin: const EdgeInsets.only(left: 20.0,right: 20.0,top: 30),
                  child:  Column(
                    children: [
                      Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 5.0,
                        child:Container(
                          padding: const EdgeInsets.all(20.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child:  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Name: ${employee['name']?? ""}" ,style: TextStyle(color: Colors.blue,fontSize: 20,fontWeight: FontWeight.bold),),
                              Text("Age: 22" ,style: TextStyle(color: Colors.orange,fontSize: 20,fontWeight: FontWeight.bold),),
                              Text("Loction: Indian" ,style: TextStyle(color: Colors.blue,fontSize: 20,fontWeight: FontWeight.bold),)

                            ],
                          ),
                        )
                        ,
                      )
                    ],
                  ),
                );

              },
            );
          } else {
            return const Center(child: Text("No data available"));
          }
        },
      ),
    );
  }
}
