import 'package:driving_license/backend/in_app_purchase/data/iap_providers.dart';
import 'package:driving_license/backend/in_app_purchase/domain/iap_product.dart';
import 'package:driving_license/backend/in_app_purchase/domain/iap_product_purchase.dart';
import 'package:driving_license/backend/in_app_purchase/iap_service.dart';
import 'package:driving_license/features/donate/domain/donate_product_entry.dart';
import 'package:driving_license/logging/logger_provider.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'donate_screen_controller.g.dart';

class BanknoteCardController {
  BanknoteCardController({
    required this.iapService,
    required this.logger,
  });

  final IapService iapService;
  final Logger logger;

  Future<IapProductPurchaseState> buyProduct(IapProduct product) async {
    try {
      return await iapService.buyProduct(product);
    } catch (e, st) {
      logger.e('Buy product failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}

@riverpod
BanknoteCardController banknoteCardController(BanknoteCardControllerRef ref) {
  final iapService = ref.watch(iapServiceProvider);
  final logger = ref.watch(loggerProvider);

  return BanknoteCardController(iapService: iapService, logger: logger);
}

@riverpod
FutureOr<bool> isUserDonated(IsUserDonatedRef ref) async {
  // final isAnyPending =
  //     await ref.watch(isAnyPurchasePendingStreamProvider.future);
  final isAnyCompleted =
      await ref.watch(isAnyPurchaseCompletedStreamProvider.future);

  // return isAnyPending || isAnyCompleted;
  return isAnyCompleted;
}

//! This is madness, waiting to change this to generic type once Riverpod 3.0 is
//! released.
@riverpod
FutureOr<List<IapProduct<DonateProductEntry>>> donateProductListFuture(
  DonateProductListFutureRef ref,
) async {
  final iapProductsList = await ref
      .watch(iapProductsListFutureProvider(DonateProductEntry.values).future);

  return iapProductsList
      .map(
        (e) => IapProduct<DonateProductEntry>(
          e.productDetails,
          e.entry as DonateProductEntry,
        ),
      )
      .toList();
}
