import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/controllers/additemscontroller.dart';

class AddItems extends StatelessWidget {
  AddItems({Key? key}) : super(key: key);

  final ItemController itemController = Get.put(ItemController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Items"),
        backgroundColor: Colors.indigo,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 10),
          TextFormField(
            controller: itemController.nameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              prefixIcon: const Icon(Icons.title),
              labelText: "Enter Item Title",
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: itemController.descriptionController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              prefixIcon: const Icon(Icons.description),
              labelText: "Enter Item Description",
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: itemController.amountController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              prefixIcon: const Icon(Icons.money),
              labelText: "Enter Item Amount",
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              itemController.createItem(
                itemController.nameController.text,
                itemController.descriptionController.text,
                itemController.amountController.text,
              );
            },
            child: const Text("Add Item"),
          ),
        ],
      ),
    );
  }
}
