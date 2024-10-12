
import 'package:flutter/material.dart';


class card extends StatelessWidget {

  final String title;
  final String quantite;
  final String imageUrl;

  const card({
    super.key,
    required this.title,
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
           
          ),
          const Divider(height: 1, thickness: 1,),
        ],
      )
    );
  }
}
