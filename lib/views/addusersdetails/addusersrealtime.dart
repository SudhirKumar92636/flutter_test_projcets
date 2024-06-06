import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_projcets/views/bottomnav/bottomnav.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';

class Registrations extends StatefulWidget {
  const Registrations({Key? key}) : super(key: key);

  @override
  State<Registrations> createState() => _RegistrationsState();
}

class _RegistrationsState extends State<Registrations> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  File? pickedImage;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrations'),
        backgroundColor: Colors.grey,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        showAlertBox();
                      },
                      child: pickedImage != null
                          ? CircleAvatar(
                        radius: 80,
                        backgroundImage: FileImage(pickedImage!),
                      )
                          : const CircleAvatar(
                        radius: 80,
                        child: Icon(Icons.person, size: 80),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        hintText: 'Enter Your UserName',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter Your UserName';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: addressController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.location_on),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        hintText: 'Enter Your Address',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter Your Address';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        hintText: 'Enter Your Phone Number',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter Your Phone Number';
                        } else if (value.length != 10) {
                          return 'Phone number should be 10 digits';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        hintText: 'Enter Your Email',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter Your Email';
                        }
                        bool emailValid = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value);
                        if (!emailValid) {
                          return "Please enter a valid email";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        hintText: 'Enter Your Password',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter Your Password';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              upload(
                                usernameController.text.toString(),
                                addressController.text.toString(),
                                phoneController.text.toString(),
                                emailController.text.toString(),
                                passwordController.text.toString(),
                              );
                            }
                          },
                          child: const Text("Submit"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              )
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(onPressed: () {
                         // Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreens(),));
                        }, child: const Text("Login now"))
                      ],
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
    try {
      final photo = await ImagePicker().pickImage(source: imageSource);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        pickedImage = tempImage;
      });
    } catch (ex) {
      print(ex.toString());
    }
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

  upload(String username, String address, String phone, String email, String password) async {
    if (username == "" || address == "" || phone == "" || email == "" || password == "" || pickedImage == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Enter required fields"),
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
      try {
        uploadData();
      } on FirebaseAuthException catch (ex) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Authentication Error"),
              content: Text(ex.message ?? "An error occurred"),
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
      }
    }
  }

  uploadData() async {
    try {
      var id = FirebaseAuth.instance.currentUser?.uid;
      UploadTask uploadTask = FirebaseStorage.instance
          .ref('profile_pics')
          .child(emailController.text.toString())
          .putFile(pickedImage!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String url = await taskSnapshot.ref.getDownloadURL();
      id = FirebaseAuth.instance.currentUser?.uid;
      DatabaseReference ref = FirebaseDatabase.instance.ref("users/$id");
      await ref.set({
        "Id": id,
        "Username": usernameController.text.toString(),
        "Address": addressController.text.toString(),
        "Phone": phoneController.text.toString(),
        "Email": emailController.text.toString(),
        "Password": passwordController.text.toString(),
        "image": url,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Successful')),
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) => const BottomNavigationsPages(),));
      });
    } catch (ex) {}}}
