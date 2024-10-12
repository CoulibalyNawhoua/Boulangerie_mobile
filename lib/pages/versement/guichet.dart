import 'dart:async';

import 'package:boulangerie_mobile/pages/versement/versement.dart';
import 'package:boulangerie_mobile/widgets/root.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../constantes/constantes.dart';
import '../../controllers/transaction.dart';

class Guichet extends StatefulWidget {
  final String url;
  final String transactionId;

  const Guichet({super.key, required this.url, required this.transactionId});

  @override
  State<Guichet> createState() => _GuichetState();
}

class _GuichetState extends State<Guichet> {
  late WebViewController controller;
  final TransactionController transactionController = Get.put(TransactionController());

  Future<void> onClearCookies(BuildContext context) async {
    await WebViewCookieManager().clearCookies();
  }

  Future<void> onClearCache(BuildContext context) async {
    await WebViewController().clearCache();
    await WebViewController().clearLocalStorage();
  }

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
      transactionController.checkPayment(widget.transactionId);
  }

  @override
  Widget build(BuildContext context) {
    onClearCookies(context);
    onClearCache(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          "Guichet paiement",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            Get.to(() => const Root());
          },
        ),
        // iconTheme: const IconThemeData(
        //   color: Colors.white,
        // ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
