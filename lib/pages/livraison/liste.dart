import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../constantes/api.dart';
import '../../constantes/constantes.dart';
import '../../controllers/auth.dart';
import '../../controllers/livraison.dart';
import '../../modèles/historique.dart';
import '../../modèles/user.dart';
import '../../widgets/appbar.dart';
import '../../widgets/historiesCard.dart';

class Livraison extends StatefulWidget {
  const Livraison({super.key});

  @override
  State<Livraison> createState() => _LivraisonState();
}

class _LivraisonState extends State<Livraison> {
  final LivraisonController livraisonController = Get.put(LivraisonController());
  final AuthenticateController authenticateController = Get.put(AuthenticateController());
  final TextEditingController searchController = TextEditingController();
  User? user;

  @override
  void initState() {
    super.initState();
    setState(() {
      authenticateController.checkAccessToken();
      livraisonController.fetchLivraison();
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
        title: "Mes Livraisons", 
        onPressed: (){authenticateController.deconnectUser();}
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildResearch(),
            const SizedBox(height: 20,),
            Expanded(
              child: Obx(() {
                if (livraisonController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (livraisonController.filteredLivraisonProducts.isEmpty) {
                  return const Center(child: Text('Aucune livraison trouvée.',style: TextStyle(fontSize: 12,color: Colors.red),));
                } else{
                  return RefreshIndicator(
                    onRefresh: () async{livraisonController.fetchLivraison();},
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: livraisonController.filteredLivraisonProducts.length,
                      itemBuilder: (BuildContext context, int index) {
                        HistorieProduct livraisonProduct = livraisonController.filteredLivraisonProducts[index];
                        return CardHistorique(
                          title: livraisonProduct.name, 
                          quantite: livraisonProduct.quantity.toString(), 
                          date: livraisonProduct.createdAt,
                          imageUrl: "${Api.urlImage}${livraisonProduct.image}"
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
                  livraisonController.filterLivraisonProducts(value); 
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


