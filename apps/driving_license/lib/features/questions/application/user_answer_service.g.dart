// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_answer_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userAnswerServiceHash() => r'c0740097aac54d9d652386d821edba9372aca161';

/// See also [userAnswerService].
@ProviderFor(userAnswerService)
final userAnswerServiceProvider = Provider<UserAnswerService>.internal(
  userAnswerService,
  name: r'userAnswerServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userAnswerServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserAnswerServiceRef = ProviderRef<UserAnswerService>;
String _$userSelectedAnswerIndexHash() =>
    r'aa526c21d0c7701dd8779b59cb9f5c5aa3df7723';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [userSelectedAnswerIndex].
@ProviderFor(userSelectedAnswerIndex)
const userSelectedAnswerIndexProvider = UserSelectedAnswerIndexFamily();

/// See also [userSelectedAnswerIndex].
class UserSelectedAnswerIndexFamily extends Family<AsyncValue<int?>> {
  /// See also [userSelectedAnswerIndex].
  const UserSelectedAnswerIndexFamily();

  /// See also [userSelectedAnswerIndex].
  UserSelectedAnswerIndexProvider call(
    Question question,
  ) {
    return UserSelectedAnswerIndexProvider(
      question,
    );
  }

  @override
  UserSelectedAnswerIndexProvider getProviderOverride(
    covariant UserSelectedAnswerIndexProvider provider,
  ) {
    return call(
      provider.question,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userSelectedAnswerIndexProvider';
}

/// See also [userSelectedAnswerIndex].
class UserSelectedAnswerIndexProvider extends AutoDisposeStreamProvider<int?> {
  /// See also [userSelectedAnswerIndex].
  UserSelectedAnswerIndexProvider(
    Question question,
  ) : this._internal(
          (ref) => userSelectedAnswerIndex(
            ref as UserSelectedAnswerIndexRef,
            question,
          ),
          from: userSelectedAnswerIndexProvider,
          name: r'userSelectedAnswerIndexProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userSelectedAnswerIndexHash,
          dependencies: UserSelectedAnswerIndexFamily._dependencies,
          allTransitiveDependencies:
              UserSelectedAnswerIndexFamily._allTransitiveDependencies,
          question: question,
        );

  UserSelectedAnswerIndexProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.question,
  }) : super.internal();

  final Question question;

  @override
  Override overrideWith(
    Stream<int?> Function(UserSelectedAnswerIndexRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserSelectedAnswerIndexProvider._internal(
        (ref) => create(ref as UserSelectedAnswerIndexRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        question: question,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<int?> createElement() {
    return _UserSelectedAnswerIndexProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserSelectedAnswerIndexProvider &&
        other.question == question;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, question.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserSelectedAnswerIndexRef on AutoDisposeStreamProviderRef<int?> {
  /// The parameter `question` of this provider.
  Question get question;
}

class _UserSelectedAnswerIndexProviderElement
    extends AutoDisposeStreamProviderElement<int?>
    with UserSelectedAnswerIndexRef {
  _UserSelectedAnswerIndexProviderElement(super.provider);

  @override
  Question get question => (origin as UserSelectedAnswerIndexProvider).question;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
