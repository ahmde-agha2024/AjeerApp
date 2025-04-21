import 'package:ajeer/constants/my_colors.dart';
import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/controllers/common/auth_provider.dart';
import 'package:ajeer/controllers/common/chat_provider.dart';
import 'package:ajeer/models/common/chat_model.dart';
import 'package:ajeer/ui/screens/single_chat_screen.dart';
import 'package:ajeer/ui/widgets/common/error_widget.dart';
import 'package:ajeer/ui/widgets/common/loader_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../widgets/appbar_title.dart';
import '../widgets/sized_box.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  bool _isDataFetched = false;
  ResponseHandler<List<ChatHead>>? _chatHeadsResponse;

  @override
  void didChangeDependencies() {
    if (!_isDataFetched) {
      _chatHeadsResponse = ResponseHandler(status: ResponseStatus.error);
      Provider.of<Chat>(context, listen: false).fetchChatHeads().then((response) {
        _chatHeadsResponse = response;

        setState(() {
          _isDataFetched = true;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarTitle(title: 'المحادثات'),
      backgroundColor: Colors.white,
      body: !_isDataFetched
          ? loaderWidget(context)
          : _chatHeadsResponse!.status == ResponseStatus.error
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
                              _isDataFetched = false;
                              didChangeDependencies();
                            });
                          }),
                    )
                  ],
                )
              : _chatHeadsResponse!.response!.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                              'assets/Icons/chatappIcon.png',
                              height: 180,
                              width: 180),
                          const SizedBox(height: 16),
                          Text(

                            'لا توجد رسائل , ستظهر الرسائل هنا !',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: MyColors.Darkest),
                          ),
                        ],
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
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _chatHeadsResponse!.response!.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        context.read<Auth>().isProvider ? _chatHeadsResponse!.response![index].customer!.name! : _chatHeadsResponse!.response![index].provider!.name,
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                                      ),
                                      subtitle: Text(
                                        _chatHeadsResponse!.response![index].lastMessage!.message!,
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w100),
                                      ),
                                      leading: Stack(
                                        children: [
                                          ClipOval(

                                            child: CachedNetworkImage(
                                              imageUrl: context.read<Auth>().isProvider ? _chatHeadsResponse!.response![index].customer!.image! : _chatHeadsResponse!.response![index].provider!.image!,
                                              placeholder: (context, url) => const CircularProgressIndicator(),
                                              errorWidget: (context, url, error) => const Icon(Icons.error),
                                           fit: BoxFit.cover,
                                              width: 50,height: 50,

                                            ),
                                          ),
                                          const Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: CircleAvatar(
                                              radius: 5,
                                              backgroundColor: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: _chatHeadsResponse!.response![index].unreadCount! > 0 != true
                                          ? const SizedBox(height: 0)
                                          : CircleAvatar(
                                              radius: 10,
                                              backgroundColor: Colors.red,
                                              child: Center(
                                                child: Text(
                                                  _chatHeadsResponse!.response![index].unreadCount.toString(),
                                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                                ),
                                              ),
                                            ),
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => SingleChatScreen(
                                              chatHead: _chatHeadsResponse!.response![index],
                                            ),
                                          ),
                                        );
                                      },
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
