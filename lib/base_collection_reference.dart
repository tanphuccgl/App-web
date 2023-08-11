import 'package:app/common/base_model.dart';
import 'package:app/common/result.dart';
import 'package:app/endpoints.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/foundation.dart';

class BaseCollectionReference<T extends BaseModel> {
  BaseCollectionReference(this.ref);
  void log(dynamic value) => debugPrint('$value');
  final CollectionReference<T> ref;

  Future<XResult<T>> get(String id) async {
    try {
      final DocumentSnapshot<T> doc = await ref.doc(id).get();
      if (doc.exists) {
        return XResult.success(doc.data());
      } else {
        return XResult.error('Error');
      }
    } catch (e) {
      return XResult.exception(e);
    }
  }

  Stream<DocumentSnapshot<T>> snapshots(String id) {
    return ref.doc(id).snapshots();
  }

  Future<XResult<T>> add(T item) async {
    try {
      final DocumentReference<T> doc = await ref
          .add(item)
          .timeout(const Duration(seconds: Endpoints.connectionTimeout));
      item.id = doc.id;
      return XResult.success(item);
    } catch (e) {
      return XResult.exception(e);
    }
  }

  Future<XResult<T>> set(T item, {bool merge = true}) async {
    try {
      await ref
          .doc(item.id.isEmpty ? null : item.id)
          .set(item, SetOptions(merge: merge))
          .timeout(const Duration(seconds: Endpoints.connectionTimeout));
      return XResult.success(item);
    } catch (e) {
      return XResult.exception(e);
    }
  }

  Future<XResult<String>> remove(String id) async {
    try {
      await ref
          .doc(id)
          .delete()
          .timeout(const Duration(seconds: Endpoints.connectionTimeout));
      return XResult.success(id);
    } catch (e) {
      return XResult.exception(e);
    }
  }

  Future<XResult<List<T>>> query() async {
    try {
      final QuerySnapshot<T> query = await ref
          .get()
          .timeout(const Duration(seconds: Endpoints.connectionTimeout));
      final docs = query.docs.map((e) => e.data()).toList();
      return XResult.success(docs);
    } catch (e) {
      return XResult.exception(e);
    }
  }

  Future<XResult<List<T>>> commit(List<T> items, {bool merge = true}) async {
    try {
      var batch = ref.firestore.batch();
      for (int i = 0; i < items.length; i++) {
        {
          batch.set(ref.doc(items[i].id), items[i], SetOptions(merge: merge));
        }
      }

      batch
          .commit()
          .timeout(const Duration(seconds: Endpoints.connectionTimeout));

      return XResult.success(items);
    } catch (e) {
      return XResult.exception(e);
    }
  }
}
