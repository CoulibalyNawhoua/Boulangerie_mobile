import 'package:boulangerie_mobile/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../constantes/constantes.dart';
import '../../controllers/auth.dart';
import '../../controllers/transaction.dart';
import '../../modèles/transaction.dart';
import '../../modèles/user.dart';
import '../../widgets/paiementCard.dart';

class Historisque extends StatefulWidget {
  const Historisque({super.key});

  @override
  State<Historisque> createState() => _HistorisqueState();
}

class _HistorisqueState extends State<Historisque> {
  final TransactionController transactionController = Get.put(TransactionController());
  final AuthenticateController authenticateController = Get.put(AuthenticateController());
  final TextEditingController searchController = TextEditingController();
  User? user;

  

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authenticateController.checkAccessToken();
      transactionController.fetchTransaction();
      
      getUserData();
    });
  }

  Future<void> getUserData() async {
    var userData = GetStorage().read<Map<String, dynamic>>("user");
    if (userData != null) {
      setState(() {
        user = User.fromJson(userData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bodyBgColor,
      appBar: CAppBarReturn(
        title: "Mes Versements", 
        onTap: (){authenticateController.deconnectUser();}, 
        onPressed: (){
          Get.back();
          transactionController.fetchTransaction();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildResearch(),
            const SizedBox(height: 20,),
            Expanded(
              child: Obx(() {
                if (transactionController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (transactionController.filteredTransactions.isEmpty) {
                  return const Center(child: Text('Aucun versement trouvé.',style: TextStyle(fontSize: 12,color: Colors.red),));
                } else{
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: transactionController.filteredTransactions.length,
                    itemBuilder: (BuildContext context, int index) {
                      Transaction transaction = transactionController.filteredTransactions[index];
                      return ContainerCard(
                        name: transaction.name, 
                        montant: transaction.totalAmount.toString(), 
                        status:  transaction.typePayment, 
                        date:  transaction.createdAt
                      );
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResearch() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            const Icon(Icons.search),
            const SizedBox(width: 8.0),
            Expanded(
              child: TextField(
                controller: searchController,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                  hintText: 'Recherche',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  transactionController.filterTransactions(value); 
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}