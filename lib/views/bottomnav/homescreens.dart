import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test_projcets/razoritemsmodle/razoritemsmodle.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:http/http.dart' as http;



class HomeScreens extends StatefulWidget {
  const HomeScreens({Key? key}) : super(key: key);

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
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
                  decoration: BoxDecoration(
                    border: Border.all(width: 3),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white70,

                  ),

                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Id: ${item.id}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                        ],
                      ),
                      Text(
                        "Name: ${item.name}",
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
    var url = Uri.parse('https://api.razorpay.com/v1/customers');
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



}