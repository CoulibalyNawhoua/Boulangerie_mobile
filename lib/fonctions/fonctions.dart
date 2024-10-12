import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

width(context) => MediaQuery.of(context).size.width;
height(context) => MediaQuery.of(context).size.height;

  String formatPrice(String montant) {
    final currencyFormatter = NumberFormat("#,##0 fcfa", "fr_FR");
    return currencyFormatter.format(double.parse(montant));
  }

  route(context, widget, {bool close = false}) => close
    ? Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => widget), (route) => false)
    : Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => widget),
      );
      
//initail des noms de l'utilisateur connecté
String getInitials(String name) {
  // Divise le nom en parties et prend les deux premières lettres
  List<String> nameParts = name.split(' ');
  if (nameParts.length >= 2) {
    return nameParts[0][0] + nameParts[1][0]; // Combine les premières lettres des deux parties
  } else if (nameParts.isNotEmpty) {
    return nameParts[0].substring(0, 2); // Si une seule partie, prend les deux premières lettres
  }
  return '';
}
String? validatePhone(String? value) {
  if (value == null || value.isEmpty) {
    return 'Veuillez entrer votre numéro de téléphone';
  } else if (value.length != 10) {
    return 'Le numéro de téléphone doit contenir 10 chiffres';
  }
  return null;
}

//fonction validation champ password
String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Veuillez saisir un mot de passe';
  }
  return null;
}