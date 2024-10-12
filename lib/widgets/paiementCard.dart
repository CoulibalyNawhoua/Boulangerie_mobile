import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../fonctions/fonctions.dart';

class ContainerCard extends StatelessWidget {

  final String name;
  final String montant;
  final int status;
  final DateTime date;

  const ContainerCard({
    super.key,
    required this.name,
    required this.montant,
    required this.status,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {

    String statusText;
    Color statusColor;
    if (status == 0) {
      statusText = "CASH";
      statusColor = Colors.red;
    }else{
      statusText = "E-PAYMENT";
      statusColor = Colors.green;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5)
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListTile(
                  title: Text(name),
                  subtitle: Text(DateFormat('dd MMMM yyyy','fr_FR').format(date),style: TextStyle(fontSize: 10.0)),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text(formatPrice(montant),style: const TextStyle(color: Colors.red),),
                  subtitle: Text(statusText,style: TextStyle(fontSize: 10.0,color: statusColor)),
                ),
              ),
              // const Icon(Icons.navigate_next),
            ],
          ),
          const Divider(height: 1, thickness: 1,),
        ],
      ),
    );
  }
}
