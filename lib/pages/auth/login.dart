
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../constantes/constantes.dart';
import '../../controllers/auth.dart';
import '../../fonctions/fonctions.dart';
import '../../widgets/backgroud_image.dart';
import '../../widgets/button.dart';
import '../../widgets/password_input.dart';
import '../../widgets/root.dart';
import '../../widgets/text_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthenticateController authenticateController = Get.put(AuthenticateController());
  final  phoneController = TextEditingController();
  final  passwordController = TextEditingController();
  bool isObscurityText = true;
  final token = GetStorage().read("access_token");

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final token = GetStorage().read("access_token");
      if (token != null) {
        Get.offAll(() => const Root());
      }
    });
  }

  void submit() async {
    if (_formKey.currentState!.validate()) {
      String phoneNumber = phoneController.text;
      String password = passwordController.text;
      await authenticateController.login(phoneNumber: phoneNumber, password: password);
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroungImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(child: SingleChildScrollView(child: _page())),
        ),
      ],
    );
    // return  Stack(
    //   children: [
    //     const BackgroungImage(),
    //     Scaffold(
    //       backgroundColor: Colors.transparent,
    //       body: SingleChildScrollView(
    //         child: Padding(
    //           padding: EdgeInsets.symmetric(vertical: height(context) * 0.1, horizontal: width(context) * 0.05),
    //           child: Center(
    //             child: SafeArea(
    //               child: Column(
    //                 // mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                 children: [
    //                   const Text(
    //                     "CONNEXION",
    //                     style: heading,
    //                   ),
    //                   Image.asset(
    //                     "assets/images/logo.png",
    //                     width: 120,
    //                   ),
    //                   // const SizedBox(height: 100,),
    //                   Container(
    //                     margin: EdgeInsets.only(top: height(context)*0.1),
    //                     child: Form(
    //                       key: _formKey,
    //                       child: Column(
    //                         children: [
    //                           TextInput(
    //                             controller: phoneController, 
    //                             inputType: TextInputType.phone, 
    //                             hint: "Entrez votre numero de téléphone", 
    //                             icon: Icons.phone,
    //                             validator: (value) {
    //                               if (value == null || value.isEmpty) {
    //                                 return 'Veuillez entrer votre numéro de téléphone';
    //                               }
    //                               return null;
    //                             },
    //                           ),
    //                           PasswordInput(
    //                             controller: passwordController,
    //                             inputType: TextInputType.number, 
    //                             hint: "Entrez votre mot de passe", 
    //                             icon: Icons.lock,
    //                             obscureText: isObscurityText,
    //                             suffixIcon: Icon(
    //                               isObscurityText
    //                                 ? Icons.visibility_off
    //                                 : Icons.visibility,
    //                               color: Colors.white,
    //                               size: 16,
    //                             ),
    //                             onPressed: () {
    //                               setState(() {
    //                                 isObscurityText = !isObscurityText;
    //                               });
    //                             },
    //                             validator: (value) {
    //                               if (value == null || value.isEmpty) {
    //                                 return 'Veuillez saisir un mot de passe';
    //                               }
    //                               return null;
    //                             },
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   ),
    //                   Padding(
    //                     padding: EdgeInsets.only(top: height(context)*0.1),
    //                     child: Obx(() {
    //                       return CButton(
    //                         title: "CONNEXION",
    //                         isLoading: authenticateController.isLoading.value,
    //                         onPressed: () async {
    //                           submit();
    //                         },
    //                       );
    //                     }),
    //                   ),
                
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //     )
    //   ],
    // );
  }
    Widget _page() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLogo(),
            const SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextInput(
                    inputType: TextInputType.phone, 
                    hint: "Entrez votre numero de téléphone", 
                    icon: Icons.phone, 
                    controller: phoneController, 
                    validator: validatePhone,
                  ),
                  const SizedBox(height: 20),
                  PasswordInput(
                    inputType: TextInputType.number, 
                    hint: "Entrez votre mot de passe", 
                    icon: Icons.lock, 
                    controller: passwordController, 
                    validator: validatePassword
                  ),
                  const SizedBox(height: 50),
                  Obx(() {
                    return CButton(
                      title: "CONNEXION",
                      isLoading: authenticateController.isLoading.value,
                      onPressed: () async {
                        submit();
                      },
                    );
                  }),
                  
                ],
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return SizedBox(
      width: width(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image(
            image: AssetImage("assets/images/logo.png"),
            width: 150,
          ),
          Text(
            "LIVRAISON",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
              letterSpacing: 2
            ),
          ),
          // _header("Veuillez vous connecter avec vos informations"),
        ],
      ),
    );
  }
}

