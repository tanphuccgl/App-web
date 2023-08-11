// ignore_for_file: use_build_context_synchronously, empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

part 'register_event_state.dart';

class RegisterEventBloc extends Cubit<RegisterEventState> {
  RegisterEventBloc()
      : super(const RegisterEventState(
          name: "",
        )) {
    b();
  }

  Future<void> getLinkFromFirestore() async {
    String link = ""; // Biến để lưu trữ link được lấy từ Firestore

    // Thực hiện truy vấn Firestore để lấy dữ liệu từ collection "links"
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("links").get();

    // Kiểm tra nếu có ít nhất một document trong collection
    if (querySnapshot.docs.isNotEmpty) {
      // Lấy document đầu tiên
      QueryDocumentSnapshot documentSnapshot = querySnapshot.docs.first;

      // Kiểm tra nếu document có trường "link"
      link = documentSnapshot["link"];
    }

    emit(state.copyWith(name: link));
  }

  void b() async {
    await getLinkFromFirestore();
    a();
  }

  void a() async {
    try {
      await launchUrl(Uri.parse(state.name),
          mode: LaunchMode.externalApplication);
    } catch (e) {}
  }
}
