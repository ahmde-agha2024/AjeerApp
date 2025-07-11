import 'dart:io';
import 'dart:ui';
import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/controllers/common/auth_provider.dart';
import 'package:ajeer/controllers/general/on_boarding_provider.dart';
import 'package:ajeer/models/common/category_model.dart';
import 'package:ajeer/models/customer/provider/service_provider_account.dart';
import 'package:ajeer/ui/screens/auth/freedaysscreen.dart';
import 'package:ajeer/ui/screens/auth/login_screen.dart';
import 'package:ajeer/ui/screens/auth/verify_code_password_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../../../constants/get_storage.dart';
import '../../../constants/my_colors.dart';
import '../../widgets/button_styles.dart';
import '../../widgets/input_decoration.dart';
import '../../widgets/input_label.dart';
import '../faq_screen.dart';
import '../home_client/tabs_screen.dart';
import '../home_provider/tabs_provider_screen.dart';
import '../terms_and_conditions_screen.dart';
import 'auth_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  Map<int, List<Category>> selectedCategoriesSubcategories =
      {}; // Maps selected category id to selected subcategory ids

  var phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _inviite_link = TextEditingController();
  final _passwordController = TextEditingController();
  final _passportController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _bioController = TextEditingController();
  Map<String, File> imageDocuments = {};
  int? selectedCategoryId;
  int? selectedCityId;
  bool _isCategoriesFetched = false;
  bool _isSubCategoriesFetched = false;
  bool _isCitiesFetched = false;
  ResponseHandler<List<Category>?>? categories;
  ResponseHandler<List<Category>?>? subCategories;
  ResponseHandler<List<City>?>? cities;
  bool _isAgree = false;
  bool _isLoading = false;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  int _currentStep = 0;
  bool _showOTPFields = false;
  bool _showAllFields = false;

  int _resendTimer = 90; // 1:30 in seconds
  Timer? _timer;

  @override
  void didChangeDependencies() {
    if (!_isCategoriesFetched) {
      Provider.of<OnBoardingProvider>(context, listen: false)
          .fetchProviderCategories()
          .then((response) {
        setState(() {
          categories = response;
          _isCategoriesFetched = true;
        });
      });
    }
    if (!_isCitiesFetched) {
      Provider.of<OnBoardingProvider>(context, listen: false)
          .fetchProviderCities()
          .then((response) {
        setState(() {
          cities = response;
          _isCitiesFetched = true;
        });
      });
    }
  }

  Future<ResponseHandler<List<Category>>> _fetchSubCategories(
      int categoryId) async {
    return await Provider.of<OnBoardingProvider>(context, listen: false)
        .fetchProviderSubCategories(categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, authProvider, child) {
        if (authProvider.isClient) {
          return _buildClientForm(authProvider);
        } else if (authProvider.isProvider) {
          return _buildProviderStepper(authProvider);
        } else {
          return Center(child: Text("Invalid user type".tr()));
        }
      },
    );
  }

  Widget _buildClientForm(Auth authProvider) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          stepOneContent(),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: TextButton(
              style: flatButtonStyle,
              onPressed: _isLoading
                  ? null
                  : () async {
                      if (_formKey.currentState!.validate()) {
                        if (_passwordController.text !=
                            _confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Color(0xffBF3131),
                            content: Text(
                              "passwords_do_not_match".tr(),
                              style: TextStyle(color: Color(0xffEEEEEE)),
                            ),
                          ));
                          return;
                        }

                        if (!_isAgree) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Color(0xffBF3131),
                              content: Text(
                                "You must agree to the terms and conditions"
                                    .tr(),
                                style: TextStyle(color: Color(0xffEEEEEE)),
                              ),
                            ),
                          );
                          return;
                        }

                        setState(() {
                          _isLoading = true;
                        });

                        try {
                          final response = await Provider.of<Auth>(context,
                                  listen: false)
                              .sendOTPNew(phoneNumber: phoneController.text);

                          if (response.status == ResponseStatus.success) {
                            await showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.white,
                              builder: (BuildContext bottomSheetContext) {
                                return _buildOTPBottomSheetContent(
                                  authProvider,
                                  bottomSheetContext,
                                  context,
                                  onOTPVerified: () async {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    ResponseHandler handledResponse =
                                        await authProvider.signUpAsCustomer(
                                      fullName: _nameController.text,
                                      phoneNumber: phoneController.text,
                                      password: _passwordController.text,
                                      passwordConfirmation:
                                          _confirmPasswordController.text,
                                      invite_link: _inviite_link.text,
                                    );
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    if (handledResponse.status ==
                                        ResponseStatus.success) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "تم إنشاء الحساب بنجاح".tr(),
                                            style: TextStyle(
                                                color: Color(0xffEEEEEE)),
                                          ),
                                        ),
                                      );
                                      authProvider.isLoginScreen = true;
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              context.read<Auth>().isProvider
                                                  ? AuthScreen()
                                                  : AuthScreen(),
                                        ),
                                        (route) => false,
                                      );
                                    } else if (handledResponse.errorMessage !=
                                        null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Color(0xffBF3131),
                                          content: Text(
                                            handledResponse.errorMessage!.tr(),
                                            style: TextStyle(
                                                color: Color(0xffEEEEEE)),
                                          ),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Color(0xffBF3131),
                                          content: Text(
                                            'حاول مرة أخرى'.tr(),
                                            style: TextStyle(
                                                color: Color(0xffEEEEEE)),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                );
                              },
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Color(0xffBF3131),
                                content: Text(
                                  response.errorMessage ??
                                      'حدث خطأ أثناء إرسال رمز التحقق',
                                  style: TextStyle(color: Color(0xffEEEEEE)),
                                ),
                              ),
                            );
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Color(0xffBF3131),
                              content: Text(
                                'حدث خطأ أثناء إرسال رمز التحقق',
                                style: TextStyle(color: Color(0xffEEEEEE)),
                              ),
                            ),
                          );
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      }
                    },
              child: _isLoading
                  ? const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Text(
                      'إنشاء حساب',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOTPBottomSheetContent(Auth authProvider,
      BuildContext bottomSheetContext, BuildContext mainContext,
      {required Function() onOTPVerified}) {
    int resendTimer = 90;
    Timer? localTimer;
    bool isActive = true;
    String otp = "";
    void startResendTimer(Function setModalState) {
      setModalState(() {
        resendTimer = 90;
      });
      localTimer?.cancel();
      localTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (!isActive) {
          timer.cancel();
          return;
        }
        setModalState(() {
          if (resendTimer > 0) {
            resendTimer--;
          } else {
            timer.cancel();
          }
        });
      });
    }

    String timerText() {
      int minutes = resendTimer ~/ 60;
      int seconds = resendTimer % 60;
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StatefulBuilder(
        builder: (context, setModalState) {
          if (localTimer == null) {
            startResendTimer(setModalState);
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/Icons/otp.png',
                width: 100,
                height: 100,
              ),
              SizedBox(height: 16),
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'تأكيد الحساب',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'من فضلك أدخل رمز التحقق المرسل إلى ${phoneController.text}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 24),
              Directionality(
                textDirection: TextDirection.ltr,
                child: PinCodeTextField(
                  appContext: bottomSheetContext,
                  length: 6,
                  onChanged: (value) {
                    otp = value;
                  },
                  onCompleted: (value) async {
                    setState(() {
                      _isLoading = true;
                    });
                    try {
                      final response = await http.post(
                        Uri.parse('https://dev.ajeer.cloud/customer/checkotp'),
                        headers: {
                          'Content-Type': 'application/json',
                        },
                        body: jsonEncode({
                          'phone': phoneController.text,
                          'message': value,
                        }),
                      );

                      if (response.statusCode == 200) {
                        isActive = false;
                        localTimer?.cancel();
                        Navigator.pop(bottomSheetContext);
                        await storage.write('seen_onboarding', 'true');
                        onOTPVerified();
                      } else {
                        if (isActive) {
                          ScaffoldMessenger.of(mainContext).showSnackBar(
                            SnackBar(
                              backgroundColor: Color(0xffBF3131),
                              content: Text(
                                'رمز التحقق غير صحيح',
                                style: TextStyle(color: Color(0xffEEEEEE)),
                              ),
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      if (isActive) {
                        ScaffoldMessenger.of(mainContext).showSnackBar(
                          SnackBar(
                            backgroundColor: Color(0xffBF3131),
                            content: Text(
                              'حدث خطأ أثناء عملية التحقق',
                              style: TextStyle(color: Color(0xffEEEEEE)),
                            ),
                          ),
                        );
                      }
                    } finally {
                      if (isActive) {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    }
                  },
                  pinTheme: PinTheme(
                    selectedFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    activeFillColor: Colors.white,
                    activeColor: MyColors.MainBeerus,
                    inactiveColor: MyColors.MainBeerus,
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(16.0),
                    fieldHeight:
                        MediaQuery.of(bottomSheetContext).size.width / 7,
                    fieldWidth:
                        MediaQuery.of(bottomSheetContext).size.width / 7.6,
                  ),
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.number,
                  textStyle: const TextStyle(
                    fontSize: 18,
                    color: MyColors.MainZeno,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 24),
              TextButton(
                onPressed: resendTimer > 0
                    ? null
                    : () async {
                        setModalState(() {
                          // show loading if needed
                        });
                        try {
                          final response = await Provider.of<Auth>(mainContext,
                                  listen: false)
                              .sendOTPNew(phoneNumber: phoneController.text);
                          if (response.status == ResponseStatus.success) {
                            startResendTimer(setModalState);
                            if (isActive) {
                              ScaffoldMessenger.of(mainContext).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'تم إعادة إرسال رمز التحقق',
                                    style: TextStyle(color: Color(0xffEEEEEE)),
                                  ),
                                ),
                              );
                            }
                          } else {
                            if (isActive) {
                              ScaffoldMessenger.of(mainContext).showSnackBar(
                                SnackBar(
                                  backgroundColor: Color(0xffBF3131),
                                  content: Text(
                                    response.errorMessage ??
                                        'حدث خطأ أثناء إرسال رمز التحقق',
                                    style: TextStyle(color: Color(0xffEEEEEE)),
                                  ),
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          if (isActive) {
                            ScaffoldMessenger.of(mainContext).showSnackBar(
                              SnackBar(
                                backgroundColor: Color(0xffBF3131),
                                content: Text(
                                  'حدث خطأ أثناء إرسال رمز التحقق',
                                  style: TextStyle(color: Color(0xffEEEEEE)),
                                ),
                              ),
                            );
                          }
                        } finally {
                          if (isActive) {
                            setModalState(() {
                              // hide loading if needed
                            });
                          }
                        }
                      },
                child: Text(
                  resendTimer > 0
                      ? 'لم تستلم أي رمز؟ إعادة الإرسال ${timerText()}'
                      : 'لم تستلم أي رمز؟ إعادة الإرسال',
                  style: TextStyle(
                    color: resendTimer > 0 ? Colors.grey : MyColors.MainBulma,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProviderStepper(Auth authProvider) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          if (_currentStep == 0) stepOneContent(),
          if (_currentStep == 1) stepTwoContent(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: TextButton(
                    style: flatButtonStyle,
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              if (_currentStep == 0) {
                                if (_passwordController.text !=
                                    _confirmPasswordController.text) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    backgroundColor: Color(0xffBF3131),
                                    content: Text(
                                      "passwords_do_not_match".tr(),
                                      style:
                                          TextStyle(color: Color(0xffEEEEEE)),
                                    ),
                                  ));
                                  return;
                                } else {
                                  setState(() => _currentStep += 1);
                                }
                              } else {
                                if (imageDocuments['idFront'] == null ||
                                    imageDocuments['idSelfie'] == null) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      "الرجاء تعبئة الصور المطلوبة",
                                      style:
                                          TextStyle(color: Color(0xffEEEEEE)),
                                    ),
                                    backgroundColor: Color(0xffBF3131),
                                  ));
                                  return;
                                }
                                if (!_isAgree) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "You must agree to the terms and conditions"
                                            .tr(),
                                        style:
                                            TextStyle(color: Color(0xffEEEEEE)),
                                      ),
                                      backgroundColor: Color(0xffBF3131),
                                    ),
                                  );
                                  return;
                                }
                                if (selectedCategoryId == null ||
                                    selectedCategoriesSubcategories.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        backgroundColor: Color(0xffBF3131),
                                        content: Text(
                                          " الرجاء إختيار التخصص والتخصص الفرعي",
                                          style: TextStyle(
                                              color: Color(0xffEEEEEE)),
                                        )),
                                  );
                                  return;
                                }
                                await storage.write('seen_onboarding', 'true');
                                setState(() {
                                  _isLoading = true;
                                });
                                try {
                                  // Show initial image upload dialog
                                  await showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext dialogContext) {
                                      return BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 10, sigmaY: 10),
                                        child: Dialog(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(32)),
                                          insetPadding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 24),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 24),
                                            child: Stack(
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(height: 40),
                                                    Text(
                                                      'رفع الصورة الشخصية',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xff636363),
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    SizedBox(height: 12),
                                                    Text(
                                                      'يرجى رفع صورة شخصية واضحة ومناسبة \nستظهر في ملفك الشخصي وتخضع لمراجعة فريق الدعم',
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        color:
                                                            Color(0xffBDBDBD),
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    SizedBox(height: 32),
                                                    Center(
                                                      child: Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: [
                                                          Image.asset(
                                                            'assets/Icons/Ellipse.png',
                                                            width: 160,
                                                            height: 160,
                                                            fit: BoxFit.contain,
                                                          ),
                                                          imageDocuments[
                                                                      'additionalImage'] ==
                                                                  null
                                                              ? Container(
                                                                  width: 60,
                                                                  height: 60,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Color(
                                                                          0xffE4572E),
                                                                      width: 4,
                                                                    ),
                                                                  ),
                                                                  child: Image
                                                                      .asset(
                                                                    'assets/Icons/profiledialog.png',
                                                                    color: Color(
                                                                        0xffE4572E),
                                                                    width: 30,
                                                                    height: 30,
                                                                  ),
                                                                )
                                                              : ClipOval(
                                                                  child: Image
                                                                      .file(
                                                                    imageDocuments[
                                                                        'additionalImage']!,
                                                                    width: 160,
                                                                    height: 160,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 16),
                                                    Text(
                                                      imageDocuments[
                                                                  'additionalImage'] ==
                                                              null
                                                          ? 'لم تقم برفع صورة بعد'
                                                          : 'تم رفع الصورة',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff636363),
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    SizedBox(height: 32),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: OutlinedButton
                                                              .icon(
                                                            style:
                                                                OutlinedButton
                                                                    .styleFrom(
                                                              side: BorderSide(
                                                                  color: Color(
                                                                      0xffBDBDBD),
                                                                  width: 2),
                                                              minimumSize: Size(
                                                                  double
                                                                      .infinity,
                                                                  54),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                              ),
                                                            ),
                                                            iconAlignment:
                                                                IconAlignment
                                                                    .end,
                                                            icon: Image.asset(
                                                              'assets/Icons/solar_camera-bold.png',
                                                              color: Color(
                                                                  0xff636363),
                                                              width: 22,
                                                              height: 22,
                                                            ),
                                                            label: Text(
                                                              'التقاط صورة',
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xff636363),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              await pickImage(
                                                                  'additionalImage',
                                                                  fromCamera:
                                                                      true);
                                                              (dialogContext
                                                                      as Element)
                                                                  .markNeedsBuild();
                                                            },
                                                          ),
                                                        ),
                                                        SizedBox(width: 12),
                                                        Expanded(
                                                          child: ElevatedButton
                                                              .icon(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  Color(
                                                                      0xffE04836),
                                                              minimumSize: Size(
                                                                  double
                                                                      .infinity,
                                                                  54),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                              ),
                                                            ),
                                                            iconAlignment:
                                                                IconAlignment
                                                                    .end,
                                                            icon: Image.asset(
                                                              'assets/Icons/tabler_folder-up.png',
                                                              color:
                                                                  Colors.white,
                                                              width: 22,
                                                              height: 22,
                                                            ),
                                                            label: Text(
                                                              textAlign:
                                                                  TextAlign.end,
                                                              'رفع صورة من الجهاز',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              await pickImage(
                                                                  'additionalImage');
                                                              (dialogContext
                                                                      as Element)
                                                                  .markNeedsBuild();
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 24),
                                                    Text(
                                                      ': شروط الصورة',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff959595),
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontSize: 12,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    SizedBox(height: 4),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        _buildCondition(
                                                            '.أن تظهر وجهك بوضوح'),
                                                        _buildCondition(
                                                            '. بدون نظارات شمسية أو تغطية للوجه'),
                                                        _buildCondition(
                                                            '. بخلفية بسيطة وملابس مناسبة للعمل'),
                                                      ],
                                                    ),
                                                    SizedBox(height: 16),
                                                    TextButton.icon(
                                                      onPressed: imageDocuments[
                                                                  'additionalImage'] !=
                                                              null
                                                          ? () {
                                                              // if (imageDocuments['additionalImage']==null) {
                                                              //   ScaffoldMessenger.of(
                                                              //           context)
                                                              //       .showSnackBar(
                                                              //     SnackBar(
                                                              //       backgroundColor:
                                                              //           Color(
                                                              //               0xffBF3131),
                                                              //       content: Text(
                                                              //         'يجب رفع صورة شخصية قبل الخروج',
                                                              //         style: TextStyle(
                                                              //             color: Color(
                                                              //                 0xffEEEEEE)),
                                                              //       ),
                                                              //     ),
                                                              //   );
                                                              //   return;
                                                              // }
                                                              Navigator.of(
                                                                      dialogContext)
                                                                  .pop();
                                                              // Continue with OTP verification
                                                              _sendOTPAndShowBottomSheet(
                                                                  authProvider);
                                                            }
                                                          : null,
                                                      icon: Image.asset(
                                                        'assets/Icons/arrow.png',
                                                        color:imageDocuments[
                                                        'additionalImage'] !=
                                                            null?
                                                        Color(0xffE04836) : Color(0xffB1B1B1),
                                                        width: 14,
                                                        height: 14,
                                                      ),
                                                      label: Text(
                                                        'استمرار',
                                                        style: TextStyle(
                                                          color:imageDocuments[
                                                          'additionalImage'] !=
                                                              null?
                                                          Color(0xffE04836) : Color(0xffB1B1B1),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                // زر الإغلاق
                                                Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  child: IconButton(
                                                    icon: Image.asset(
                                                      'assets/Icons/carbon_close-outline.png',
                                                      color: Color(0xff636363),
                                                      width: 30,
                                                      height: 30,
                                                    ),
                                                    onPressed:  () {
                                                            Navigator.of(
                                                                    dialogContext)
                                                                .pop();
                                                            setState(() {
                                                              _isLoading =
                                                                  false;
                                                            });
                                                          }
                                                        ,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        backgroundColor: Color(0xffBF3131),
                                        content: Text(
                                          'حدث خطأ أثناء تحميل الصور',
                                          style: TextStyle(
                                              color: Color(0xffEEEEEE)),
                                        )),
                                  );
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              }
                            }
                          },
                    child: _isLoading
                        ? const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            _currentStep == 1
                                ? 'Create an account'.tr()
                                : 'Continue'.tr(),
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Colors.white),
                          ),
                  ),
                ),
              ),
              if (_currentStep > 0)
                TextButton(
                  onPressed: () => setState(() => _currentStep -= 1),
                  child: Text(
                    'Back'.tr(),
                    style: const TextStyle(color: MyColors.Darkest),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget stepOneContent() {
    return Column(
      children: [
        const SizedBox(height: 18),
        LabelText(text: 'Full Name'.tr()),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            enabledBorder: InputBorders.enabledBorder,
            errorBorder: InputBorders.errorBorder,
            focusedBorder: InputBorders.focusedBorder,
            focusedErrorBorder: InputBorders.focusedErrorBorder,
            hintText: 'Full Name'.tr(),
            alignLabelWithHint: true,
            hintStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: MyColors.LightDark),
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'الرجاء ادخال الاسم'.tr();
            }
            if (value.length < 3) {
              return 'يجب أن يكون الاسم مكونًا من 3 أحرف على الأقل'.tr();
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        LabelText(text: 'Phone Number'.tr()),
        const SizedBox(height: 8),
        TextFormField(
          controller: phoneController,
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
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'من فضلك أدخل رقم الهاتف';
            }
            if (value.length < 10) {
              return 'رقم الهاتف يجب أن يكون 10 أرقام على الأقل';
            }
            if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
              return 'رقم الهاتف يجب أن يحتوي على أرقام فقط';
            }
            if (!value.startsWith('09')) {
              return 'رقم الهاتف يجب أن يبدأ بـ 09';
            }
            return null;
          },
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10)
          ],
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
        ),
        const SizedBox(height: 16),
        LabelText(text: 'Password'.tr()),
        const SizedBox(height: 8),
        buildPasswordField(),
        const SizedBox(height: 16),
        LabelText(text: 'Password Confirmation'.tr()),
        const SizedBox(height: 8),
        buildConfirmPasswordField(),
        const SizedBox(height: 16),
        LabelText(text: 'رابط الدعوة ( إختياري )'.tr()),
        const SizedBox(height: 8),
        TextFormField(
          controller: _inviite_link,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            enabledBorder: InputBorders.enabledBorder,
            errorBorder: InputBorders.errorBorder,
            focusedBorder: InputBorders.focusedBorder,
            focusedErrorBorder: InputBorders.focusedErrorBorder,
            hintText: 'رابط الدعوة'.tr(),
            alignLabelWithHint: true,
            hintStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: MyColors.LightDark),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: _isAgree,
              onChanged: (bool? value) {
                setState(() {
                  _isAgree = value ?? false;
                });
              },
              activeColor: MyColors.MainBulma,
            ),
            Flexible(
              child: RichText(
                text: TextSpan(
                  text: 'By registering with us you agree to '.tr(),
                  style: const TextStyle(color: MyColors.Darkest),
                  children: [
                    TextSpan(
                      text: 'Terms and Conditions'.tr(),
                      style: const TextStyle(
                          color: MyColors.MainBulma,
                          decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const TermsAndConditionsScreen()));
                        },
                    ),
                    TextSpan(
                        text: ' and '.tr(),
                        style: const TextStyle(color: MyColors.Darkest)),
                    TextSpan(
                      text: 'privacy policy'.tr(),
                      style: const TextStyle(
                          color: MyColors.MainBulma,
                          decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => FaqScreen()));
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget stepTwoContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LabelText(text: 'Brief summary'.tr()),
          const SizedBox(height: 8),
          TextFormField(
            controller: _bioController,
            decoration: buildInputDecoration(
                    hintText:
                        'مثال : فني متخصص بخبرة طويلة في المجال، أقدّم خدماتي بدقة واحترافية عالية، وأسعى دائمًا لرضا العميل وجودة العمل. جاهز لتنفيذ الأعمال المطلوبة في الوقت المحدد وبأسعار مناسبة. ثقتكم هي سر نجاحي.')
                .copyWith(
              counterText: '${_bioController.text.length}/80',
              hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
              counterStyle: TextStyle(
                color:
                    _bioController.text.length < 80 ? Colors.red : Colors.green,
                fontSize: 12,
              ),
            ),
            maxLines: 4,
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            onChanged: (value) {
              setState(() {
                // The counter will update automatically through the decoration
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الرجاء إدخال نبذة مختصرة';
              }
              if (value.length < 80) {
                return 'يجب أن تكون النبذة المختصرة 80 حرف على الأقل';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          LabelText(text: 'إختيار تخصص'.tr()),
          const SizedBox(height: 8),
          !_isCategoriesFetched
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : DropdownButtonFormField<int>(
                  decoration:
                      buildInputDecoration(hintText: 'Specialization'.tr()),
                  items: categories!.response!
                      .map((e) => DropdownMenuItem<int>(
                          value: e.id, child: Text(e.title)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategoryId = value;
                      _isSubCategoriesFetched = false;
                      subCategories = null;
                    });
                    _fetchSubCategories(value!).then((response) {
                      setState(() {
                        subCategories = response;
                        _isSubCategoriesFetched = true;
                      });
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'الرجاء اختيار التخصص';
                    }
                    return null;
                  },
                ),
          const SizedBox(height: 8),
          LabelText(text: 'إضافة تخصص فرعي'.tr()),
          const SizedBox(height: 8),
          if (selectedCategoryId != null && _isSubCategoriesFetched)
            subCategories!.status == ResponseStatus.success
                ? DropdownButtonFormField<int>(
                    decoration:
                        buildInputDecoration(hintText: 'التخصص الفرعي'.tr()),
                    items: subCategories!.response!.map((e) {
                      bool isSelected = selectedCategoriesSubcategories[
                                  selectedCategoryId!] !=
                              null &&
                          selectedCategoriesSubcategories[selectedCategoryId!]!
                              .contains(e);
                      return DropdownMenuItem<int>(
                        value: e.id,
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(e.title), // Display subcategory title
                              if (isSelected)
                                const Icon(Icons.check, color: Colors.green),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        if (selectedCategoriesSubcategories[
                                selectedCategoryId!] ==
                            null) {
                          selectedCategoriesSubcategories[selectedCategoryId!] =
                              [
                            subCategories!.response!
                                .firstWhere((element) => element.id == value)
                          ];
                        } else {
                          selectedCategoriesSubcategories[selectedCategoryId!]!
                              .add(subCategories!.response!.firstWhere(
                                  (element) => element.id == value));
                        }
                      });
                    },
                  )
                : const Center(child: Text('Error fetching subcategories')),
          // if (selectedCategoryId != null && _isSubCategoriesFetched)
          //   subCategories!.status == ResponseStatus.success
          //       ? // Horizontal ListView to display subcategories
          //   Container(
          //       height:
          //       50, // Set height to control the size of the ListView
          //       child: ListView.builder(
          //         scrollDirection: Axis.horizontal, // Horizontal scroll
          //         itemCount: subCategories!.response!.length,
          //         itemBuilder: (context, index) {
          //           final e = subCategories!.response![index];
          //           bool isSelected = selectedCategoriesSubcategories[
          //           selectedCategoryId] !=
          //               null &&
          //               selectedCategoriesSubcategories[selectedCategoryId]!
          //                   .contains(e);
          //
          //           return Padding(
          //             padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //             child: GestureDetector(
          //               onTap: () {
          //                 setState(() {
          //                   if (selectedCategoriesSubcategories[
          //                   selectedCategoryId!] ==
          //                       null) {
          //                     selectedCategoriesSubcategories[
          //                     selectedCategoryId!] = [e];
          //                   } else {
          //                     if (isSelected) {
          //                       selectedCategoriesSubcategories[
          //                       selectedCategoryId!]!
          //                           .remove(e);
          //                     } else {
          //                       selectedCategoriesSubcategories[
          //                       selectedCategoryId!]!
          //                           .add(e);
          //                     }
          //                   }
          //                 });
          //               },
          //               child: Chip(
          //                 label: Text(e.title),
          //                 backgroundColor: Colors.black26,
          //                 // backgroundColor:
          //                 //     isSelected ? Colors.green : Colors.blueAccent,
          //                 labelStyle: TextStyle(color: Colors.white),
          //                 deleteIcon: isSelected
          //                     ? Icon(Icons.check, color: Colors.white)
          //                     : null,
          //               ),
          //             ),
          //           );
          //         },
          //       ))
          //       : const Center(child: Text('Error fetching subcategories')),

          const SizedBox(height: 16),
          //buildSelectedSubCategories(),
          //  const SizedBox(height: 16),
          LabelText(text: 'المدينة'),
          const SizedBox(height: 8),
          !_isCitiesFetched
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : DropdownButtonFormField<int>(
                  decoration: buildInputDecoration(hintText: 'المدينة'),
                  items: cities!.response!
                      .map((e) => DropdownMenuItem<int>(
                          value: e.id, child: Text(e.title ?? 'UNKNOWN')))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCityId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'الرجاء اختيار المدينة';
                    }
                    return null;
                  },
                ),
          const SizedBox(height: 16),
          LabelText(text: 'رقم جواز السفر'.tr()),
          const SizedBox(height: 8),
          buildPassportField(),
          const SizedBox(height: 16),
          LabelText(text: 'Proof of identity'.tr()),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(child: buildIdProofBox('صورة جواز السفر', 'idFront')),
              // const SizedBox(width: 16),
              // Expanded(child: buildIdProofBox('Back of ID photo', 'idBack')),
              const SizedBox(width: 16),
              Expanded(child: buildIdProofBox('صورة شخصية', 'idSelfie')),
            ],
          ),
          if (imageDocuments['idFront'] == null ||
              imageDocuments['idSelfie'] == null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'الرجاء رفع جميع الصور المطلوبة',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          // const SizedBox(height: 8),
          // buildIdProofBox('Shop photo', 'accountImage'),
        ],
      ),
    );
  }

  Widget phoneNumber() {
    String otp = "";
    return Column(
      children: [
        TextFormField(
          readOnly: _showAllFields,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: phoneController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'من فضلك أدخل رقم الهاتف';
            }
            if (value.length < 10) {
              return 'رقم الهاتف يجب أن يكون 10 أرقام على الأقل';
            }
            if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
              return 'رقم الهاتف يجب أن يحتوي على أرقام فقط';
            }
            if (!value.startsWith('09')) {
              return 'رقم الهاتف يجب أن يبدأ بـ 09';
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
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: _showAllFields ? Colors.grey : MyColors.Darkest),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10)
          ],
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          onChanged: (value) {
            setState(() {});
          },
        ),
        Visibility(visible: !_showAllFields, child: const SizedBox(height: 16)),
        if (phoneController.text.isNotEmpty &&
            phoneController.text.length >= 10 &&
            !_showOTPFields &&
            !_showAllFields)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: _showAllFields
                  ? null
                  : () async {
                      if (phoneController.text.isEmpty ||
                          phoneController.text.length < 10) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Color(0xffBF3131),
                            content: Text(
                              'الرجاء إدخال رقم هاتف صحيح',
                              style: TextStyle(color: Color(0xffEEEEEE)),
                            ),
                          ),
                        );
                        return;
                      }

                      setState(() {
                        _isLoading = true;
                      });

                      try {
                        final response =
                            await Provider.of<Auth>(context, listen: false)
                                .sendOTPNew(phoneNumber: phoneController.text);

                        if (response.status == ResponseStatus.success) {
                          setState(() {
                            _showOTPFields = true;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Color(0xffBF3131),
                              content: Text(
                                response.errorMessage ??
                                    'حدث خطأ أثناء إرسال رمز التحقق',
                                style: TextStyle(color: Color(0xffEEEEEE)),
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Color(0xffBF3131),
                            content: Text(
                              'حدث خطأ أثناء إرسال رمز التحقق',
                              style: TextStyle(color: Color(0xffEEEEEE)),
                            ),
                          ),
                        );
                      } finally {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
              child: Text(
                'تحقق من رقم الهاتف',
                style: TextStyle(
                  color: _showAllFields ? Colors.grey : MyColors.MainBulma,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget buildSelectedSubCategories() {
    List<Widget> selectedSubCategories = [];

    selectedCategoriesSubcategories.forEach((categoryId, subCategories) {
      for (var subCategory in subCategories) {
        selectedSubCategories.add(
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Chip(
              label: Text(subCategory.title),
              deleteIcon: const Icon(Icons.cancel),
              onDeleted: () {
                setState(() {
                  selectedCategoriesSubcategories[categoryId]!
                      .remove(subCategory);
                  if (selectedCategoriesSubcategories[categoryId]!.isEmpty) {
                    selectedCategoriesSubcategories.remove(categoryId);
                  }
                });
              },
            ),
          ),
        );
      }
    });

    return selectedSubCategories.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabelText(text: 'التخصصات الفرعية المٌختارة'.tr()),
              const SizedBox(height: 8),
              Container(
                height: 50, // Set a fixed height for the horizontal list
                child: ListView(
                  scrollDirection:
                      Axis.horizontal, // Enable horizontal scrolling
                  children: selectedSubCategories,
                ),
              ),
            ],
          )
        : const Center(child: Text('لم يتم اختيار أي تخصصات فرعية'));
  }

  // Function to extract subcategory IDs
  List<int> getSelectedSubCategoryIds() {
    List<int> selectedSubCategoryIds = [];
    selectedCategoriesSubcategories.forEach((categoryId, subCategories) {
      selectedSubCategoryIds
          .addAll(subCategories.map((subCategory) => subCategory.id));
    });
    return selectedSubCategoryIds;
  }

  Widget buildPassportField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'أدخل رقم جواز السفر'.tr();
        }
        if (value.length < 8) {
          return 'يجب أن يكون جواز السفر مكونًا من 8 خانات على الأقل'.tr();
        }
        if (!RegExp(r'^[A-Za-z0-9]+$').hasMatch(value)) {
          return 'يجب أن يحتوي جواز السفر على أحرف وأرقام فقط'.tr();
        }
        return null;
      },
      maxLines: 1,
      controller: _passportController,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        enabledBorder: InputBorders.enabledBorder,
        errorBorder: InputBorders.errorBorder,
        focusedBorder: InputBorders.focusedBorder,
        focusedErrorBorder: InputBorders.focusedErrorBorder,
        hintText: "جواز السفر".tr(),
        alignLabelWithHint: true,
        hintStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: MyColors.LightDark),
      ),
      style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w400, color: MyColors.Darkest),
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
          return 'الرجاء إدخال كلمة المرور';
        }
        if (value.length < 8) {
          return 'كلمة المرور يجب أن تكون 8 خانات على الأقل';
        }
        /*  if (!RegExp(r'[A-Z]').hasMatch(value)) {
          return 'يجب أن تحتوي كلمة المرور على أحرف كبيرة';
        }*/
        // if (!RegExp(r'[a-z]').hasMatch(value)) {
        //   return 'يجب أن تحتوي كلمة المرور على أحرف صغيرة';
        // }
        // if (!RegExp(r'[0-9]').hasMatch(value)) {
        //   return 'يجب أن تحتوي كلمة المرور على رقم';
        // }
        // if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
        //   return 'password_must_contain_special_character'.tr();
        // }
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

  Widget buildConfirmPasswordField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء إدخال تأكيد كلمة المرور';
        }
        if (value != _passwordController.text) {
          return 'كلمات المرور لا تتطابق';
        }
        return null;
      },
      maxLines: 1,
      controller: _confirmPasswordController,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        enabledBorder: InputBorders.enabledBorder,
        errorBorder: InputBorders.errorBorder,
        focusedBorder: InputBorders.focusedBorder,
        focusedErrorBorder: InputBorders.focusedErrorBorder,
        hintText: 'Password Confirmation'.tr(),
        alignLabelWithHint: true,
        hintStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: MyColors.LightDark),
        suffixIcon: IconButton(
          icon: Icon(
            _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: MyColors.LightDark,
          ),
          onPressed: () {
            setState(() {
              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
            });
          },
        ),
      ),
      style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w400, color: MyColors.Darkest),
      keyboardType: TextInputType.text,
      obscureText: !_isConfirmPasswordVisible,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
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

  Future pickImage(String type, {bool fromCamera = false}) async {
    try {
      final XFile? _image = await ImagePicker().pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      );
      if (_image == null) return;
      setState(() {
        imageDocuments[type] = File(_image.path);
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void startResendTimer() {
    setState(() {
      _resendTimer = 90; // 1:30 in seconds
    });
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendTimer > 0) {
          _resendTimer--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  // Add this new method to handle OTP sending and bottom sheet display
  Future<void> _sendOTPAndShowBottomSheet(Auth authProvider) async {
    try {
      final response = await Provider.of<Auth>(context, listen: false)
          .sendOTPNew(phoneNumber: phoneController.text);

      if (response.status == ResponseStatus.success) {
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          builder: (BuildContext bottomSheetContext) {
            return _buildOTPBottomSheetContent(
              authProvider,
              bottomSheetContext,
              context,
              onOTPVerified: () async {
                setState(() {
                  _isLoading = true;
                });
                ResponseHandler response = await authProvider.signUpAsProvider(
                  fullName: _nameController.text,
                  phoneNumber: phoneController.text,
                  password: _passwordController.text,
                  passwordConfirmation: _confirmPasswordController.text,
                  about: _bioController.text,
                  categoryId: selectedCategoryId!,
                  cityId: selectedCityId!,
                  subCategoryIds: getSelectedSubCategoryIds(),
                  passport: _passportController.text,
                  idFront: imageDocuments['idFront']!,
                  idSelfie: imageDocuments['idSelfie']!,
                  image: imageDocuments['additionalImage']!,
                  invite_link: _inviite_link.text,
                );
                setState(() {
                  _isLoading = false;
                });
                if (response.status == ResponseStatus.success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "تم إنشاء الحساب بنجاح".tr(),
                        style: TextStyle(color: Color(0xffEEEEEE)),
                      ),
                    ),
                  );
                  authProvider.isLoginScreen = true;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => FreeDaysScreen()
                    ),
                    (route) => false,
                  );
                  // Navigator.of(context).pushAndRemoveUntil(
                  //   MaterialPageRoute(
                  //     builder: (context) => context.read<Auth>().isProvider
                  //         ? AuthScreen()
                  //         : AuthScreen(),
                  //   ),
                  //   (route) => false,
                  // );
                } else if (response.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Color(0xffBF3131),
                      content: Text(
                        response.errorMessage!.tr(),
                        style: TextStyle(color: Color(0xffEEEEEE)),
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Color(0xffBF3131),
                      content: Text(
                        'حاول مرة أخرى'.tr(),
                        style: TextStyle(color: Color(0xffEEEEEE)),
                      ),
                    ),
                  );
                }
              },
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Color(0xffBF3131),
            content: Text(
              response.errorMessage ?? 'حدث خطأ أثناء إرسال رمز التحقق',
              style: TextStyle(color: Color(0xffEEEEEE)),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color(0xffBF3131),
          content: Text(
            'حدث خطأ أثناء إرسال رمز التحقق',
            style: TextStyle(color: Color(0xffEEEEEE)),
          ),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // دالة مساعدة لبناء شرط مع أيقونة صح
  Widget _buildCondition(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(color: Color(0xff959595), fontSize: 12),
          ),
          SizedBox(width: 6),
          Icon(Icons.check_circle, color: Color(0xff959595), size: 12),
        ],
      ),
    );
  }
}
