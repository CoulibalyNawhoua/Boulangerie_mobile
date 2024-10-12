import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../fonctions/fonctions.dart';

class CardHistorique extends StatelessWidget {

  final String title;
  final DateTime date;
  final String quantite;
  final String imageUrl;

  const CardHistorique({
    super.key,
    required this.title,
    required this.date,
    required this.quantite,
    required this.imageUrl,
  });
  

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5)
      ),
      child: Column(
        children: [
          ListTile(
            leading: Image.network(
              height: 50,
              imageUrl,
              fit: BoxFit.cover,
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Row(
              children: [
                const Text(
                  "Quantité: ",
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
                Text(
                  quantite,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
            trailing: Text(
              DateFormat('dd-MM-yyyy: HH\'h\'mm','fr_FR').format(date),
              style: TextStyle(fontSize: 10,),
            )
          ),
          const Divider(height: 1, thickness: 1,),
        ],
      )
    );
  }
}
