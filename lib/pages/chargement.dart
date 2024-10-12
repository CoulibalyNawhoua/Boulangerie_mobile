import 'package:boulangerie_mobile/pages/auth/login.dart';
import 'package:flutter/material.dart';

import '../widgets/chargement_text_animation.dart';

class Chargement extends StatefulWidget {
  const Chargement({super.key});

  @override
  State<Chargement> createState() => _ChargementState();
}

class _ChargementState extends State<Chargement> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Image(image: AssetImage("assets/images/logo.png")),
            SizedBox(height: 50,),
           ChargementTextAnimation(),
          ],
        ),
      ),
    );
  }
}
