import 'dart:io';

import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/controllers/common/auth_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../constants/my_colors.dart';
import '../../main.dart';
import '../widgets/button_styles.dart';
import '../widgets/input_decoration.dart';
import '../widgets/input_label.dart';
import '../widgets/sized_box.dart';
import 'about_app_screen.dart';
import 'auth/auth_screen.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var phoneController = TextEditingController();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _aboutController = TextEditingController();
  bool _isPasswordVisible = false;
  late bool isClient;
  File? _selectedImage;
  final _passwordController = TextEditingController();

  bool _isUpdatingData = false;
  Map<String, File> imageDocuments = {};

  @override
  void initState() {
    isClient = Provider.of<Auth>(context, listen: false).isClient;
    _nameController.text = (isClient
        ? Provider.of<Auth>(context, listen: false).customer!.name
        : Provider.of<Auth>(context, listen: false).provider!.name)!;
    phoneController.text = (isClient
        ? Provider.of<Auth>(context, listen: false).customer!.phone
        : Provider.of<Auth>(context, listen: false).provider!.phone)!;
    _emailController.text = isClient
        ? Provider.of<Auth>(context, listen: false)
                .customer!
                .email
                ?.toString() ??
            ''
        : Provider.of<Auth>(context, listen: false)
                .provider!
                .email
                ?.toString() ??
            '';
    if (!isClient) {
      _aboutController.text = Provider.of<Auth>(context, listen: false)
              .provider!
              .about
              ?.toString() ??
          '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Provider.of<Auth>(context).provider!.image");
    print(Provider.of<Auth>(context).provider);
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                color: MyColors.DarkestBackMore,
              ),
              Positioned(
                  top: 0,
                  right: 0,
                  child: SvgPicture.asset(
                    'assets/svg/more_overlay.svg',
                  )),
              Positioned(
                  top: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon:
                                SvgPicture.asset('assets/svg/back_appbar.svg'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          SizedBoxedW16,
                          const Text(
                            'تعديل الحساب',
                            style: TextStyle(
                              color: MyColors.MainGohan,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              Positioned(
                top: 32,
                right: 0,
                left: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBoxedH16,
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: _selectedImage != null
                                ? FileImage(_selectedImage!)
                                : CachedNetworkImageProvider(
                                    isClient
                                        ? Provider.of<Auth>(context)
                                            .customer!
                                            .image!
                                        : Provider.of<Auth>(context)
                                            .provider!
                                            .image!,
                                  ) as ImageProvider,
                          ),
                          if (!isClient)
                            Provider.of<Auth>(context).provider!.image!.contains(
                                    "https://Test.ajeer.cloud/Icons/default.png")
                                ? Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: InkWell(
                                      onTap: _pickImage,
                                      child: const CircleAvatar(
                                        radius: 16,
                                        backgroundColor: MyColors.MainBulma,
                                        child: Icon(Icons.edit,
                                            color: Colors.white, size: 16),
                                      ),
                                    ),
                                  )
                                : SizedBox(),

                          if (isClient)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: _pickImage,
                                child: const CircleAvatar(
                                  radius: 16,
                                  backgroundColor: MyColors.MainBulma,
                                  child: Icon(Icons.edit,
                                      color: Colors.white, size: 16),
                                ),
                              ),
                            )
                        ],
                      ),
                      SizedBoxedH8,
                      Text(
                        isClient
                            ? Provider.of<Auth>(context, listen: false)
                                .customer!
                                .name
                            : Provider.of<Auth>(context, listen: false)
                                .provider!
                                .name!,
                        style: const TextStyle(
                          color: MyColors.MainGohan,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                children: [
                  const SizedBox(height: 18),
                  LabelText(text: 'Full Name'.tr()),
                  const SizedBox(height: 8),
                  TextField(
                    enabled: isClient ? true : false,
                    controller: _nameController,
                    decoration:
                        buildInputDecoration(hintText: 'Full Name'.tr()),
                  ),
                  const SizedBox(height: 16),
                  LabelText(text: 'Email'.tr()),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    decoration: buildInputDecoration(hintText: 'Email'.tr()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال البريد الإلكتروني';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'الرجاء إدخال بريد إلكتروني صحيح';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 16),
                  LabelText(text: 'Phone Number'.tr()),
                  const SizedBox(height: 8),
                  TextFormField(
                    readOnly: true,
                    enabled: false,
                    controller: phoneController,
                    decoration: buildInputDecoration(hintText: 'Phone Number'.tr()).copyWith(
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintStyle: TextStyle(color: Colors.grey[600]),
                    ),
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 16),
                  if (Provider.of<Auth>(context, listen: false).isProvider)
                    Column(
                      children: [
                        // LabelText(text: 'التخصص'.tr()),
                        // const SizedBox(height: 8),
                        // DropdownButtonFormField<String>(
                        //   decoration: buildInputDecoration(hintText: 'التخصص'.tr()),
                        //   items: ['Option 1', 'Option 2', 'Option 3'].map((e) => DropdownMenuItem<String>(child: Text(e), value: e)).toList(),
                        //   onChanged: (value) {},
                        // ),
                        // const SizedBox(height: 16),
                        LabelText(text: 'نبذة مختصرة'.tr()),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _aboutController,
                          maxLines: 3,
                          decoration: buildInputDecoration(
                              hintText: 'نبذة مختصرة'.tr()),
                        ),
                        const SizedBox(height: 16),
                        // LabelText(text: 'Proof of identity'.tr()),
                        // const SizedBox(height: 8),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   crossAxisAlignment: CrossAxisAlignment.end,
                        //   children: [
                        //     Expanded(child: buildIdProofBox('Front view of ID card', 'idFront')),
                        //     const SizedBox(width: 16),
                        //     Expanded(child: buildIdProofBox('Back of ID photo', 'idBack')),
                        //     const SizedBox(width: 16),
                        //     Expanded(child: buildIdProofBox('Personal photo with ID', 'idSelfie')),
                        //   ],
                        // ),
                        const SizedBox(height: 16),
                        const SizedBox(height: 16),
                      ],
                    ),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: TextButton(
                      style: flatButtonPrimaryStyle,
                      onPressed: _isUpdatingData
                          ? null
                          : () async {
                              setState(() {
                                _isUpdatingData = true;
                              });

                              ResponseHandler handledResponse;
                              if (isClient) {
                                handledResponse = await Provider.of<Auth>(
                                        context,
                                        listen: false)
                                    .updateCustomerProfile(
                                  name: _nameController.text,
                                  emailAddress: _emailController.text,
                                  profileImage: _selectedImage != null
                                      ? XFile(_selectedImage!.path)
                                      : null,
                                );
                              } else {
                                handledResponse = await Provider.of<Auth>(
                                        context,
                                        listen: false)
                                    .updateProviderProfile(
                                  name: _nameController.text,
                                  emailAddress: _emailController.text,
                                  phone: phoneController.text,
                                  about: _aboutController.text,
                                  profileImage: _selectedImage != null
                                      ? XFile(_selectedImage!.path)
                                      : null,
                                );
                              }

                              setState(() {
                                _isUpdatingData = false;
                              });

                              if (handledResponse.status ==
                                  ResponseStatus.success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'تم تحديث الملف الشخصي بنجاح'.tr())),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        handledResponse.errorMessage ??
                                            'حدث خطأ أثناء التحديث'.tr()),
                                    backgroundColor: MyColors.MainBulma,
                                  ),
                                );
                              }
                            },
                      child: _isUpdatingData
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              'Save'.tr(),
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: TextButton(
                      style: flatButtonStyle,
                      onPressed: () async {
                        bool? confirmDelete = await showDialog<bool>(
                          context: context,
                          builder: (context) => Directionality(
                            textDirection: TextDirection.rtl,
                            child: AlertDialog(
                              title: Align(
                                alignment: Alignment.centerRight,
                                child: Text('الدعم الفني'),
                              ),
                              content: Text(
                                'للحفاظ على أمان بياناتك وضمان تجربة أفضل، يُرجى التواصل مع فريق الدعم الفني لإتمام عملية حذف الحساب.',
                                textAlign: TextAlign.right,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text('إلغاء'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: Text('موافق',
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          ),
                        );

                        // If user confirmed deletion
                        if (confirmDelete == true) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AboutAppScreen()));
                        }
                      },
                      child: Text(
                        'Delete Account'.tr(),
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildIdProofBox(String title, String type) {
    return Center(
      child: Column(
        children: [
          Text(
            title.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: MyColors.LightDark,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          // show picked image if picked
          InkWell(
            onTap: () => pickImage(type),
            child: imageDocuments[type] != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      imageDocuments[type]!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  )
                : SvgPicture.asset('assets/svg/add_image_frame.svg'),
          ),
        ],
      ),
    );
  }

  Widget phoneNumber(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: phoneController,
      readOnly: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'please_enter_phone_number'.tr();
        }
        if (value.length < 10) {
          return 'phone_number_must_be_10_digits_at_minimum'.tr();
        }
        return null;
      },
      maxLines: 1,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        enabledBorder: InputBorders.enabledBorder,
        errorBorder: InputBorders.errorBorder,
        focusedBorder: InputBorders.focusedBorder,
        focusedErrorBorder: InputBorders.focusedErrorBorder,
        hintText: 'ex: 09XXXXXXXX'.tr(),
        alignLabelWithHint: true,
        hintStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: MyColors.LightDark),
      ),
      style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w400, color: MyColors.Darkest),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10)
      ],
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }

  Widget buildPasswordField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'please_enter_password'.tr();
        }
        if (value.length < 6) {
          return 'password_must_be_at_least_6_characters'.tr();
        }
        return null;
      },
      maxLines: 1,
      controller: _passwordController,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        enabledBorder: InputBorders.enabledBorder,
        errorBorder: InputBorders.errorBorder,
        focusedBorder: InputBorders.focusedBorder,
        focusedErrorBorder: InputBorders.focusedErrorBorder,
        hintText: 'Password'.tr(),
        alignLabelWithHint: true,
        hintStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: MyColors.LightDark),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: MyColors.LightDark,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      obscureText: !_isPasswordVisible,
      style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w400, color: MyColors.Darkest),
      keyboardType: TextInputType.visiblePassword,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }

  Future pickImage(String type) async {
    try {
      final XFile? _image =
          await ImagePicker().pickImage(source: ImageSource.camera);

      if (_image == null) return;
      setState(() {
        imageDocuments[type] = File(_image.path);
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await ImagePicker().pickImage(
        source: await _showImageSourceDialog(),
        maxWidth: 600,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (error) {
      print('Error picking image: $error');
    }
  }

  Future<ImageSource> _showImageSourceDialog() async {
    return await showDialog<ImageSource>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('اختر مصدر الصورة'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(ImageSource.camera),
                child: const Text('الكاميرا'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
                child: const Text('المعرض'),
              ),
            ],
          ),
        ) ??
        ImageSource.gallery;
  }
}
