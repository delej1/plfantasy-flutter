import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pl_fantasy_online/models/bank_list_model.dart';

late String token;

class BankListController extends GetxController {
  var isLoading = false.obs;
  BankListModel? _bankListModel;

  BankListModel? get bankListModel => _bankListModel;

  Future getToken() async {
    var collection = FirebaseFirestore.instance.collection('paystack');
    var docSnapshot = await collection.doc('details').get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      try {
        token = data?['secret_key'];
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    getToken().then((_) => fetchData());
  }

  fetchData() async {
    try {
      isLoading(true);
      http.Response response = await http
          .get(Uri.tryParse("https://api.paystack.co/bank")!, headers: {
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        _bankListModel = BankListModel.fromJson(result);
      } else {
        debugPrint("Error fetching data");
      }
    } catch (e) {
      debugPrint("Error $e getting while fetching data");
    } finally {
      isLoading(false);
    }
  }
}
