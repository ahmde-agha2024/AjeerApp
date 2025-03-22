import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/controllers/service_provider/provider_offers_provider.dart';
import 'package:ajeer/models/common/chat_model.dart';
import 'package:ajeer/models/common/service_details_model.dart';
import 'package:ajeer/models/provider/provider_offers_model.dart';
import 'package:ajeer/ui/screens/home_provider/request_details_provider_screen.dart';
import 'package:ajeer/ui/screens/single_chat_screen.dart';
import 'package:ajeer/ui/widgets/common/error_widget.dart';
import 'package:ajeer/ui/widgets/common/loader_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../constants/my_colors.dart';
import '../../widgets/button_styles.dart';
import '../../widgets/sized_box.dart';

class OffersProviderScreen extends StatefulWidget {
  OffersProviderScreen({super.key});

  @override
  State<OffersProviderScreen> createState() => _OffersProviderScreenState();
}

class _OffersProviderScreenState extends State<OffersProviderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool _isFetched = false;
  ResponseHandler<ProviderOffers> providerOffers =
      ResponseHandler(status: ResponseStatus.error);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void didChangeDependencies() {
    if (!_isFetched) {
      _fetchOffers();
    }
    super.didChangeDependencies();
  }

  Future<void> _fetchOffers() async {
    final fetchedData =
        await Provider.of<ProviderOffersProvider>(context, listen: false)
            .fetchMyOffers();
    setState(() {
      providerOffers = fetchedData;
      _isFetched = true;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'العروض'.tr(),
          style: const TextStyle(
            color: MyColors.Darkest,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: !_isFetched
          ? loaderWidget(context,type: "tab_view_IOS")
          : providerOffers.status == ResponseStatus.error
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
                              'Try Again'.tr(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _isFetched = false;
                              _fetchOffers();
                            });
                          }),
                    )
                  ],
                )
              : Column(
                  children: [
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: TabBar(
                        controller: _tabController,
                        indicatorColor: MyColors.MainBulma,
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        dividerColor: Colors.transparent,
                        tabs: const [
                          Tab(
                            text: 'عروض منتظرة',
                          ),
                          Tab(
                            text: 'عروض مقبولة',
                          ),
                          Tab(
                            text: 'عروض مرفوضة',
                          ),
                        ],
                      ),
                    ),
                    SizedBoxedH16,
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          RefreshIndicator(
                            onRefresh: _fetchOffers,
                            child: providerOffers.response?.pending!.length!=0?buildOffersList(
                                providerOffers.response?.pending ?? []): Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                      'assets/Icons/0ffersIcons.png',
                                      height: 180,
                                      width: 180),
                                  const SizedBox(height: 16),
                                  Text(
                                    'لا توجد عروض في الانتظار حالياً !',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: MyColors.Darkest),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          RefreshIndicator(
                            onRefresh: _fetchOffers,
                            child: providerOffers.response?.accepted!.length!=0? buildOffersList(
                                providerOffers.response?.accepted ?? []): Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                      'assets/Icons/0ffersIcons.png',
                                      height: 180,
                                      width: 180),
                                  const SizedBox(height: 16),
                                  Text(
                                    'لم يتم تلقي أي عروض مقبولة حتى الآن !',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: MyColors.Darkest),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          RefreshIndicator(
                            onRefresh: _fetchOffers,
                            child: providerOffers.response?.rejected!.length!=0 ?buildOffersList(
                                providerOffers.response?.rejected ?? []): Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                      'assets/Icons/0ffersIcons.png',
                                      height: 180,
                                      width: 180),
                                  const SizedBox(height: 16),
                                  Text(
                                    'لا يوجد عروض مرفوضة !',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: MyColors.Darkest),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  buildOffersList(List<Offer>? offers) {
    return ListView.builder(
      itemCount: offers?.length ?? 0,
      shrinkWrap: true,
      itemBuilder: (ctx, index) {
        return ProviderOfferCard(
          offer: offers![index],
        );
      },
    );
  }
}

class ProviderOfferCard extends StatefulWidget {
  Offer offer;

  ProviderOfferCard({super.key, required this.offer});

  @override
  State<ProviderOfferCard> createState() => _ProviderOfferCardState();
}

class _ProviderOfferCardState extends State<ProviderOfferCard> {
  bool _isCancelling = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16, right: 8),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(16),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: widget.offer.service!.image!,
                    height: 120,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              widget.offer.service!.title ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                color: MyColors.Darkest,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Card(
                            color: MyColors.cardPriceBackgroundColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 12),
                              child: Text(
                                "${widget.offer.price} دينار",
                                style: const TextStyle(
                                    fontSize: 12, color: MyColors.MainPrimary),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBoxedH8,
                      Row(
                        children: [
                          SvgPicture.asset('assets/svg/request_calender.svg'),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              'تاريخ الطلب ${widget.offer.date ?? ''}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: MyColors.textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBoxedH8,
                      Row(
                        children: [
                          SvgPicture.asset('assets/svg/request_calender.svg'),
                          const SizedBox(width: 6),
                          Text(
                            'الساعة ${widget.offer.time}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: MyColors.textColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBoxedH8,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextButton(
                              style: flatButtonLightStyle,
                              onPressed: () async {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RequestDetailsProviderScreen(
                                      loadedService: widget.offer.service!,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                'عرض تفاصيل'.tr(),
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    color: MyColors.Darkest),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (widget.offer.status == 'ACCEPTED' ||
                              widget.offer.status == 'OFFER_ACCEPTED')
                            Expanded(
                              child: TextButton(
                                style: flatButtonPrimaryStyle,
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => SingleChatScreen(
                                            chatHead: ChatHead(
                                              provider: widget.offer.provider,
                                              customer: widget
                                                  .offer.service!.customer,
                                            ),
                                            service: widget.offer.service,
                                          )));
                                },
                                child: Text(
                                  'محادثة'.tr(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          if (widget.offer.status == 'PENDING' ||
                              widget.offer.status == 'NEW')
                            Expanded(
                              child: _isCancelling
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : TextButton(
                                      style: flatButtonPrimaryStyle,
                                      onPressed: () async {
                                        setState(() {
                                          _isCancelling = true;
                                        });

                                        ResponseHandler response =
                                            await Provider.of<
                                                        ProviderOffersProvider>(
                                                    context,
                                                    listen: false)
                                                .cancelAnOffer(
                                          widget.offer.id!,
                                        );
                                        if (response.status ==
                                            ResponseStatus.success) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'تم إلغاء العرض بنجاح')));
                                        } else if (response.errorMessage !=
                                            null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      response.errorMessage!)));
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text('حدث خطأ ما')));
                                        }
                                        setState(() {
                                          _isCancelling = false;
                                        });
                                      },
                                      child: Text(
                                        'إلغاء العرض'.tr(),
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white),
                                      ),
                                    ),
                            )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
