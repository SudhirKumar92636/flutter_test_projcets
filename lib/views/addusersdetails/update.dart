import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_projcets/views/addusersdetails/showusersrealtime.dart';
import 'package:image_picker/image_picker.dart';

class UpdatePage extends StatefulWidget {
  final String id;
  final String username;
  final String address;
  final String email;
  final String password;
  final String phone;
  final String image;

  const UpdatePage({
    Key? key,
    required this.id,
    required this.username,
    required this.address,
    required this.email,
    required this.password,
    required this.phone,
    required this.image,
  }) : super(key: key);

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  File? pickedImage;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    usernameController.text = widget.username;
    addressController.text = widget.address;
    phoneController.text = widget.phone;
    emailController.text = widget.email;
    passwordController.text = widget.password;
  }

  showAlertBox() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Pick Image From"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
              ),
              ListTile(
                onTap: () {
                  pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
                leading: const Icon(Icons.image),
                title: const Text("Gallery"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xFFE383B7),
        ),
        body: Container(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        showAlertBox();
                      },
                      child: (pickedImage != null)
                          ? CircleAvatar(
                        radius: 80,
                        backgroundImage: FileImage(pickedImage!),
                      )
                          : (widget.image.isNotEmpty)
                          ? CircleAvatar(
                        radius: 80,
                        backgroundImage: NetworkImage(widget.image),
                      )
                          : const CircleAvatar(
                        radius: 80,
                        child: Icon(Icons.person, size: 80),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black, width: 2.0,
                          ),
                        ),
                        hintText: 'Enter Your UserName',
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: addressController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.location_on),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black, width: 2.0,
                          ),
                        ),
                        hintText: 'Enter Your Address',
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black, width: 2.0,
                          ),
                        ),
                        hintText: 'Enter Your Phone Number',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      readOnly: true,
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black, width: 2.0,
                          ),
                        ),
                        hintText: 'Enter Your Email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black, width: 2.0,
                          ),
                        ),
                        hintText: 'Enter Your Password',
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isUpdating
                            ? null
                            : () {
                          upload(
                            usernameController.text,
                            addressController.text,
                            emailController.text,
                            passwordController.text,
                            phoneController.text,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: _isUpdating
                            ? const CircularProgressIndicator()
                            : const Text(
                          "Update",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  pickImage(ImageSource imageSource) async {
    final photo = await ImagePicker().pickImage(source: imageSource);
    if (photo != null) {
      final tempImage = File(photo.path);
      setState(() {
        pickedImage = tempImage;
      });
    }
  }

  upload(String username, String address, String email, String password,
      String phone) async {
    if (username.isEmpty ||
        address.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        phone.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Enter Required Fields"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Ok"),
              ),
            ],
          );
        },
      );
    } else {
      await uploadData();
    }
  }

  uploadData() async {
    var userId = widget.id;
    setState(() {
      _isUpdating = true;
    });

    try {
      String? imageUrl;
      if (pickedImage != null) {
        // Upload new image to Firebase Storage
        UploadTask uploadTask = FirebaseStorage.instance
            .ref('profile_pics')
            .child(userId)
            .putFile(pickedImage!);
        TaskSnapshot taskSnapshot = await uploadTask;
        imageUrl = await taskSnapshot.ref.getDownloadURL();
      }

      Map<String, String> updatedData = {
        "Username": usernameController.text,
        "Address": addressController.text,
        "Email": emailController.text,
        "Password": passwordController.text,
        "Phone": phoneController.text,
      };

      if (imageUrl != null) {
        updatedData["image"] = imageUrl;
      }

      await FirebaseDatabase.instance.ref('users/$userId').update(updatedData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User data updated successfully')),
      );

      // Navigate to ShowUserInfo screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ShowUserInfo()),
      );
    } catch (e) {
      print("Error updating data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating data')),
      );
    } finally {
      setState(() {
        _isUpdating = false;
      });
    }
  }
}
