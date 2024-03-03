import 'package:driving_license/common_widgets/async_value/async_value_widget.dart';
import 'package:driving_license/common_widgets/placeholder_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AsyncValueScaffold<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Scaffold Function(T) builder;

  const AsyncValueScaffold({
    super.key,
    required this.value,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return value.maybeWhen(
      data: builder,
      orElse: () => PlaceholderScaffold(
        // The reason why we use AsyncValueWidget here is because we want to
        // ensure the loading indicator and error message behavior are
        // consistent across our app
        content: AsyncValueWidget(
          value: value,
          // We don't care about the data here, it is handled by
          // 'data: scaffold' above and will never be called
          builder: (_) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}
