import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServicesController{
   Future addEmployeeDetails(Map<String, dynamic> employeeMap, String id)async{
     return await FirebaseFirestore.instance.collection("Employee").doc(id).set(employeeMap);
   }


}