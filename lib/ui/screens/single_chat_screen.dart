import 'dart:async';

import 'package:ajeer/constants/my_colors.dart';
import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/controllers/common/auth_provider.dart';
import 'package:ajeer/controllers/common/chat_provider.dart';
import 'package:ajeer/models/common/chat_model.dart';
import 'package:ajeer/models/customer/service_model.dart';
import 'package:ajeer/ui/widgets/common/error_widget.dart';
import 'package:ajeer/ui/widgets/common/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../models/common/chatModelNew.dart';

class SingleChatScreen extends StatefulWidget {
  ChatHead? chatHead;
    Service? service;

  SingleChatScreen({super.key, this.chatHead, this.service});

  @override
  State<SingleChatScreen> createState() => _SingleChatScreenState();
}

class _SingleChatScreenState extends State<SingleChatScreen> {
  bool _isDataFetched = false;
  ResponseHandler<SingleChatNew>? _singleChatResponse =
      ResponseHandler(status: ResponseStatus.error);
  bool amIProvider = false;
  late bool isClient;
  bool _isSendingMessage = false;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _refreshTimer;
  bool isFirstTime = false;

  @override
  void initState() {
    amIProvider = context.read<Auth>().isProvider;
    isClient = Provider.of<Auth>(context, listen: false).isClient;

    super.initState();
    _refreshTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!isFirstTime) {
        _refreshChat();
      }
    });
  }

  Future _refreshChat() async {
    Provider.of<Chat>(context, listen: false)
        .fetchSingleChat(
            chatId: widget.chatHead?.id, serviceId: widget.service?.id)
        .then((response) {
      if (response.status == ResponseStatus.success) {
        if ((_singleChatResponse!.status == ResponseStatus.notFound &&
                response.status == ResponseStatus.success) ||
            _singleChatResponse!.response!.messages!.length <
                response.response!.messages!.length) {
          setState(() {
            isFirstTime = false;
            _singleChatResponse = response;
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (!_isDataFetched) {
      Provider.of<Chat>(context, listen: false)
          .fetchSingleChat(
              chatId: widget.chatHead?.id, serviceId: widget.service?.id)
          .then((response) {
        if (response.status == ResponseStatus.notFound) {
          isFirstTime = true;
        }
        _singleChatResponse = response;

        setState(() {
          _isDataFetched = true;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      });
    }

    super.didChangeDependencies();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: !_isDataFetched
          ? loaderWidget(context)
          : !isFirstTime && _singleChatResponse!.status == ResponseStatus.error
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
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 12),
                            child: Text(
                              'Try Again'.tr(), // TODO TRANSLATE
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
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
              : Column(
                  children: [
                    Expanded(
                      child: isFirstTime
                          ? const SizedBox(height: 0)
                          : ListView.builder(
                              controller: _scrollController,
                              itemCount: _singleChatResponse!
                                  .response?.messages?.length,
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final message = _singleChatResponse!
                                    .response?.messages?[index];
                                final isProviderSender =
                                    message?.sender == 'provider';
                                final isSentMessage =
                                    (amIProvider && isProviderSender) ||
                                        (!amIProvider && !isProviderSender);
                                final formattedTime = DateFormat('hh:mm a')
                                    .format(message!.createdAt!
                                        .add(const Duration(hours: 2)));
                                return isSentMessage
                                    ? _buildSentMessage(
                                        message: message.message!,
                                        time: formattedTime)
                                    : _buildReceivedMessage(
                                        message: message.message!,
                                        time: formattedTime);
                              },
                            ),
                    ),
                    _buildMessageInputField(),
                  ],
                ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    bool isProvider = context.read<Auth>().isProvider;
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(isProvider
                ? widget.chatHead!.customer!.image!
                : widget.chatHead!.provider!.image!),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  isProvider
                      ? "${widget.chatHead!.customer!.name!} | (${widget.chatHead!.customer!.phone!})"
                      : "${widget.chatHead!.provider!.name!} | ${widget.chatHead!.provider!.phone!}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              Text(
                (isProvider
                    ? (widget.chatHead?.customer?.status == 1
                        ? 'نشط الآن'
                        : 'غير نشط الان')
                    : (widget.chatHead?.provider?.status == 1
                        ? 'نشط الآن'
                        : 'غير نشط الان')),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
      // actions: [
      //   IconButton(
      //     icon: const Icon(Icons.more_vert),
      //     onPressed: () {},
      //   ),
      // ],
    );
  }

  Widget _buildDateLabel(String date) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          date,
          style:
              const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSentMessage({required String message, required String time}) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Text(
                time,
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceivedMessage(
      {required String message, required String time}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(), // هذا يضمن أن الرسالة تبدأ بعد منتصف الشاشة
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(message),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    time,
                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8), // مساحة فارغة بين الصورة والنص
            CircleAvatar(
              backgroundImage: NetworkImage(amIProvider
                  ? widget.chatHead!.customer!.image!
                  : widget.chatHead!.provider!.image!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSentVoiceMessage({required String time}) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.play_arrow, color: Colors.white),
                SizedBox(width: 8),
                Text('00:16', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Text(
              time,
              style: const TextStyle(color: Colors.grey, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInputField() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _isSendingMessage || _messageController.text.isEmpty
                ? null
                : () async {
                    if (_messageController.text.isEmpty) {
                      return;
                    }
                    String message = _messageController.text;
                    FocusScope.of(context).unfocus();
                    setState(() {
                      _messageController.clear();
                      _isSendingMessage = true;
                    });
                    if (!isClient) {

                      ResponseHandler response =
                          await Provider.of<Chat>(context, listen: false)
                              .sendChatMessage(
                                  cid: widget.chatHead!.customer!.id.toString(),
                                  serviceId: widget.chatHead!.service?.id ,
                                  message: message);

                      if (response.status == ResponseStatus.success) {
                        await _refreshChat();
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _scrollToBottom();
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Error Occurred')),
                        );
                        setState(() {
                          _messageController.text = message;
                        });
                      }
                    } else{
                      ResponseHandler response =
                      await Provider.of<Chat>(context, listen: false)
                          .sendChatMessage(
                          cid: widget.chatHead!.provider!.id.toString(),
                          // serviceId: widget.chatHead!.service?.id ??
                          //     widget.service!.id!,
                          message: message);

                      if (response.status == ResponseStatus.success) {
                        await _refreshChat();
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _scrollToBottom();
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Error Occurred')),
                        );
                        setState(() {
                          _messageController.text = message;
                        });
                      }
                    }

                    setState(() {
                      _isSendingMessage = false;
                    });
                  },
          ),
          Expanded(
            child: TextFormField(
              readOnly: _isSendingMessage,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _messageController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'اكتب رسالتك هنا...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          // IconButton(
          //   icon: const Icon(Icons.camera_alt),
          //   onPressed: () {},
          // ),
          // IconButton(
          //   icon: const Icon(Icons.mic),
          //   onPressed: () {},
          // ),
        ],
      ),
    );
  }
}
