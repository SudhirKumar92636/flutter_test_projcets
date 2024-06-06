import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test_projcets/razoritemsmodle/razoritemsmodle.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:http/http.dart' as http;

import 'addItems.dart';
import 'editscreens.dart';

class ProDuctsScreens extends StatefulWidget {
  const ProDuctsScreens({Key? key}) : super(key: key);

  @override
  State<ProDuctsScreens> createState() => _ProDuctsScreensState();
}

class _ProDuctsScreensState extends State<ProDuctsScreens> {
  RxList<RazorpayitemsmodlesDart> itemList = <RazorpayitemsmodlesDart>[].obs;

  @override
  void initState() {
    super.initState();
    getCustomersApiData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Show Api Data"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Get.to(AddItems());
      },child: Icon(Icons.add),),
      body: FutureBuilder<RazorpayitemsmodlesDart>(
        future: getCustomersApiData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            var allItems = snapshot.data?.items ?? [];
            return  ListView.builder(
              itemCount: allItems.length,
              itemBuilder: (context, index) {
                var item = allItems[index];
                return Container(
                  color: Colors.grey,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Name: ${item.name}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: Text("Edit"),
                                onTap: () {
                                  Get.to(EditScreens(
                                      name: item.name,
                                      amount: item.amount,
                                      description: item.description,
                                  id:item.id));
                                },
                              ),
                              PopupMenuItem(
                                child: Text("Delete"),
                                onTap: () {
                                  // Add your delete logic here
                                  deleteItem(item.id!);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        "Id: ${item.id}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        "Amount: ${item.amount}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Description: ${item.description}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );


          }
        },
      ),
    );
  }

  Future<RazorpayitemsmodlesDart> getCustomersApiData() async {
    var url = Uri.parse('https://api.razorpay.com/v1/items');
    var username = 'rzp_test_FvnJEI4iGm9ZIq';
    var password = 'OtRiEpGItke8H5Sfvomk5TzB';
    var basicAuth = 'Basic ' + base64.encode(utf8.encode('$username:$password'));

    var response = await http.get(url, headers: {'Authorization': basicAuth});
    if (response.statusCode == 200) {
      RazorpayitemsmodlesDart data =
      RazorpayitemsmodlesDart.fromJson(jsonDecode(response.body));
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> deleteItem(String itemId) async {
    var url = Uri.parse('https://api.razorpay.com/v1/items/$itemId');
    var username = 'rzp_test_FvnJEI4iGm9ZIq';
    var password = 'OtRiEpGItke8H5Sfvomk5TzB';
    var basicAuth = 'Basic ' + base64.encode(utf8.encode('$username:$password'));

    var response = await http.delete(
      url,
      headers: {
        'Authorization': basicAuth,
      },
    );

    if (response.statusCode == 200) {
      print('Item deleted successfully');
    } else {
      print('Failed to delete item: ${response.statusCode}');
      throw Exception('Failed to delete item: ${response.reasonPhrase}');
    }
  }

}