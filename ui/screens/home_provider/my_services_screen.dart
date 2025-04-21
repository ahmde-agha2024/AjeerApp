import 'package:flutter/material.dart';

import '../../widgets/appbar_title.dart';
import '../../widgets/sized_box.dart';
import 'new_service_screen.dart';

class MyServicesScreen extends StatelessWidget {
  const MyServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarTitle(
        title: 'خدماتي',
        haveAddBtn: true,
        addBtnOnPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NewServiceScreen()));
        },
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Divider(
            color: Colors.grey.withOpacity(0.1),
            thickness: 10,
          ),
          SizedBoxedH32,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add padding around the grid
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  crossAxisSpacing: 10, // Horizontal space between items
                  mainAxisSpacing: 10, // Vertical space between items
                  childAspectRatio: 0.9, // Aspect ratio for grid items
                ),
                itemCount: 6, // Total number of items in the grid (adjust as needed)
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(onTap: () {}, child: const ServiceCard()); // Build each grid item
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10.0)),
                child: Image.network(
                  'https://unsplash.com/photos/h4i9G-de7Po/download?force=true&w=1920',
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(
                    'صيانة',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'معاينة التكييف',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 4),
                        Text('4.8', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.shopping_bag, size: 16),
                    SizedBox(width: 4),
                    Text('تبدأ من 20 دينار', style: TextStyle(fontSize: 12)),
                    Spacer(),
                    Icon(Icons.money, size: 16, color: Colors.red),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
