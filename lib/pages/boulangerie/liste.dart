import 'package:boulangerie_mobile/constantes/constantes.dart';
import 'package:boulangerie_mobile/pages/versement/versement.dart';
import 'package:boulangerie_mobile/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../controllers/auth.dart';
import '../../controllers/boulangerie.dart';
import '../../fonctions/fonctions.dart';
import '../../modèles/user.dart';

class ListBoulangeriePage extends StatefulWidget {
  const ListBoulangeriePage({super.key});

  @override
  State<ListBoulangeriePage> createState() => _ListBoulangeriePageState();
}

class _ListBoulangeriePageState extends State<ListBoulangeriePage> {
  final AuthenticateController authenticateController = Get.put(AuthenticateController());
  final BoulangerieController boulangerieController = Get.put(BoulangerieController());
  final TextEditingController searchController = TextEditingController();
  User? user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authenticateController.checkAccessToken();
      boulangerieController.fetchBoulangerie();
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
        title: "Mes boulangeries", 
        onPressed: (){authenticateController.deconnectUser();}
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildResearch(),
            const SizedBox(height: 20.0,),
            Expanded(
              child: Obx(() {
                if (boulangerieController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (boulangerieController.filteredBoulangeries.isEmpty) {
                  return const Center(child: Text('Aucune boulangérie trouvée.',style: TextStyle(color: Colors.red),));
                } else {
                  return RefreshIndicator(
                    onRefresh: () async{boulangerieController.fetchBoulangerie();},
                    child: ListView.builder(
                      itemCount: boulangerieController.filteredBoulangeries.length,
                      itemBuilder: (context, index) {
                        final boulangerie = boulangerieController.filteredBoulangeries[index];
                        return BoulangerieItem(
                          name: boulangerie.name, 
                          phone: boulangerie.phone, 
                          adresse: boulangerie.address, 
                          dette: boulangerie.dette.toString(), 
                          onPressed: (){Get.to(Versement(id: boulangerie.id,));}
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
                  boulangerieController.filterBoulangeries(value);  // Filtrer les boulangeries
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BoulangerieItem extends StatelessWidget {
  final String name;
  final String phone;
  final String adresse;
  final String dette;
  final VoidCallback onPressed;

  const BoulangerieItem ({
    super.key,
    required this.name,
    required this.phone,
    required this.adresse,
    required this.dette,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text(name),
                      subtitle: Text(adresse,style: const TextStyle(fontSize: 10.0),),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text(formatPrice(dette),style: const TextStyle(color: Colors.red),),
                      subtitle: Text(phone,style: const TextStyle(fontSize: 10.0,)),
                    ),
                  ),
                  // const Icon(Icons.navigate_next),
                ],
              ),
              const Divider(height: 1, thickness: 1,),
            ],
          ),
      ),
    );
  }
}


