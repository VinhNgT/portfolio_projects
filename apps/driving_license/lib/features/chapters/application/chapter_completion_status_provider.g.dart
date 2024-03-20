// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_completion_status_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chapterCompletionStatusHash() =>
    r'363fca6c3255cb0aaab6b07666457c583c8c261e';

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

/// See also [chapterCompletionStatus].
@ProviderFor(chapterCompletionStatus)
const chapterCompletionStatusProvider = ChapterCompletionStatusFamily();

/// See also [chapterCompletionStatus].
class ChapterCompletionStatusFamily extends Family<AsyncValue<TestResult>> {
  /// See also [chapterCompletionStatus].
  const ChapterCompletionStatusFamily();

  /// See also [chapterCompletionStatus].
  ChapterCompletionStatusProvider call(
    Chapter chapter,
  ) {
    return ChapterCompletionStatusProvider(
      chapter,
    );
  }

  @override
  ChapterCompletionStatusProvider getProviderOverride(
    covariant ChapterCompletionStatusProvider provider,
  ) {
    return call(
      provider.chapter,
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
  String? get name => r'chapterCompletionStatusProvider';
}

/// See also [chapterCompletionStatus].
class ChapterCompletionStatusProvider
    extends AutoDisposeStreamProvider<TestResult> {
  /// See also [chapterCompletionStatus].
  ChapterCompletionStatusProvider(
    Chapter chapter,
  ) : this._internal(
          (ref) => chapterCompletionStatus(
            ref as ChapterCompletionStatusRef,
            chapter,
          ),
          from: chapterCompletionStatusProvider,
          name: r'chapterCompletionStatusProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chapterCompletionStatusHash,
          dependencies: ChapterCompletionStatusFamily._dependencies,
          allTransitiveDependencies:
              ChapterCompletionStatusFamily._allTransitiveDependencies,
          chapter: chapter,
        );

  ChapterCompletionStatusProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chapter,
  }) : super.internal();

  final Chapter chapter;

  @override
  Override overrideWith(
    Stream<TestResult> Function(ChapterCompletionStatusRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChapterCompletionStatusProvider._internal(
        (ref) => create(ref as ChapterCompletionStatusRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chapter: chapter,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<TestResult> createElement() {
    return _ChapterCompletionStatusProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChapterCompletionStatusProvider && other.chapter == chapter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chapter.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChapterCompletionStatusRef on AutoDisposeStreamProviderRef<TestResult> {
  /// The parameter `chapter` of this provider.
  Chapter get chapter;
}

class _ChapterCompletionStatusProviderElement
    extends AutoDisposeStreamProviderElement<TestResult>
    with ChapterCompletionStatusRef {
  _ChapterCompletionStatusProviderElement(super.provider);

  @override
  Chapter get chapter => (origin as ChapterCompletionStatusProvider).chapter;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member