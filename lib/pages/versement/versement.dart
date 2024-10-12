
import 'package:boulangerie_mobile/fonctions/fonctions.dart';
import 'package:boulangerie_mobile/pages/boulangerie/liste.dart';
import 'package:boulangerie_mobile/pages/versement/liste.dart';
import 'package:boulangerie_mobile/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../constantes/constantes.dart';
import '../../controllers/auth.dart';
import '../../controllers/boulangerie.dart';
import '../../controllers/transaction.dart';
import '../../modèles/transaction.dart';
import '../../modèles/user.dart';
import '../../widgets/paiementCard.dart';

class Versement extends StatefulWidget {
  final int id;

  const Versement({super.key, required this.id});

  @override
  State<Versement> createState() => _VersementState();
}

class _VersementState extends State<Versement> {
  final TransactionController transactionController = Get.put(TransactionController());
  final AuthenticateController authenticateController = Get.put(AuthenticateController());
  final BoulangerieController boulangerieController = Get.put(BoulangerieController());
  User? user;

  @override
  void initState() {
    super.initState();
    // point exclamation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authenticateController.checkAccessToken();
      transactionController.fetchTransactionRecent();
      transactionController.fetchReliquat(widget.id);
      getUserData();
    });
  }

  Future<void> getUserData() async {
    var userData = GetStorage().read<Map<String, dynamic>>("user");
    if (userData != null) {
      setState(() {
        user = User.fromJson(userData); // Convert map to User object
      });
    }
  }

  String formatPrice(String montant) {
    final currencyFormatter = NumberFormat("#,##0 FCFA", "fr_FR");
    return currencyFormatter.format(double.parse(montant));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bodyBgColor,
      appBar: CAppBarReturn(
        title: "Faire un versement", 
        onTap: (){authenticateController.deconnectUser();}, 
        onPressed: (){
          Get.back();
          boulangerieController.fetchBoulangerie();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    height: 150,
                    // width: width(context),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Montant à payé",
                              style: bodyText
                            ),
                            Obx(() {
                              int reliquat = transactionController.reliquat.value;
                              return Text(
                                formatPrice(reliquat.toString()),
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.secondaryColor,
                                ),
                              );
                            }),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            int reliquat = transactionController.reliquat.value;
                            
                            if (reliquat <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Vous n\'avez pas de versement à effectuer.',
                                  ),
                                   backgroundColor: Colors.red,
                                ),
                              );
                              await transactionController.fetchTransactionRecent();

                            }else{
                              await transactionController.payment(reliquat, widget.id);
                            }
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.secondaryColor,
                          ),
                          child: const Text(
                            "Passer au paiement",
                            style: TextStyle(color: AppColors.primaryColor),
                          )
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Versements récents",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  TextButton(
                    onPressed: (){
                     route(context, const Historisque());
                    },
                    child: const Text(
                      "Voir tout",
                    )
                  ),
                ],
              ),
              Expanded(
                child: Obx(() {
                  if (transactionController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (transactionController.transactionsRecents.isEmpty) {
                    return const Center(child: Text('Vous n\'avez pas effectué de livraison aujourd\'hui',style: TextStyle(fontSize: 12,color: Colors.red),));
                  } else{
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: transactionController.transactionsRecents.length,
                      itemBuilder: (BuildContext context, int index) {
                        Transaction transactionsRecent = transactionController.transactionsRecents[index];
                        return ContainerCard(
                          name: transactionsRecent.name, 
                          montant: transactionsRecent.totalAmount.toString(), 
                          status:  transactionsRecent.typePayment, 
                          date:  transactionsRecent.createdAt
                        );
                      },
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

