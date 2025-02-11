import 'package:flutter/material.dart';
import 'package:flutter_app/about_page/aboutUs.dart';
import 'package:flutter_app/user.dart';
import 'package:flutter_app/user_add_page/addUser.dart';
import 'package:flutter_app/user_favourite_list/userFavourite.dart';
import 'package:flutter_app/user_list_page/userList.dart';
import 'package:google_fonts/google_fonts.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  List<User> users = []; // Store the list of users

  void addUser(User user) {
    setState(() {
      users.add(user);
    });
  }

  void _updateUsersList(List<User> updatedUsers) {
    setState(() {
      users = updatedUsers;
    });
  }

  Widget MenuButtonView(String label, IconData iconName, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pink,
        shadowColor: Colors.pinkAccent,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconName, size: 50, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.robotoSlab(color: Colors.white, fontSize: 20),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text(
          "Matrimonial",
          style: GoogleFonts.pacifico(fontSize: 33,color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          children: [
            MenuButtonView("Add User", Icons.person_add, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddUserPage(onUserAdded: addUser),
                ),
              );
            }),
            MenuButtonView("User List", Icons.list, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Userlist(users: users, onUsersUpdated: _updateUsersList),
                ),
              );
            }),
            MenuButtonView("Favorites", Icons.favorite, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Userfavourite()),
              );            }),
            MenuButtonView("About Us", Icons.info, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage(

                )),
              );
            }),

          ],
        ),
      ),
    );
  }
}
