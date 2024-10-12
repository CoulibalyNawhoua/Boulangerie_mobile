

import 'package:boulangerie_mobile/controllers/produit.dart';
import 'package:boulangerie_mobile/widgets/appbar.dart';
import 'package:boulangerie_mobile/widgets/card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../constantes/api.dart';
import '../constantes/constantes.dart';
import '../controllers/auth.dart';
import '../modèles/produit.dart';
import '../modèles/user.dart';
import '../widgets/category_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ProductController productController = Get.put(ProductController());
  final AuthenticateController authenticateController = Get.put(AuthenticateController());
  User? user;
  Backhouse? backhouse;

  @override
  void initState() {
    super.initState();
    setState(() {
      authenticateController.checkAccessToken();
      productController.fetchProduct();
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
    return  Scaffold(
      backgroundColor: AppColors.bodyBgColor,
      appBar: CAppBarHome(
        name:  user != null ? '${user!.firstName} ${user!.lastName}' : "John Doe",
        onPressed: (){authenticateController.deconnectUser();}
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
                    // height: height(context)*0.2,
                    // width: width(context),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        "Merci d'apporter notre pain croustillant directement aux portes de nos clients !",
                        style: TextStyle(color: AppColors.secondaryColor),
                      ),
                      
                      trailing: Image.asset(
                        'assets/images/image6.png',
                      )
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30,),
              Text(
                "Bilan de la journée",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 15,),
              SizedBox(
                height: 50,
                child: Obx(() {
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: productController.products.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 10),
                    itemBuilder: (BuildContext context, int index) {
                      Product product = productController.products[index];
                      return CategoryCard(
                        quantite: product.totalQuantity,
                        imageUrl: "${Api.urlImage}${product.image}",
                      );
                    },
                  );
                }),
              ),
              const SizedBox(height: 20.0,),
              Text(
                "Livraison journalière",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 20.0,),
              Expanded(
                child: Obx(() {
                  if (productController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (productController.products.isEmpty) {
                    return const Center(child: Text('Vous n\'avez pas effectué de livraison aujourd\'hui',style: TextStyle(fontSize: 12,color: Colors.red),));
                  } else{
                    return RefreshIndicator(
                      onRefresh: () async{productController.fetchProduct();},
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: productController.products.length,
                        itemBuilder: (BuildContext context, int index) {
                          Product product = productController.products[index];
                          return card(
                            title: product.name, 
                            quantite: product.totalQuantity.toString(), 
                            imageUrl: "${Api.urlImage}${product.image}"
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
      ),
    );
  }
}

