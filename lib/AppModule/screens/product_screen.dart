import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stockcounter/AppModule/provider/product_provider.dart';
import 'package:stockcounter/AppModule/utils/Fonts/AppDimensions.dart';
import 'package:stockcounter/AppModule/utils/Fonts/font_weights.dart';
import 'package:stockcounter/AppModule/utils/app_text.dart';
import 'package:stockcounter/AppModule/utils/constants.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late ProductProvider productProvider;

  @override
  void initState() {
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    Future.wait([productProvider.getDataFromDb()]);
    productProvider.initScroll(context);
    // homeProvider = Provider.of<HomeProvider>(context, listen: false);

    // scrollController.addListener(() {
    //   if (scrollController.position.pixels ==
    //       scrollController.position.maxScrollExtent) {
    //     if (currentMax < homeProvider.productNameList.length) {
    //       isLoading = true;
    //       setState(() {
    //         currentMax += 26;
    //         currentMin += 26;
    //       });
    //       Future.delayed(const Duration(seconds: 1), () {
    //         isLoading = false;
    //         setState(() {});
    //       });
    //     }
    //   }
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //title grid
            Container(
              width: size.width,
              height: size.height * 0.08,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(5.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.01),
                    spreadRadius: 1.r,
                    blurRadius: 1.r,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: size.width * 0.05,
                  ),
                  AppText(
                    text: 'Category',
                    fontWeight: FontWeights.medium,
                    fontSize: AppDimension.fontSize16,
                    color: Constants.blackColor,
                  ),
                  AppText(
                    text: 'Brand',
                    fontWeight: FontWeights.medium,
                    fontSize: AppDimension.fontSize16,
                    color: Constants.blackColor,
                  ),
                  AppText(
                    text: 'Segment',
                    fontWeight: FontWeights.medium,
                    fontSize: AppDimension.fontSize16,
                    color: Constants.blackColor,
                  ),
                  AppText(
                    text: 'Product  ',
                    fontWeight: FontWeights.medium,
                    fontSize: AppDimension.fontSize16,
                    color: Constants.blackColor,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: Consumer<ProductProvider>(
                  builder: (context, provider, child) {
                    return ListView(
                      controller: provider.scrollController,
                      shrinkWrap: true,
                      children: [
                        Row(
                          children: [
                            provider.categoryList.isEmpty
                                ? Container(
                                    width: size.width,
                                    height: size.height * 0.08,
                                    alignment: Alignment.center,
                                    child: AppText(
                                      text: 'No Data Found',
                                      fontWeight: FontWeights.regular,
                                      fontSize: AppDimension.fontSize14,
                                      color: Constants.blackColor,
                                    ),
                                  )
                                : SizedBox(
                                    width: size.width * 0.2,
                                    child: ListView.builder(
                                      itemCount: provider.currentMax <=
                                              provider.categoryList.length
                                          ? provider.currentMax
                                          : provider.categoryList.length,
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return provider.categoryList.isEmpty
                                            ? const SizedBox.shrink()
                                            : Container(
                                                decoration: BoxDecoration(
                                                  color: Constants.redColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                ),
                                                margin: EdgeInsets.only(
                                                    left: 5.w,
                                                    right: 25.h,
                                                    bottom: 5.w),
                                                child: IconButton(
                                                  onPressed: () {
                                                    provider.showAlertDialog(
                                                        context, () {
                                                      provider.checkProductExists(index, context,
                                                          provider.productNameList[index]);
                                                    });
                                                    // debugPrint('--> pName ${provider.productNameList[index]}');
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                  padding: EdgeInsets.zero,
                                                ),
                                              );
                                      },
                                    ),
                                  ),
                            //category list
                            Expanded(
                              child: ListView.builder(
                                itemCount: provider.currentMax <=
                                        provider.categoryList.length
                                    ? provider.currentMax
                                    : provider.categoryList.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return provider.categoryList.isEmpty
                                      ? const SizedBox.shrink()
                                      : ListTile(
                                          title: AppText(
                                            text: provider.categoryList[index],
                                            fontWeight: FontWeights.regular,
                                            fontSize: AppDimension.fontSize14,
                                            softWrap: true,
                                          ),
                                          contentPadding: EdgeInsets.zero,
                                        );
                                },
                              ),
                            ),

                            //brand list
                            Expanded(
                              child: ListView.builder(
                                itemCount: provider.currentMax <=
                                        provider.brandList.length
                                    ? provider.currentMax
                                    : provider.brandList.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return provider.brandList.isEmpty
                                      ? const SizedBox.shrink()
                                      : ListTile(
                                          title: AppText(
                                            text:
                                                '${provider.brandList[index]}',
                                            fontWeight: FontWeights.regular,
                                            fontSize: AppDimension.fontSize14,
                                            softWrap: true,
                                          ),
                                          contentPadding: EdgeInsets.zero,
                                        );
                                },
                              ),
                            ),
                            //segment list
                            Expanded(
                              child: ListView.builder(
                                itemCount: provider.currentMax <=
                                        provider.segmentList.length
                                    ? provider.currentMax
                                    : provider.segmentList.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return provider.segmentList.isEmpty
                                      ? const SizedBox.shrink()
                                      : ListTile(
                                          title: AppText(
                                            text:
                                                '${provider.segmentList[index]}',
                                            fontWeight: FontWeights.regular,
                                            fontSize: AppDimension.fontSize14,
                                            softWrap: true,
                                          ),
                                          contentPadding: EdgeInsets.zero,
                                        );
                                },
                              ),
                            ),
                            //product list
                            Expanded(
                              child: ListView.builder(
                                itemCount: provider.currentMax <=
                                        provider.productNameList.length
                                    ? provider.currentMax
                                    : provider.productNameList.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return provider.productNameList.isEmpty
                                      ? const SizedBox.shrink()
                                      : ListTile(
                                          title: AppText(
                                            text:
                                                '  ${provider.productNameList[index]}',
                                            fontWeight: FontWeights.regular,
                                            fontSize: AppDimension.fontSize14,
                                            softWrap: true,
                                          ),
                                          contentPadding: EdgeInsets.zero,
                                        );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Consumer<ProductProvider>(
              builder: (context, pro, child) {
                return Center(
                  child: pro.isLoading
                      ? CircularProgressIndicator(
                          color: Constants.darkGreyColor,
                        )
                      : const SizedBox.shrink(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
