import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../razoritemsmodle/itemsshow.dart';

class ItemController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  Future<void> createItem(String name, String description, String amount) async {
    var username = 'rzp_test_FvnJEI4iGm9ZIq';
    var password = 'OtRiEpGItke8H5Sfvomk5TzB';
    var basicAuth = 'Basic ${base64.encode(utf8.encode('$username:$password'))}';

    try {
      var response = await http.post(Uri.parse("https://api.razorpay.com/v1/items"),
        headers: {
          'authorization': basicAuth,
        },
        body: {
          'name': name,
          'description': description,
          'amount': amount,
          'currency': 'INR',
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Item added successfully', backgroundColor: Colors.green, colorText: Colors.white);
        Get.to(ProDuctsScreens());
        print(response.statusCode);
      } else {
        Get.snackbar('Error', 'Failed to add item', backgroundColor: Colors.red, colorText: Colors.white);
        print(response.statusCode);
      }
    } catch (e) {
      Get.snackbar('Error', 'Error: $e', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
