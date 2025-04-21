import 'package:ajeer/constants/my_colors.dart';
import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/controllers/common/notifications_provider.dart';
import 'package:ajeer/models/customer/provider/notification_model.dart';
import 'package:ajeer/ui/widgets/common/error_widget.dart';
import 'package:ajeer/ui/widgets/common/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../widgets/appbar_title.dart';
import '../widgets/sized_box.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  ResponseHandler<List<UserNotification>>? notifications;
  bool _isFetched = false;

  @override
  void didChangeDependencies() {
    if (!_isFetched) {
      Provider.of<NotificationsProvider>(context, listen: false).fetchNotifications().then((value) {
        setState(() {
          notifications = value;
          _isFetched = true;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarTitle(title: 'الإشعارات'),
      backgroundColor: Colors.white,
      body: !_isFetched
          ? loaderWidget(context)
          : notifications!.status == ResponseStatus.error
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    errorWidget(context),
                    Builder(
                      builder: (context) => MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          color: MyColors.MainBulma,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                            child: Text(
                              'Try Again'.tr(),
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _isFetched = false;
                              didChangeDependencies();
                            });
                          }),
                    )
                  ],
                )
              : (notifications!.response == null || notifications!.response!.isEmpty)
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                                'assets/Icons/NotificationIcon.png',
                                height: 180,
                                width: 180),
                            const SizedBox(height: 16),
                            Text(
                              "لا توجد إشعارات الآن، الإشعارات ستكون هنا !",
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: MyColors.Darkest),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Divider(
                            color: Colors.grey.withOpacity(0.1),
                            thickness: 10,
                          ),
                          SizedBoxedH16,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(), // Disable scrolling for inner ListView
                              itemCount: notifications!.response!.length, // Specify the item count here
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    NotificationTile(
                                      notifications!.response![index],
                                    ),
                                    Divider(
                                      color: Colors.grey.withOpacity(0.1),
                                      thickness: 1,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  UserNotification notification;

  NotificationTile(this.notification, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        notification.data!.title!,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
      ),
      subtitle: Text(
        notification.data!.body!,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w100),
      ),
      leading: const Icon(Icons.check_circle, color: Colors.green),
      trailing: Text(
        timeago.format(notification.createdAt!),
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w100),
      ),
      onTap: () {
        // Handle notification tap
      },
    );
  }
}
