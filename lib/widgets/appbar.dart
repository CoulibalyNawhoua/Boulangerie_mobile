import 'package:flutter/material.dart';

import '../constantes/constantes.dart';
import '../fonctions/fonctions.dart';

class CAppBarHome extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final VoidCallback onPressed;

  const CAppBarHome({
    super.key,
    required this.name,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {    
    return AppBar(
      backgroundColor: Colors.white,
      title: CircleAvatar(
        backgroundColor: AppColors.primaryColor,
        child: Text(
          getInitials(name),
          style: const TextStyle(
            color: AppColors.secondaryColor,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.logout,
            color: AppColors.primaryColor,
          ),
          onPressed: onPressed,
          
        ),
      ],
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}



class CAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String title;
  final VoidCallback onPressed;

  const CAppBar({
    super.key,
    required this.name,
    required this.title,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.secondaryColor,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
        backgroundColor: AppColors.primaryColor,
        child: Text(
          getInitials(name),
          style: const TextStyle(
            color: AppColors.secondaryColor,
          ),
        ),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold
        ),
      ),
      centerTitle: true,
      actions: [
      IconButton(
        onPressed: onPressed,
        icon: const Icon(
          Icons.logout,
          color: AppColors.primaryColor,
        )
      ),
      ],
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CAppBarReturn extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onTap;
  final VoidCallback onPressed;

  const CAppBarReturn({
    super.key,
    required this.title,
    required this.onTap,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.secondaryColor,
      leading: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back,color: AppColors.primaryColor,),
            onPressed: onPressed,
          ),
        ],
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: onTap,
          icon: const Icon(
            Icons.logout,
            color: AppColors.primaryColor,
          )
        ),
      ],
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

