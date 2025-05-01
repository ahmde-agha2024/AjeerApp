import 'package:ajeer/ui/widgets/common/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/my_colors.dart';
import '../../../controllers/common/address_provider.dart';
import '../../widgets/sized_box.dart';
import 'add_address_screen.dart';

class UserAddressesScreen extends StatefulWidget {
  @override
  State<UserAddressesScreen> createState() => _UserAddressesScreenState();
}

class _UserAddressesScreenState extends State<UserAddressesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<AddressProvider>(context, listen: false).fetchAddresses());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'عناوين المستخدم',
          style: TextStyle(
            color: MyColors.Darkest,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Consumer<AddressProvider>(
        builder: (context, addressProvider, child) {
          if (!addressProvider.isDataLoaded) {
            return loaderWidget(context);
          }


          if (addressProvider.addresses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                      'assets/Icons/noaddressIcon.png',
                      height: 180,
                      width: 180),
                  const SizedBox(height: 16),
                  const Text(
                    'لا توجد عناوين حالياً !',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: MyColors.Darkest),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Divider(
                color: Colors.grey.withOpacity(0.1),
                thickness: 10,
              ),
              SizedBoxedH16,
              Expanded(
                child: ListView.builder(
                  itemCount: addressProvider.addresses.length,
                  itemBuilder: (context, index) {
                    final address = addressProvider.addresses[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Card(
                        color: MyColors.MainGoku,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(address.title!),
                            subtitle: Text(address.address!),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => AddAddressScreen(
                                          existingAddress: address),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => addressProvider
                                      .deleteAddress(address.id!),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.MainPrimary,
        onPressed: () async {
          await Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) => AddAddressScreen(),
                ),
              )
              .then((_) => Provider.of<AddressProvider>(context, listen: false)
                  .fetchAddresses());
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        tooltip: 'إضافة عنوان جديد',
      ),
    );
  }
}
