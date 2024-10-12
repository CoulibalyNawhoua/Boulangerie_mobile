import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../constantes/api.dart';
import '../../constantes/constantes.dart';
import '../../controllers/auth.dart';
import '../../controllers/retour.dart';
import '../../modèles/historique.dart';
import '../../modèles/user.dart';
import '../../widgets/appbar.dart';
import '../../widgets/historiesCard.dart';

class Retour extends StatefulWidget {
  const Retour({super.key});

  @override
  State<Retour> createState() => _RetourState();
}

class _RetourState extends State<Retour> {
  final RetourController retourController = Get.put(RetourController());
  final AuthenticateController authenticateController = Get.put(AuthenticateController());
  final TextEditingController searchController = TextEditingController();
  User? user;

  @override
  void initState() {
    super.initState();
    setState(() {
      authenticateController.checkAccessToken();
      retourController.fetchRetour();
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
      appBar: CAppBar(
        name:  user != null ? '${user!.firstName} ${user!.lastName}' : "John Doe",
        title: "Mes Retours", 
        onPressed: (){authenticateController.deconnectUser();}
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
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
                          retourController.searchQuery.value = value;
                          retourController.fetchRetour();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Expanded(
              child: Obx(() {
                if (retourController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (retourController.retourProducts.isEmpty) {
                  return const Center(child: Text('Vous n\'avez pas effectué de livraison aujourd\'hui',style: TextStyle(fontSize: 12,color: Colors.red),));
                } else{
                  return RefreshIndicator(
                    onRefresh: () async{retourController.fetchRetour();},
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: retourController.retourProducts.length,
                      itemBuilder: (BuildContext context, int index) {
                        HistorieProduct retourProduct = retourController.retourProducts[index];
                        return CardHistorique(
                          title: retourProduct.name, 
                          quantite: retourProduct.quantity.toString(), 
                          date: retourProduct.createdAt,
                          imageUrl: "${Api.urlImage}${retourProduct.image}"
                        );
                      },
                    ),
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}