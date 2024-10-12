import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final int quantite;
  final String imageUrl;
  const CategoryCard({
    super.key,
    required this.quantite,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Image.network(
            height: 50,
            imageUrl,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 10), // Espacement entre l'image et le texte
          Text(
            quantite.toString(),
            style: TextStyle(fontSize: 16), // Style du texte
          ),
        ],
      ),
      // child: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       Image.network(
      //         height: 50,
      //         // width: 70,
      //         imageUrl,
      //         fit: BoxFit.cover,
      //       ),
      //       Text(quantite.toString())
      //     ],
      //   ),
      // ),
    );
  }
}
