import 'dart:io';
import 'package:chat_app/Models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Provider/auth_provider.dart';
import '../../Widgets/round_button.dart';
import '../../Widgets/utils.dart';

class UserInformationGet extends StatefulWidget {
  const UserInformationGet({super.key});

  @override
  State<UserInformationGet> createState() => _UserInformationGetState();
}

class _UserInformationGetState extends State<UserInformationGet> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  late Size _size;
  File? _imageFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    ThemeData applicationTheme = Theme.of(context);

    return Scaffold(
      backgroundColor: applicationTheme.backgroundColor,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: _size.width * 0.8,
            height: _size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // addVerticalSpace(_size.width * 0.1),
                _buildProfileImage(),
                // addVerticalSpace(_size.width * 0.1),
                _buildNameTF(),
                _buildEmail(),
                const Expanded(child: SizedBox()),
                if (_isLoading)
                  const CircularProgressIndicator(
                      // color: AppColors.black,
                      ),
                const Expanded(child: SizedBox()),
                RoundButton(
                  text: 'Save',
                  onPressed: _saveUserInfo,
                ),
                // addVerticalSpace(_size.width * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameTF() {
    return TextField(
      controller: _nameController,
      minLines: 1,
      maxLines: 1,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person),
        hintText: 'Name',
        hintStyle: Theme.of(context).textTheme.displaySmall?.copyWith(
              // color: AppColors.grey,
              fontSize: _size.width * 0.05,
              fontWeight: FontWeight.normal,
            ),
        isDense: true,
        border: const OutlineInputBorder(),
      ),
      style: Theme.of(context).textTheme.displaySmall?.copyWith(
            // color: AppColors.black,
            fontSize: _size.width * 0.05,
          ),
    );
  }

  Widget _buildEmail() {
    return TextField(
      controller: _emailController,
      minLines: 1,
      maxLines: 1,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person),
        hintText: 'Email',
        hintStyle: Theme.of(context).textTheme.displaySmall?.copyWith(
              // color: AppColors.grey,
              fontSize: _size.width * 0.05,
              fontWeight: FontWeight.normal,
            ),
        isDense: true,
        border: const OutlineInputBorder(),
      ),
      style: Theme.of(context).textTheme.displaySmall?.copyWith(
            // color: AppColors.black,
            fontSize: _size.width * 0.05,
          ),
    );
  }

  Widget _buildProfileImage() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _imageFile != null
            ? CircleAvatar(
                backgroundImage: FileImage(_imageFile!),
                radius: _size.width * 0.2,
                // backgroundColor: AppColors.white,
              )
            : CircleAvatar(
                backgroundImage: const AssetImage("assets/images/avatar.png"),
                radius: _size.width * 0.2,
                // backgroundColor: AppColors.white,
              ),
        Positioned(
          top: (_size.width * 0.5) * 0.55,
          left: (_size.width * 0.5) * 0.55,
          child: IconButton(
            onPressed: _selectImage,
            icon: Icon(
              Icons.add_a_photo,
              size: _size.width * 0.1,
            ),
          ),
        ),
      ],
    );
  }

  void _saveUserInfo() async {
    var userId = ModalRoute.of(context)!.settings.arguments! as UserIdModel;

    setState(() => _isLoading = true);
    if (_nameController.text.isNotEmpty || _emailController.text.isNotEmpty) {
      Users users = Users(
        name: _nameController.text,
        email: _emailController.text,
        userPic: _imageFile != null ? _imageFile!.path : '',
      );
      Provider.of<AuthProvider>(context, listen: false)
          .usersUpdate(context, users, userId.userId);
      // await ref
      //     .read(senderUserDataControllerProvider)
      //     .saveSenderUserDataToFirebase(
      //       context,
      //       mounted,
      //       userName: _nameController.text,
      //       imageFile: _imageFile,
      //     );
    } else {
      buildShowSnackBar(context, 'Please Enter Name & Email');
    }
    setState(() => _isLoading = false);
  }

  void _selectImage() async {
    _imageFile = await pickImageFromGallery(context);
    setState(() {});
  }
}
