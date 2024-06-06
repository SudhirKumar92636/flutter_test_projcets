import 'dart:convert';
import 'package:flutter_test_projcets/razoritemsmodle/itemsshow.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class EditScreens extends StatefulWidget {
  final String? name;
  final int? amount;
  final String? description;
  final String? id;

  const EditScreens({
    Key? key,
    this.name,
    this.amount,
    this.description,
    this.id,
  }) : super(key: key);

  @override
  State<EditScreens> createState() => _EditScreensState();
}

class _EditScreensState extends State<EditScreens> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.name ?? "";
    descriptionController.text = widget.description ?? "";
    amountController.text = widget.amount.toString() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Screens"),
        backgroundColor: Colors.indigo,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              prefixIcon: Icon(Icons.person),
              labelText: "Enter Item Name",
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: descriptionController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              prefixIcon: Icon(Icons.description),
              labelText: "Enter Item Description",
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              prefixIcon: Icon(Icons.money),
              labelText: "Enter Item Amount",
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Handle editing logic here
              updateItem(widget.id!, nameController.text, int.parse(amountController.text), descriptionController.text);
            },
            child: Text("Edit Item"),
          ),
        ],
      ),
    );
  }

  Future<void> updateItem(String itemId, String newName, int newAmount, String newDescription) async {
    var url = Uri.parse('https://api.razorpay.com/v1/items/$itemId');
    var username = 'rzp_test_FvnJEI4iGm9ZIq';
    var password = 'OtRiEpGItke8H5Sfvomk5TzB';
    var basicAuth = 'Basic ' + base64.encode(utf8.encode('$username:$password'));

    // Prepare the request body
    var body = jsonEncode({
      'name': newName,
      'amount': newAmount,
      'description': newDescription,
    });

    // Send PATCH request
    var response = await http.patch(
      url,
      headers: {
        'Authorization': basicAuth,
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      Get.to(ProDuctsScreens());
      print('Item updated successfully');

    } else {
      print('Failed to update item: ${response.statusCode}');
      throw Exception('Failed to update item: ${response.reasonPhrase}');
    }
  }
}
