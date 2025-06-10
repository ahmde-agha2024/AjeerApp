import 'dart:io';
import 'dart:math';

import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/controllers/common/address_provider.dart';
import 'package:ajeer/controllers/customer/customer_orders_provider.dart';
import 'package:ajeer/controllers/customer/home/customer_home_page_provider.dart';
import 'package:ajeer/models/common/category_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../widgets/appbar_title.dart';
import '../widgets/button_styles.dart';
import '../widgets/input_decoration.dart';
import '../widgets/input_label.dart';
import 'home_client/add_address_screen.dart';

class ServiceRequestScreen extends StatefulWidget {
  ServiceRequestScreen({this.provider_id, super.key});

  var provider_id;

  @override
  State<ServiceRequestScreen> createState() => _ServiceRequestScreenState();
}

class _ServiceRequestScreenState extends State<ServiceRequestScreen> {
  final _offerNameController = TextEditingController();
  final _offerPriceController = TextEditingController();
  final _offerStartController = TextEditingController();
  final _offerTimeController = TextEditingController();
  final _offerDescriptionController = TextEditingController();
  List<File> serviceImages = [];
  bool isDataFetched = false;
  bool isAddingService = false;
  final _formKey = GlobalKey<FormState>();
  bool _isCategoriesFetched = false;
  bool _isSubCategoriesFetched = false;
  bool _isAddressFetched = false;
  ResponseHandler<List<Category>>? categories;
  ResponseHandler<List<Category>?>? subCategories;
  int? selectedCategoryId;
  int? selectedSubCategoryId;
  int? selectedAddressId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isCategoriesFetched) {
      Provider.of<CustomerHomeProvider>(context, listen: false)
          .fetchCategories()
          .then((response) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            setState(() {
              categories = response;
              _isCategoriesFetched = true;
            });
          });
        });
      });
    }

    if (!_isAddressFetched) {
      Provider.of<AddressProvider>(context, listen: false)
          .fetchAddresses()
          .then((_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            _isAddressFetched = true;
          });
        });
      });
    }
  }

  Future<ResponseHandler<List<Category>>> _fetchSubCategories(
      int categoryId) async {
    return await Provider.of<CustomerOrdersProvider>(context, listen: false)
        .fetchSubCategories(categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            AppbarTitle(
              title: 'إضافة مشروع جديد', // TODO TRANSLATE THIS
            ),
            Divider(
              color: Colors.grey.withOpacity(0.1),
              thickness: 10,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView(
                  children: [
                    LabelText(text: 'اسم المشروع'.tr()),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _offerNameController,
                      decoration:
                          buildInputDecoration(hintText: 'اسم المشروع'.tr()),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'يجب إدخال اسم المشروع'.tr(); // TODO TRANSLATE
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    LabelText(text: 'التصنيف'.tr()),
                    const SizedBox(height: 8),
                    !_isCategoriesFetched
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : DropdownButtonFormField<int>(
                            value: selectedCategoryId,
                            decoration:
                                buildInputDecoration(hintText: 'التصنيف'.tr()),
                            items: categories!.response!
                                .map((e) => DropdownMenuItem<int>(
                                    value: e.id, child: Text(e.title)))
                                .toList(),
                            validator: (value) {
                              if (value == null) {
                                return 'يجب اختيار التصنيف'
                                    .tr(); // TODO TRANSLATE
                              }
                              return null;
                            },
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
                          ),
                    const SizedBox(height: 8),
                    LabelText(text: 'التصنيف الفرعي'.tr()), // todo translate
                    const SizedBox(height: 8),
                    selectedCategoryId == null
                        ? const SizedBox(
                            height: 0,
                          )
                        : !_isSubCategoriesFetched
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : subCategories!.status == ResponseStatus.success
                                ? DropdownButtonFormField<int>(
                                    value: selectedSubCategoryId,
                                    decoration: buildInputDecoration(
                                        hintText: 'التصنيف الفرعي'.tr()),
                                    items: subCategories!.response!
                                        .map((e) => DropdownMenuItem<int>(
                                            value: e.id, child: Text(e.title)))
                                        .toList(),
                                    validator: (value) {
                                      if (value == null) {
                                        return 'يجب اختيار التصنيف الفرعي'
                                            .tr(); // TODO TRANSLATE
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        selectedSubCategoryId = value;
                                      });
                                    },
                                  )
                                : Text('ERRORRRRRR'),
                    const SizedBox(height: 16),
                    LabelText(text: 'قيمة المشروع'.tr()),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _offerPriceController,
                      decoration:
                          buildInputDecoration(hintText: 'قيمة المشروع'.tr()),
                      keyboardType: TextInputType.number,
                      readOnly: false,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'يجب إدخال قيمة المشروع'
                              .tr(); // TODO TRANSLATE
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    LabelText(text: 'تاريخ المشروع'.tr()),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _offerStartController,
                      decoration: buildInputDecoration(
                          hintText: 'بداية المشروع'.tr(),
                          prefixIcon:
                              const Icon(Icons.calendar_month_outlined)),
                      readOnly: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'يجب إدخال تاريخ بداية المشروع'
                              .tr(); // TODO TRANSLATE
                        }
                        return null;
                      },
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );

                        if (pickedDate != null) {
                          _offerStartController.text =
                              DateFormat('EE, dd MMM. yyyy').format(pickedDate);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    LabelText(text: 'توقيت المشروع'.tr()),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _offerTimeController,
                      decoration: buildInputDecoration(
                          hintText: 'توقيت تقديم الخدمة'.tr(),
                          prefixIcon: const Icon(Icons.watch_later_rounded)),
                      readOnly: true,
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (pickedTime != null) {
                          _offerTimeController.text =
                              pickedTime.format(context);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    LabelText(text: 'وصف المشكلة'.tr()),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _offerDescriptionController,
                      decoration:
                          buildInputDecoration(hintText: 'وصف المشكلة'.tr()),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'يجب إدخال وصف المشكلة'.tr(); // TODO TRANSLATE
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    LabelText(text: 'العنوان'.tr()), // TODO TRANSLATE
                    const SizedBox(height: 8),
                    !_isAddressFetched
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : DropdownButtonFormField<int>(
                            value: selectedAddressId,
                            decoration:
                                buildInputDecoration(hintText: 'العنوان'.tr()),
                            validator: (value) {
                              if (value == null) {
                                return 'يجب اختيار العنوان'
                                    .tr(); // TODO TRANSLATE
                              }
                              return null;
                            },
                            items: Provider.of<AddressProvider>(context,
                                    listen: false)
                                .addresses!
                                .map((e) => DropdownMenuItem<int>(
                                    value: e.id,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Text('${e.title!} - ${e.address!}'),
                                          const Divider(
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    )))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedAddressId = value;

                              });
                            },
                          ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AddAddressScreen()));
                          },
                          child: Text(
                            "قم بإضافة عنوان",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          )),
                    ),
                    const SizedBox(height: 16),
                    LabelText(text: 'صور المشكلة'.tr()),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () {
                        pickImage();
                      },
                      child: Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: Card(
                            // TODO: EDIT STYLE
                            elevation: 0,
                            margin: EdgeInsets.zero,
                            clipBehavior: Clip.antiAlias,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 32.0, horizontal: 16.0),
                              child: (serviceImages.isEmpty)
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.upload),
                                        const SizedBox(height: 12),
                                        Text(
                                          'Attach your service Icons'.tr(),
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      ],
                                    )
                                  : SizedBox(
                                      height: 150,
                                      child: GridView.builder(
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4,
                                          childAspectRatio: 1,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10,
                                        ),
                                        itemCount: serviceImages.length,
                                        itemBuilder: (context, index) {
                                          if (index < serviceImages.length) {
                                            // for local images
                                            return Stack(
                                              children: [
                                                SizedBox(
                                                  height: 200,
                                                  width: 200,
                                                  child: InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return Dialog(
                                                            child: Image.file(
                                                                serviceImages[
                                                                        index]
                                                                    .absolute),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child: Image.file(
                                                        serviceImages[index]
                                                            .absolute,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        serviceImages
                                                            .removeAt(index);
                                                      });
                                                    },
                                                    child: const CircleAvatar(
                                                      backgroundColor:
                                                          Colors.red,
                                                      radius: 14,
                                                      child: Icon(
                                                        Icons.close,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else {
                                            int remoteImageIndex =
                                                index - serviceImages.length;
                                            return CachedNetworkImage(
                                              imageUrl:
                                                  'https://via.placeholder.com/150',
                                              placeholder: (context, url) =>
                                                  const CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: TextButton(
                        style: flatButtonPrimaryStyle,
                        onPressed: isAddingService
                            ? null
                            : () async {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                } else if (serviceImages.isEmpty) {
                                  // show toast
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text(
                                        'يجب إضافة صورة واحدة على الأقل'), // TODO: TRANSLATE THIS
                                  ));
                                  return;
                                } else if (selectedSubCategoryId == null) {
                                  // show toast
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text(
                                        'يجب اختيار التصنيف الفرعي'), // TODO: TRANSLATE THIS
                                  ));
                                  return;
                                }

                                // form valid and images are added
                                setState(() {
                                  isAddingService = true;
                                });
                                print(selectedAddressId);
                                ResponseHandler handledResponse = await Provider
                                        .of<CustomerOrdersProvider>(context,
                                            listen: false)
                                    .requestNewService(
                                        status: "NEW",
                                        title: _offerNameController.text,
                                        content:
                                            _offerDescriptionController.text,
                                        price: double.parse(
                                            _offerPriceController.text),
                                        categoryId: selectedCategoryId!,
                                        date: _offerStartController.text,
                                        time: _offerTimeController.text,
                                        subCategoryId: selectedSubCategoryId!,
                                        addressId: selectedAddressId!,

                                        serviceImages: serviceImages,
                                        provider_id: widget.provider_id != null
                                            ? widget.provider_id
                                            : null);
                                setState(() {
                                  isAddingService = false;
                                });
                                if (handledResponse.status ==
                                    ResponseStatus.success) {
                                  // show toast
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('تم إضافة المشروع بنجاح'),
                                      behavior: SnackBarBehavior.floating,

                                    ),
                                  );
                                  _showAlertDialog(context);
                                  Navigator.of(context).pop();
                                } else if (handledResponse.errorMessage !=
                                    null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        content: Text(handledResponse
                                            .errorMessage!
                                            .tr())),
                                  );
                                } else {
                                  // show toast
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text(
                                        'Error Occurred'), // TODO: TRANSLATE THIS
                                  ));
                                }
                              },
                        child: isAddingService
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'إضافة المشروع'.tr(),
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
      ),
    );
  }

  Future pickImage() async {
    try {
      final List<XFile> _images = await ImagePicker().pickMultiImage();

      if (_images == null) return;
      setState(() {
        serviceImages = _images.map((e) => File(e.path)).toList();
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
}

// Function to show the AlertDialog
void _showAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Center(child: Text('تحذير')), // Title of the dialog
        content: Text(
          'لضمان حقوقكم وحمايتها، يُنصح بعدم التعامل خارج التطبيق. نحن هنا لتوفير بيئة آمنة وموثوقة لكم.',
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('موافق'), // Button text
          ),
        ],
      );
    },
  );
}
