import 'package:auto_route/auto_route.dart';
import 'package:e_commerce/constants/app_sizes.dart';
import 'package:e_commerce/features/home/presentation/components/banners_carousel.dart';
import 'package:e_commerce/features/home/presentation/components/flash_sale_list.dart';
import 'package:e_commerce/features/home/presentation/components/product_search_bar.dart';
import 'package:e_commerce/features/products/presentation/components/products_list.dart';
import 'package:e_commerce/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

@RoutePage()
class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  static const _searchBarBottomPadding = kSize_12;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kSize_16),
            child: ProductSearchBar(
              scrollController: scrollController,
              showShadowOffset: _searchBarBottomPadding - 4,
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        controller: scrollController,
        slivers: const [
          SliverSafeArea(
            bottom: false,
            sliver: SliverGap(_searchBarBottomPadding),
          ),
          _BannersSliver(),
          SliverGap(kSize_32),
          _FlashSaleSliver(),
          SliverGap(kSize_32),
          ProductListSliver(),
          SliverSafeArea(
            top: false,
            sliver: SliverGap(kSize_24),
          ),
        ],
      ),
    );
  }
}

class _BannersSliver extends StatelessWidget {
  const _BannersSliver();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          const BannersCarousel(),
          const Gap(kSize_12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kSize_12),
            child: Image.asset(
              'assets/shopee_banners/banner_buttons.png',
            ),
          ),
        ],
      ),
    );
  }
}

class _FlashSaleSliver extends HookConsumerWidget {
  const _FlashSaleSliver();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: kSize_16, right: kSize_2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/flash_sale.png',
                      height: kSize_16,
                    ),
                    Text(
                      'Kết thúc sau 02:07:40',
                      style: context.textTheme.titleSmall,
                    ),
                  ],
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Symbols.arrow_forward_ios),
                    label: Text(
                      'Xem tất cả',
                      style: context.textTheme.labelLarge,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(kSize_8),
          const FlashSaleList(),
        ],
      ),
    );
  }
}
