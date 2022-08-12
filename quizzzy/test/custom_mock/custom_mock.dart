import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:mockito/mockito.dart';

class HttpsCallableResultMock<T> extends Mock
    implements HttpsCallableResult<T> {
  HttpsCallableResultMock.test(this.data);

  @override
  final T data;
}

// ignore: subtype_of_sealed_class
class QueryDocumentSnapshotMock<T> extends Mock
    implements QueryDocumentSnapshot<T> {
  QueryDocumentSnapshotMock.test(this.docs);

  final T docs;
}
