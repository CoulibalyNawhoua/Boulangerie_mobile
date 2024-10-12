import 'package:boulangerie_mobile/pages/boulangerie/liste.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../constantes/constantes.dart';
import '../pages/home.dart';
import '../pages/livraison/liste.dart';
import '../pages/retour/liste.dart';
import '../pages/versement/versement.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int currentIndex = 0;

  void goToPage(index) {
    setState(() {
      currentIndex = index;
    });
  }
  final List _pages = [
    const Home(),
    const Livraison(),
    const Retour(),
    const ListBoulangeriePage(),
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _pages[currentIndex],
      bottomNavigationBar: Container(
        color: AppColors.secondaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
              gap: 7,
              backgroundColor: AppColors.secondaryColor,
              color: Colors.black,
              activeColor: Colors.white,
              tabBackgroundColor: AppColors.primaryColor,
              padding: const EdgeInsets.all(14),
              selectedIndex: currentIndex,
              onTabChange: (index) => goToPage(index),
              tabs: const [
                GButton(icon: Icons.home, text: "Accueil",),
                GButton(icon: Icons.delivery_dining, text: "Livraison"),
                GButton(icon: Icons.settings_backup_restore, text: "Retour"),
                GButton(icon: Icons.account_balance_wallet, text: "Versement"),
              ]),
        ),
      ),
    );
  }
}


//   Widget getFooter() {
//     // List<Map<String, dynamic>> items = [
//     //   {
//     //     "icon": Icons.home,
//     //     "text": "Home",
//     //   },
//     //   {
//     //     "icon": Icons.dashboard,
//     //     "text": "Dashboard",
//     //   },
//     //   {
//     //     "icon": Icons.shopping_cart,
//     //     "text": "Cart",
//     //   },
//     //   {
//     //     "icon": Icons.settings,
//     //     "text": "Settings",
//     //   },
//     // ];
//     final List items = [
//       {'icon': Icons.home, 'text': 'Accueil'},
//       {'icon': Icons.delivery_dining, 'text': 'Livraison'},
//       {'icon': Icons.settings_backup_restore, 'text': 'Retours'},
//       {'icon': Icons.account_balance_wallet, 'text': 'Versement'},
//     ];
//     return Container(
//       width: width(context),
//       height: 80,
//       decoration: BoxDecoration(
//         // color: AppColors.primaryColor,
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.white.withOpacity(0.2),
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: List.generate(
//           items.length,
//           (index) {
//             return InkWell(
//               onTap: () {
//                 setState(() {
//                   pageIndex = index;
//                 });
//               },
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 500),
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 10.0),
//                   child: Column(
//                     children: [
//                       Icon(
//                         items[index]["icon"],
//                         size: 30,
//                         color: pageIndex == index
//                             ? AppColors.primaryColor// Changer la couleur selon votre besoin
//                             : Colors.black,
//                       ),
//                       Text(
//                         items[index]["text"],
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: pageIndex == index
//                               ? AppColors.primaryColor// Changer la couleur selon votre besoin
//                               : Colors.black,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
