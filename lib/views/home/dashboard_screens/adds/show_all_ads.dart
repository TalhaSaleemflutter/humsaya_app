import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:humsaya_app/models/category_model.dart';
import 'package:humsaya_app/providers/ad_provider.dart';
import 'package:humsaya_app/providers/auth_provider.dart';
import 'package:humsaya_app/shared/constants/app_assets.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';
import 'package:humsaya_app/views/home/dashboard_screens/ad_discription_screen.dart';
import 'package:humsaya_app/widgets/custom_cards/custom_card.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_filter_button.dart';
import 'package:provider/provider.dart';

class ShowAllAdsScreen extends StatefulWidget {
  final CategoryModel? categoryModel;
  const ShowAllAdsScreen({super.key, this.categoryModel});

  @override
  State<ShowAllAdsScreen> createState() => _ShowAllAdsScreenState();
}

class _ShowAllAdsScreenState extends State<ShowAllAdsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _initialLoadComplete = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _loadInitialData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    final adProvider = Provider.of<AdProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (adProvider.products.isEmpty) {
      await adProvider.fetchAndSetAds(context, authProvider.currentUser.uid);
    } else if (adProvider.paginatedProducts.isEmpty) {
      await adProvider.loadMoreAds();
    }
    setState(() {
      _initialLoadComplete = true;
    });
  }

  void _scrollListener() {
    final adProvider = Provider.of<AdProvider>(context, listen: false);
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !adProvider.isLoadingMore &&
        adProvider.hasMore) {
      adProvider.loadMoreAds();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 22.w, right: 22.w),
        child: Consumer<AdProvider>(
          builder: (context, adProvider, child) {
            if (!_initialLoadComplete) {
              return Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                SizedBox(height: 50.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: SvgPicture.asset(
                        AppAssets.icBack,
                        height: 20.h,
                        width: 20.w,
                        color: Theme.of(context).appBarTheme.foregroundColor,
                      ),
                    ),
                    Container(
                      width: 310.w,
                      decoration: BoxDecoration(
                        color: ThemeHelper.getCardColor(context),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          prefixIcon: Icon(
                            Icons.search,
                            color: ThemeHelper.getTabbarTextColor(
                              context,
                              false,
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                Row(
                  children: [
                    CustomFilterButton(
                      text: "Filters",
                      icon: Icons.filter_list,
                      borderColor: primary,
                      textColor: primary,
                      backgroundColor: ThemeHelper.getCardColor(context),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 10),
                    CustomFilterButton(
                      text: "All Ads",
                      icon: Icons.close,
                      borderColor: Colors.transparent,
                      textColor: grey2,
                      backgroundColor: ThemeHelper.getCardColor(context),
                      onPressed: () {},
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await adProvider.resetPagination();
                      await _loadInitialData();
                    },
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          GridView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount:
                                adProvider.paginatedProducts
                                    .where(
                                      (product) =>
                                          product.categoryId ==
                                          widget.categoryModel?.categoryId,
                                    )
                                    .length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 15.w,
                                  mainAxisSpacing: 20.h,
                                  childAspectRatio: 0.72,
                                ),
                            itemBuilder: (context, index) {
                              // Get filtered list
                              final filteredProducts =
                                  adProvider.paginatedProducts
                                      .where(
                                        (product) =>
                                            product.categoryId ==
                                            widget.categoryModel?.categoryId,
                                      )
                                      .toList();

                              final value = filteredProducts[index];
                              final images = value.listOfImages;
                              if (images.isEmpty) return SizedBox();
                              return CustomProductCard(
                                image: Image.asset(AppAssets.image2),
                                price: value.price.toString(),
                                backgroundImages: [NetworkImage(images.last)],
                                title: value.title,
                                description: value.description.toString(),
                                time: value.createdAt.toString(),
                                offerText: value.discountPrice.toString(),
                                offerBgColor: Colors.red,
                                onTap:
                                    () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => AdDescriptionScreen(
                                              adModel: value,
                                            ),
                                      ),
                                    ),
                              );
                            },
                          ),
                          if (adProvider.isLoadingMore)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          if (!adProvider.hasMore &&
                              adProvider.paginatedProducts.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: Center(
                                child: Text(
                                  'All ads loaded',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                          if (adProvider.paginatedProducts.isEmpty &&
                              !adProvider.isLoading)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 100.h),
                              child: Center(
                                child: Text('No ads found in your area'),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
