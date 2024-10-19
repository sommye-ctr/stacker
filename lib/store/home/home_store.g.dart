// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeStore on _HomeStoreBase, Store {
  late final _$createdStacksAtom =
      Atom(name: '_HomeStoreBase.createdStacks', context: context);

  @override
  List<StackModel> get createdStacks {
    _$createdStacksAtom.reportRead();
    return super.createdStacks;
  }

  @override
  set createdStacks(List<StackModel> value) {
    _$createdStacksAtom.reportWrite(value, super.createdStacks, () {
      super.createdStacks = value;
    });
  }

  late final _$joinedStacksAtom =
      Atom(name: '_HomeStoreBase.joinedStacks', context: context);

  @override
  List<StackModel> get joinedStacks {
    _$joinedStacksAtom.reportRead();
    return super.joinedStacks;
  }

  @override
  set joinedStacks(List<StackModel> value) {
    _$joinedStacksAtom.reportWrite(value, super.joinedStacks, () {
      super.joinedStacks = value;
    });
  }

  late final _$_HomeStoreBaseActionController =
      ActionController(name: '_HomeStoreBase', context: context);

  @override
  void fetchCreatedStacks() {
    final _$actionInfo = _$_HomeStoreBaseActionController.startAction(
        name: '_HomeStoreBase.fetchCreatedStacks');
    try {
      return super.fetchCreatedStacks();
    } finally {
      _$_HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void fetchJoinedStacks() {
    final _$actionInfo = _$_HomeStoreBaseActionController.startAction(
        name: '_HomeStoreBase.fetchJoinedStacks');
    try {
      return super.fetchJoinedStacks();
    } finally {
      _$_HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
createdStacks: ${createdStacks},
joinedStacks: ${joinedStacks}
    ''';
  }
}
