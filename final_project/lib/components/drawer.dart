import 'package:final_project/components/my_list_tile.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget{
  final void Function()? onProfileTap;
  final void Function()? onSignOut;
  const MyDrawer({super.key, required this.onProfileTap, required this.onSignOut});

  @override
  Widget build(BuildContext context){
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        children: [
          const DrawerHeader(child: Icon(Icons.person, color: Colors.white, size: 60),),
          MyListTile(icon: Icons.home, text: 'H O M E', onTap: () => Navigator.pop(context),),
          MyListTile(icon: Icons.person, text: 'P R O F I L E', onTap: onProfileTap),
          MyListTile(icon: Icons.logout, text: 'L O G O U T', onTap: onSignOut),
        ],
      ),
    );
  }
}
