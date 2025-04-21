import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/controllers/service_provider/provider_offers_provider.dart';
import 'package:ajeer/models/customer/service_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../widgets/appbar_title.dart';
import '../../widgets/button_styles.dart';
import '../../widgets/input_decoration.dart';
import '../../widgets/input_label.dart';
import '../../widgets/sized_box.dart';

class RequestOfferProviderScreen extends StatefulWidget {
  Service serviceDetails;

  RequestOfferProviderScreen({super.key, required this.serviceDetails});

  @override
  State<RequestOfferProviderScreen> createState() =>
      _RequestOfferProviderScreenState();
}

class _RequestOfferProviderScreenState
    extends State<RequestOfferProviderScreen> {
  final _contentMessageController = TextEditingController();

  final _amountController = TextEditingController();

  final _offerDateController = TextEditingController();
  final _offerTimeController = TextEditingController();

  bool isLoading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarTitle(title: 'تقدم للعرض'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Divider(
                color: Colors.grey.withOpacity(0.1),
                thickness: 10,
              ),
              SizedBoxedH16,
              LabelText(text: 'الوصف'.tr()),
              const SizedBox(height: 8),
              TextFormField(
                controller: _contentMessageController,
                decoration: buildInputDecoration(hintText: 'الوصف'.tr()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال الوصف';
                  }
                  return null;
                },
              ),
              SizedBoxedH16,
              LabelText(text: 'قيمة العرض'.tr()),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: buildInputDecoration(hintText: 'قيمة العرض'.tr()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال قيمة العرض';
                  }
                  return null;
                },
              ),
              SizedBoxedH16,
              LabelText(text: 'تاريخ تقديم الخدمة'.tr()),
              const SizedBox(height: 8),
              TextFormField(
                controller: _offerDateController,
                decoration: buildInputDecoration(hintText: 'تاريخ تقديم الخدمة'.tr(), prefixIcon: const Icon(Icons.calendar_month_outlined)),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(Duration(days: 1)),
                    firstDate: DateTime.now().add(Duration(days: 1)),
                    lastDate: DateTime(2101),
                  );

                  if (pickedDate != null) {
                    _offerDateController.text = DateFormat('EE, dd MMM. yyyy').format(pickedDate);
                  }
                },
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'الرجاء إدخال تاريخ تقديم الخدمة';
                //   }
                //   return null;
                // },
              ),
              SizedBoxedH16,
              LabelText(text: 'توقيت تقديم الخدمة'.tr()),
              const SizedBox(height: 8),
              TextFormField(
                controller: _offerTimeController,
                decoration: buildInputDecoration(hintText: 'توقيت تقديم الخدمة'.tr(), prefixIcon: const Icon(Icons.watch_later_rounded)),
                readOnly: true,
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (pickedTime != null) {
                    _offerTimeController.text = pickedTime.format(context);
                  }
                },
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'الرجاء إدخال توقيت تقديم الخدمة';
                //   }
                //   return null;
                // },
              ),
              const SizedBox(height: 16),
              SizedBoxedH16,
              SizedBox(
                width: double.infinity,
                height: 64,
                child: TextButton(
                  style: flatButtonPrimaryStyle,
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState?.validate() != true) {
                            return;
                          }
                          setState(() {
                            isLoading = true;
                          });
                          ResponseHandler response =
                              await Provider.of<ProviderOffersProvider>(context,
                                      listen: false)
                                  .createOfferForServiceRequest(
                            serviceId: widget.serviceDetails.id!,
                            price: double.parse(_amountController.text),
                            content: _contentMessageController.text,
                                date: _offerDateController.text,
                                time: DateFormat('HH:mm').parse(_offerTimeController.text),
                          );

                          if (response.status == ResponseStatus.success) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('تم تقديم العرض بنجاح')));
                          } else if (response.errorMessage != null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(response.errorMessage!)));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('ليس لديك عروض حاليا')));
                          }
                          setState(() {
                            isLoading = false;
                          });
                        },
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          'تقديم للعرض'.tr(),
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Colors.white),
                        ),
                ),
              ),
              SizedBoxedH16,
            ],
          ),
        ),
      ),
    );
  }
}
