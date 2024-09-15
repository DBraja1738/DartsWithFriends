import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:darts_with_friends/userStats.dart';
import 'package:darts_with_friends/widgets/decorations.dart';

class UserNavbar extends StatefulWidget {
  const UserNavbar({super.key});

  @override
  State<UserNavbar> createState() => _UserNavbarState();
}

class _UserNavbarState extends State<UserNavbar> {
  List<String> users = [];
  void initState(){
    super.initState();
    _loadLoggedInPlayers();
  }

  Future<void> _logoutUser(String user) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? storedUsers = prefs.getStringList('emails') ?? [];

    if (storedUsers.contains(user)) {
      // Remove the user from SharedPreferences
      storedUsers.remove(user);
      await prefs.setStringList('emails', storedUsers);
    }

    setState(() {
      users = storedUsers;
    });


  }


  Future<List<String>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('emails') ?? [];
  }

  Future<void> _loadLoggedInPlayers() async {
    List<String> players = await getUsers();
    setState(() {
      users = players;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(accountName: Text(""), accountEmail: Text("Logged in users"), decoration: AppDecorations.drawerHeaderDecoration,),
          ...List.generate(users.length, (index){
            return ListTile(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> UserStatsScreen(email: users[index])));
              },
              title: Text(users[index]),
              trailing: IconButton(
                  onPressed: (){
                    _logoutUser(users[index]);
                  },
                  icon: Icon(Icons.logout)),
            );
          }),
        ],
      ),
    );
  }
}
