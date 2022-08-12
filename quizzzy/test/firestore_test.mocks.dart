// Mocks generated by Mockito 5.3.0 from annotations
// in quizzzy/test/firestore_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i7;
import 'dart:typed_data' as _i8;

import 'package:cloud_firestore/cloud_firestore.dart' as _i4;
import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart'
    as _i3;
import 'package:cloud_functions/cloud_functions.dart' as _i6;
import 'package:cloud_functions_platform_interface/cloud_functions_platform_interface.dart'
    as _i5;
import 'package:firebase_core/firebase_core.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeFirebaseApp_0 extends _i1.SmartFake implements _i2.FirebaseApp {
  _FakeFirebaseApp_0(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeSettings_1 extends _i1.SmartFake implements _i3.Settings {
  _FakeSettings_1(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeCollectionReference_2<T extends Object?> extends _i1.SmartFake
    implements _i4.CollectionReference<T> {
  _FakeCollectionReference_2(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeWriteBatch_3 extends _i1.SmartFake implements _i4.WriteBatch {
  _FakeWriteBatch_3(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeLoadBundleTask_4 extends _i1.SmartFake
    implements _i4.LoadBundleTask {
  _FakeLoadBundleTask_4(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeQuerySnapshot_5<T extends Object?> extends _i1.SmartFake
    implements _i4.QuerySnapshot<T> {
  _FakeQuerySnapshot_5(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeQuery_6<T extends Object?> extends _i1.SmartFake
    implements _i4.Query<T> {
  _FakeQuery_6(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeDocumentReference_7<T extends Object?> extends _i1.SmartFake
    implements _i4.DocumentReference<T> {
  _FakeDocumentReference_7(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeFirebaseFunctionsPlatform_8 extends _i1.SmartFake
    implements _i5.FirebaseFunctionsPlatform {
  _FakeFirebaseFunctionsPlatform_8(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeHttpsCallable_9 extends _i1.SmartFake implements _i6.HttpsCallable {
  _FakeHttpsCallable_9(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeFirebaseFirestore_10 extends _i1.SmartFake
    implements _i4.FirebaseFirestore {
  _FakeFirebaseFirestore_10(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeSnapshotMetadata_11 extends _i1.SmartFake
    implements _i4.SnapshotMetadata {
  _FakeSnapshotMetadata_11(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeDocumentSnapshot_12<T extends Object?> extends _i1.SmartFake
    implements _i4.DocumentSnapshot<T> {
  _FakeDocumentSnapshot_12(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

/// A class which mocks [FirebaseFirestore].
///
/// See the documentation for Mockito's code generation for more information.
class MockFirebaseFirestore extends _i1.Mock implements _i4.FirebaseFirestore {
  MockFirebaseFirestore() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.FirebaseApp get app => (super.noSuchMethod(Invocation.getter(#app),
          returnValue: _FakeFirebaseApp_0(this, Invocation.getter(#app)))
      as _i2.FirebaseApp);
  @override
  set app(_i2.FirebaseApp? _app) =>
      super.noSuchMethod(Invocation.setter(#app, _app),
          returnValueForMissingStub: null);
  @override
  set settings(_i3.Settings? settings) =>
      super.noSuchMethod(Invocation.setter(#settings, settings),
          returnValueForMissingStub: null);
  @override
  _i3.Settings get settings => (super.noSuchMethod(Invocation.getter(#settings),
          returnValue: _FakeSettings_1(this, Invocation.getter(#settings)))
      as _i3.Settings);
  @override
  Map<dynamic, dynamic> get pluginConstants =>
      (super.noSuchMethod(Invocation.getter(#pluginConstants),
          returnValue: <dynamic, dynamic>{}) as Map<dynamic, dynamic>);
  @override
  _i4.CollectionReference<Map<String, dynamic>> collection(
          String? collectionPath) =>
      (super.noSuchMethod(Invocation.method(#collection, [collectionPath]),
              returnValue: _FakeCollectionReference_2<Map<String, dynamic>>(
                  this, Invocation.method(#collection, [collectionPath])))
          as _i4.CollectionReference<Map<String, dynamic>>);
  @override
  _i4.WriteBatch batch() => (super.noSuchMethod(Invocation.method(#batch, []),
          returnValue: _FakeWriteBatch_3(this, Invocation.method(#batch, [])))
      as _i4.WriteBatch);
  @override
  _i7.Future<void> clearPersistence() => (super.noSuchMethod(
      Invocation.method(#clearPersistence, []),
      returnValue: _i7.Future<void>.value(),
      returnValueForMissingStub: _i7.Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> enablePersistence(
          [_i3.PersistenceSettings? persistenceSettings]) =>
      (super.noSuchMethod(
              Invocation.method(#enablePersistence, [persistenceSettings]),
              returnValue: _i7.Future<void>.value(),
              returnValueForMissingStub: _i7.Future<void>.value())
          as _i7.Future<void>);
  @override
  _i4.LoadBundleTask loadBundle(_i8.Uint8List? bundle) =>
      (super.noSuchMethod(Invocation.method(#loadBundle, [bundle]),
              returnValue: _FakeLoadBundleTask_4(
                  this, Invocation.method(#loadBundle, [bundle])))
          as _i4.LoadBundleTask);
  @override
  void useFirestoreEmulator(String? host, int? port,
          {bool? sslEnabled = false}) =>
      super.noSuchMethod(
          Invocation.method(
              #useFirestoreEmulator, [host, port], {#sslEnabled: sslEnabled}),
          returnValueForMissingStub: null);
  @override
  _i7.Future<_i4.QuerySnapshot<Map<String, dynamic>>> namedQueryGet(
          String? name,
          {_i3.GetOptions? options = const _i3.GetOptions()}) =>
      (super.noSuchMethod(
          Invocation.method(#namedQueryGet, [name], {#options: options}),
          returnValue: _i7.Future<_i4.QuerySnapshot<Map<String, dynamic>>>.value(
              _FakeQuerySnapshot_5<Map<String, dynamic>>(this,
                  Invocation.method(#namedQueryGet, [name], {#options: options})))) as _i7
          .Future<_i4.QuerySnapshot<Map<String, dynamic>>>);
  @override
  _i4.Query<Map<String, dynamic>> collectionGroup(String? collectionPath) =>
      (super.noSuchMethod(Invocation.method(#collectionGroup, [collectionPath]),
              returnValue: _FakeQuery_6<Map<String, dynamic>>(
                  this, Invocation.method(#collectionGroup, [collectionPath])))
          as _i4.Query<Map<String, dynamic>>);
  @override
  _i7.Future<void> disableNetwork() => (super.noSuchMethod(
      Invocation.method(#disableNetwork, []),
      returnValue: _i7.Future<void>.value(),
      returnValueForMissingStub: _i7.Future<void>.value()) as _i7.Future<void>);
  @override
  _i4.DocumentReference<Map<String, dynamic>> doc(String? documentPath) =>
      (super.noSuchMethod(Invocation.method(#doc, [documentPath]),
              returnValue: _FakeDocumentReference_7<Map<String, dynamic>>(
                  this, Invocation.method(#doc, [documentPath])))
          as _i4.DocumentReference<Map<String, dynamic>>);
  @override
  _i7.Future<void> enableNetwork() => (super.noSuchMethod(
      Invocation.method(#enableNetwork, []),
      returnValue: _i7.Future<void>.value(),
      returnValueForMissingStub: _i7.Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Stream<void> snapshotsInSync() =>
      (super.noSuchMethod(Invocation.method(#snapshotsInSync, []),
          returnValue: _i7.Stream<void>.empty()) as _i7.Stream<void>);
  @override
  _i7.Future<T> runTransaction<T>(_i4.TransactionHandler<T>? transactionHandler,
          {Duration? timeout = const Duration(seconds: 30),
          int? maxAttempts = 5}) =>
      (super.noSuchMethod(
          Invocation.method(#runTransaction, [transactionHandler],
              {#timeout: timeout, #maxAttempts: maxAttempts}),
          returnValue: _i7.Future<T>.value(null)) as _i7.Future<T>);
  @override
  _i7.Future<void> terminate() => (super.noSuchMethod(
      Invocation.method(#terminate, []),
      returnValue: _i7.Future<void>.value(),
      returnValueForMissingStub: _i7.Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> waitForPendingWrites() => (super.noSuchMethod(
      Invocation.method(#waitForPendingWrites, []),
      returnValue: _i7.Future<void>.value(),
      returnValueForMissingStub: _i7.Future<void>.value()) as _i7.Future<void>);
}

/// A class which mocks [FirebaseFunctions].
///
/// See the documentation for Mockito's code generation for more information.
class MockFirebaseFunctions extends _i1.Mock implements _i6.FirebaseFunctions {
  MockFirebaseFunctions() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.FirebaseApp get app => (super.noSuchMethod(Invocation.getter(#app),
          returnValue: _FakeFirebaseApp_0(this, Invocation.getter(#app)))
      as _i2.FirebaseApp);
  @override
  _i5.FirebaseFunctionsPlatform get delegate =>
      (super.noSuchMethod(Invocation.getter(#delegate),
              returnValue: _FakeFirebaseFunctionsPlatform_8(
                  this, Invocation.getter(#delegate)))
          as _i5.FirebaseFunctionsPlatform);
  @override
  Map<dynamic, dynamic> get pluginConstants =>
      (super.noSuchMethod(Invocation.getter(#pluginConstants),
          returnValue: <dynamic, dynamic>{}) as Map<dynamic, dynamic>);
  @override
  _i6.HttpsCallable httpsCallable(String? name,
          {_i5.HttpsCallableOptions? options}) =>
      (super.noSuchMethod(
              Invocation.method(#httpsCallable, [name], {#options: options}),
              returnValue: _FakeHttpsCallable_9(
                  this,
                  Invocation.method(
                      #httpsCallable, [name], {#options: options})))
          as _i6.HttpsCallable);
  @override
  void useFunctionsEmulator(String? host, int? port) =>
      super.noSuchMethod(Invocation.method(#useFunctionsEmulator, [host, port]),
          returnValueForMissingStub: null);
}

/// A class which mocks [CollectionReference].
///
/// See the documentation for Mockito's code generation for more information.
// ignore: must_be_immutable
class MockCollectionReference<T extends Object?> extends _i1.Mock
    implements _i4.CollectionReference<T> {
  MockCollectionReference() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get id =>
      (super.noSuchMethod(Invocation.getter(#id), returnValue: '') as String);
  @override
  String get path =>
      (super.noSuchMethod(Invocation.getter(#path), returnValue: '') as String);
  @override
  _i4.FirebaseFirestore get firestore => (super.noSuchMethod(
          Invocation.getter(#firestore),
          returnValue:
              _FakeFirebaseFirestore_10(this, Invocation.getter(#firestore)))
      as _i4.FirebaseFirestore);
  @override
  Map<String, dynamic> get parameters =>
      (super.noSuchMethod(Invocation.getter(#parameters),
          returnValue: <String, dynamic>{}) as Map<String, dynamic>);
  @override
  _i7.Future<_i4.DocumentReference<T>> add(T? data) =>
      (super.noSuchMethod(Invocation.method(#add, [data]),
              returnValue: _i7.Future<_i4.DocumentReference<T>>.value(
                  _FakeDocumentReference_7<T>(
                      this, Invocation.method(#add, [data]))))
          as _i7.Future<_i4.DocumentReference<T>>);
  @override
  _i4.DocumentReference<T> doc([String? path]) => (super.noSuchMethod(
      Invocation.method(#doc, [path]),
      returnValue: _FakeDocumentReference_7<T>(
          this, Invocation.method(#doc, [path]))) as _i4.DocumentReference<T>);
  @override
  _i4.CollectionReference<R> withConverter<R extends Object?>(
          {_i4.FromFirestore<R>? fromFirestore,
          _i4.ToFirestore<R>? toFirestore}) =>
      (super.noSuchMethod(
              Invocation.method(#withConverter, [],
                  {#fromFirestore: fromFirestore, #toFirestore: toFirestore}),
              returnValue: _FakeCollectionReference_2<R>(
                  this,
                  Invocation.method(
                      #withConverter, [], {#fromFirestore: fromFirestore, #toFirestore: toFirestore})))
          as _i4.CollectionReference<R>);
  @override
  _i4.Query<T> endAtDocument(_i4.DocumentSnapshot<Object?>? documentSnapshot) =>
      (super.noSuchMethod(Invocation.method(#endAtDocument, [documentSnapshot]),
              returnValue: _FakeQuery_6<T>(
                  this, Invocation.method(#endAtDocument, [documentSnapshot])))
          as _i4.Query<T>);
  @override
  _i4.Query<T> endAt(List<Object?>? values) =>
      (super.noSuchMethod(Invocation.method(#endAt, [values]),
              returnValue:
                  _FakeQuery_6<T>(this, Invocation.method(#endAt, [values])))
          as _i4.Query<T>);
  @override
  _i4.Query<T> endBeforeDocument(
          _i4.DocumentSnapshot<Object?>? documentSnapshot) =>
      (super.noSuchMethod(
              Invocation.method(#endBeforeDocument, [documentSnapshot]),
              returnValue: _FakeQuery_6<T>(this,
                  Invocation.method(#endBeforeDocument, [documentSnapshot])))
          as _i4.Query<T>);
  @override
  _i4.Query<T> endBefore(List<Object?>? values) => (super.noSuchMethod(
          Invocation.method(#endBefore, [values]),
          returnValue:
              _FakeQuery_6<T>(this, Invocation.method(#endBefore, [values])))
      as _i4.Query<T>);
  @override
  _i7.Future<_i4.QuerySnapshot<T>> get([_i3.GetOptions? options]) =>
      (super.noSuchMethod(Invocation.method(#get, [options]),
              returnValue: _i7.Future<_i4.QuerySnapshot<T>>.value(
                  _FakeQuerySnapshot_5<T>(
                      this, Invocation.method(#get, [options]))))
          as _i7.Future<_i4.QuerySnapshot<T>>);
  @override
  _i4.Query<T> limit(int? limit) =>
      (super.noSuchMethod(Invocation.method(#limit, [limit]),
              returnValue:
                  _FakeQuery_6<T>(this, Invocation.method(#limit, [limit])))
          as _i4.Query<T>);
  @override
  _i4.Query<T> limitToLast(int? limit) => (super.noSuchMethod(
          Invocation.method(#limitToLast, [limit]),
          returnValue:
              _FakeQuery_6<T>(this, Invocation.method(#limitToLast, [limit])))
      as _i4.Query<T>);
  @override
  _i7.Stream<_i4.QuerySnapshot<T>> snapshots(
          {bool? includeMetadataChanges = false}) =>
      (super.noSuchMethod(
              Invocation.method(#snapshots, [],
                  {#includeMetadataChanges: includeMetadataChanges}),
              returnValue: _i7.Stream<_i4.QuerySnapshot<T>>.empty())
          as _i7.Stream<_i4.QuerySnapshot<T>>);
  @override
  _i4.Query<T> orderBy(Object? field, {bool? descending = false}) =>
      (super.noSuchMethod(
              Invocation.method(#orderBy, [field], {#descending: descending}),
              returnValue: _FakeQuery_6<T>(
                  this,
                  Invocation.method(
                      #orderBy, [field], {#descending: descending})))
          as _i4.Query<T>);
  @override
  _i4.Query<T> startAfterDocument(
          _i4.DocumentSnapshot<Object?>? documentSnapshot) =>
      (super.noSuchMethod(
              Invocation.method(#startAfterDocument, [documentSnapshot]),
              returnValue: _FakeQuery_6<T>(this,
                  Invocation.method(#startAfterDocument, [documentSnapshot])))
          as _i4.Query<T>);
  @override
  _i4.Query<T> startAfter(List<Object?>? values) => (super.noSuchMethod(
          Invocation.method(#startAfter, [values]),
          returnValue:
              _FakeQuery_6<T>(this, Invocation.method(#startAfter, [values])))
      as _i4.Query<T>);
  @override
  _i4.Query<T> startAtDocument(
          _i4.DocumentSnapshot<Object?>? documentSnapshot) =>
      (super.noSuchMethod(
              Invocation.method(#startAtDocument, [documentSnapshot]),
              returnValue: _FakeQuery_6<T>(this,
                  Invocation.method(#startAtDocument, [documentSnapshot])))
          as _i4.Query<T>);
  @override
  _i4.Query<T> startAt(List<Object?>? values) =>
      (super.noSuchMethod(Invocation.method(#startAt, [values]),
              returnValue:
                  _FakeQuery_6<T>(this, Invocation.method(#startAt, [values])))
          as _i4.Query<T>);
  @override
  _i4.Query<T> where(Object? field,
          {Object? isEqualTo,
          Object? isNotEqualTo,
          Object? isLessThan,
          Object? isLessThanOrEqualTo,
          Object? isGreaterThan,
          Object? isGreaterThanOrEqualTo,
          Object? arrayContains,
          List<Object?>? arrayContainsAny,
          List<Object?>? whereIn,
          List<Object?>? whereNotIn,
          bool? isNull}) =>
      (super.noSuchMethod(
          Invocation.method(#where, [
            field
          ], {
            #isEqualTo: isEqualTo,
            #isNotEqualTo: isNotEqualTo,
            #isLessThan: isLessThan,
            #isLessThanOrEqualTo: isLessThanOrEqualTo,
            #isGreaterThan: isGreaterThan,
            #isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
            #arrayContains: arrayContains,
            #arrayContainsAny: arrayContainsAny,
            #whereIn: whereIn,
            #whereNotIn: whereNotIn,
            #isNull: isNull
          }),
          returnValue: _FakeQuery_6<T>(
              this,
              Invocation.method(#where, [
                field
              ], {
                #isEqualTo: isEqualTo,
                #isNotEqualTo: isNotEqualTo,
                #isLessThan: isLessThan,
                #isLessThanOrEqualTo: isLessThanOrEqualTo,
                #isGreaterThan: isGreaterThan,
                #isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
                #arrayContains: arrayContains,
                #arrayContainsAny: arrayContainsAny,
                #whereIn: whereIn,
                #whereNotIn: whereNotIn,
                #isNull: isNull
              }))) as _i4.Query<T>);
}

/// A class which mocks [QuerySnapshot].
///
/// See the documentation for Mockito's code generation for more information.
class MockQuerySnapshot<T extends Object?> extends _i1.Mock
    implements _i4.QuerySnapshot<T> {
  MockQuerySnapshot() {
    _i1.throwOnMissingStub(this);
  }

  @override
  List<_i4.QueryDocumentSnapshot<T>> get docs =>
      (super.noSuchMethod(Invocation.getter(#docs),
              returnValue: <_i4.QueryDocumentSnapshot<T>>[])
          as List<_i4.QueryDocumentSnapshot<T>>);
  @override
  List<_i4.DocumentChange<T>> get docChanges => (super.noSuchMethod(
      Invocation.getter(#docChanges),
      returnValue: <_i4.DocumentChange<T>>[]) as List<_i4.DocumentChange<T>>);
  @override
  _i4.SnapshotMetadata get metadata =>
      (super.noSuchMethod(Invocation.getter(#metadata),
              returnValue:
                  _FakeSnapshotMetadata_11(this, Invocation.getter(#metadata)))
          as _i4.SnapshotMetadata);
  @override
  int get size =>
      (super.noSuchMethod(Invocation.getter(#size), returnValue: 0) as int);
}

/// A class which mocks [DocumentReference].
///
/// See the documentation for Mockito's code generation for more information.
// ignore: must_be_immutable
class MockDocumentReference<T extends Object?> extends _i1.Mock
    implements _i4.DocumentReference<T> {
  MockDocumentReference() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.FirebaseFirestore get firestore => (super.noSuchMethod(
          Invocation.getter(#firestore),
          returnValue:
              _FakeFirebaseFirestore_10(this, Invocation.getter(#firestore)))
      as _i4.FirebaseFirestore);
  @override
  String get id =>
      (super.noSuchMethod(Invocation.getter(#id), returnValue: '') as String);
  @override
  _i4.CollectionReference<T> get parent => (super.noSuchMethod(
          Invocation.getter(#parent),
          returnValue:
              _FakeCollectionReference_2<T>(this, Invocation.getter(#parent)))
      as _i4.CollectionReference<T>);
  @override
  String get path =>
      (super.noSuchMethod(Invocation.getter(#path), returnValue: '') as String);
  @override
  _i4.CollectionReference<Map<String, dynamic>> collection(
          String? collectionPath) =>
      (super.noSuchMethod(Invocation.method(#collection, [collectionPath]),
              returnValue: _FakeCollectionReference_2<Map<String, dynamic>>(
                  this, Invocation.method(#collection, [collectionPath])))
          as _i4.CollectionReference<Map<String, dynamic>>);
  @override
  _i7.Future<void> delete() => (super.noSuchMethod(
      Invocation.method(#delete, []),
      returnValue: _i7.Future<void>.value(),
      returnValueForMissingStub: _i7.Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> update(Map<String, Object?>? data) => (super.noSuchMethod(
      Invocation.method(#update, [data]),
      returnValue: _i7.Future<void>.value(),
      returnValueForMissingStub: _i7.Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<_i4.DocumentSnapshot<T>> get([_i3.GetOptions? options]) =>
      (super.noSuchMethod(Invocation.method(#get, [options]),
              returnValue: _i7.Future<_i4.DocumentSnapshot<T>>.value(
                  _FakeDocumentSnapshot_12<T>(
                      this, Invocation.method(#get, [options]))))
          as _i7.Future<_i4.DocumentSnapshot<T>>);
  @override
  _i7.Stream<_i4.DocumentSnapshot<T>> snapshots(
          {bool? includeMetadataChanges = false}) =>
      (super.noSuchMethod(
              Invocation.method(#snapshots, [],
                  {#includeMetadataChanges: includeMetadataChanges}),
              returnValue: _i7.Stream<_i4.DocumentSnapshot<T>>.empty())
          as _i7.Stream<_i4.DocumentSnapshot<T>>);
  @override
  _i7.Future<void> set(T? data, [_i3.SetOptions? options]) =>
      (super.noSuchMethod(Invocation.method(#set, [data, options]),
              returnValue: _i7.Future<void>.value(),
              returnValueForMissingStub: _i7.Future<void>.value())
          as _i7.Future<void>);
  @override
  _i4.DocumentReference<R> withConverter<R>(
          {_i4.FromFirestore<R>? fromFirestore,
          _i4.ToFirestore<R>? toFirestore}) =>
      (super.noSuchMethod(
              Invocation.method(#withConverter, [],
                  {#fromFirestore: fromFirestore, #toFirestore: toFirestore}),
              returnValue: _FakeDocumentReference_7<R>(
                  this,
                  Invocation.method(
                      #withConverter, [], {#fromFirestore: fromFirestore, #toFirestore: toFirestore})))
          as _i4.DocumentReference<R>);
}

/// A class which mocks [DocumentSnapshot].
///
/// See the documentation for Mockito's code generation for more information.
class MockDocumentSnapshot<T extends Object?> extends _i1.Mock
    implements _i4.DocumentSnapshot<T> {
  MockDocumentSnapshot() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get id =>
      (super.noSuchMethod(Invocation.getter(#id), returnValue: '') as String);
  @override
  _i4.DocumentReference<T> get reference => (super.noSuchMethod(
          Invocation.getter(#reference),
          returnValue:
              _FakeDocumentReference_7<T>(this, Invocation.getter(#reference)))
      as _i4.DocumentReference<T>);
  @override
  _i4.SnapshotMetadata get metadata =>
      (super.noSuchMethod(Invocation.getter(#metadata),
              returnValue:
                  _FakeSnapshotMetadata_11(this, Invocation.getter(#metadata)))
          as _i4.SnapshotMetadata);
  @override
  bool get exists =>
      (super.noSuchMethod(Invocation.getter(#exists), returnValue: false)
          as bool);
  @override
  dynamic get(Object? field) =>
      super.noSuchMethod(Invocation.method(#get, [field]));
  @override
  dynamic operator [](Object? field) =>
      super.noSuchMethod(Invocation.method(#[], [field]));
}
