import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_managment_apk/data/model/network_response.dart';
import 'package:task_managment_apk/data/services/network_caller.dart';
import 'package:task_managment_apk/data/utils/urls.dart';
import 'package:task_managment_apk/ui/controller/auth_controller.dart';
import 'package:task_managment_apk/ui/widget/snack_bar_message.dart';
import 'package:task_managment_apk/ui/widget/tm_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _phoneNumberTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _updateProfileInProgress = false;

  XFile? _selectedImage;

  @override
  void initState() {
    _setUserData();
    super.initState();
  }

  void _setUserData(){
    _emailTEController.text = AuthController.userData?.email ?? '';
    _firstNameTEController.text = AuthController.userData?.firstName ?? '';
    _lastNameTEController.text = AuthController.userData?.lastName ?? '';
    _phoneNumberTEController.text = AuthController.userData?.mobile ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return    Scaffold(
      appBar: const TMAppBar(
        isProfileScreenOpen: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 24,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 60,
                ),
                Text(
                  'Updated Profile',
                  style: Theme.of(context).textTheme.displaySmall!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 36,
                ),
                _buildPhotoPicker(),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _emailTEController,
                  enabled: false,
                  decoration: const InputDecoration(
                      hintText: 'Email'
                  ),
                  validator: (String? value){
                    if(value?.isEmpty == true){
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _firstNameTEController,
                  decoration: const InputDecoration(
                      hintText: 'First Name'
                  ),
                  validator: (String? value){
                    if(value?.isEmpty == true){
                      return 'Enter a First Name';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),

                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _lastNameTEController,
                  decoration: const InputDecoration(
                      hintText: 'Last Name'
                  ),
                  validator: (String? value){
                    if(value?.isEmpty == true){
                      return 'Enter a Last name';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _phoneNumberTEController,
                  decoration: const InputDecoration(
                      hintText: 'Phone Number'
                  ),
                  validator: (String? value){
                    if(value?.isEmpty == true){
                      return 'Enter a valid Phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _passwordTEController,
                  decoration: const InputDecoration(
                      hintText: 'Password'
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(onPressed: (){
                  if(_formKey.currentState!.validate()){

                  }
                }, child: const Icon(Icons.arrow_circle_right_outlined))
              ],
            ),
          ),
        ),
      ),  
    );
  }

  Widget _buildPhotoPicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              height: 55,
              width: 100,
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                )
              ),
              alignment: Alignment.center,
              // child: const Icon(Icons.camera_alt),
              child: const Text('Photo', style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),),
            ),
            const SizedBox(width: 8,),
             Text(_getSelectedPhotoTitle(), style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold
            ),)
          ],
        )
      ),
    );
  }
  
  Future<void> _updateProfile() async{
    _updateProfileInProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody = {
      "email": _emailTEController.text,
      "firstName": _firstNameTEController.text,
      "lastName": _lastNameTEController.text,
      "mobile": _phoneNumberTEController.text,
    };

    if(_passwordTEController.text.isNotEmpty){
      requestBody['password'] = _passwordTEController.text;
    }
    if(_selectedImage != null){
      List<int> imageBytes = await _selectedImage!.readAsBytes();
      String convertedImage = base64Encode(imageBytes);
      requestBody['photo'] = convertedImage;
    }

    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.profileUpdate,
      body: requestBody,
    );
    if(response.isSuccess){
      // AuthController.saveUserData(userModel);
      snackBarMessage(context, 'Profile has been Update');
    }else{
      snackBarMessage(context, response.errorMessage, true);
    }
    
  }

  String _getSelectedPhotoTitle(){
    if(_selectedImage != null){
      return _selectedImage!.name;
    }
    return 'Selected Photo';
  }


  Future<void> _pickImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    if(pickedImage != null){
      _selectedImage = pickedImage;
      setState(() {});
    }
 }

}
