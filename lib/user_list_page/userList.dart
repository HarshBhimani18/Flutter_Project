import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/user.dart';
import 'package:flutter_app/user_add_page/addUser.dart';

class Userlist extends StatefulWidget {
  final List<User> users;
  final Function(List<User>) onUsersUpdated;

  const Userlist({required this.users, required this.onUsersUpdated, Key? key}) : super(key: key);

  @override
  _UserlistState createState() => _UserlistState();
}

class _UserlistState extends State<Userlist> {
  late List<User> userList;
  List<User> filteredUsers = [];
  String searchText = "";

  @override
  void initState() {
    super.initState();
    userList = List.from(widget.users);
    filteredUsers = List.from(userList);
  }

  void _filterUsers(String text) {
    setState(() {
      searchText = text;
      filteredUsers = userList.where((user) => user.name.toLowerCase().contains(text.toLowerCase())).toList();
    });
  }

  void _deleteUser(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete User"),
        content: const Text("Are you sure you want to delete this user?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                User deletedUser = filteredUsers[index];
                userList.remove(deletedUser);
                filteredUsers.removeAt(index);
                widget.onUsersUpdated(List.from(userList));
              });
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _editUser(int index) {
    User userToEdit = filteredUsers[index]; // Get the correct user

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddUserPage(
          user: userToEdit,
          onUserAdded: (updatedUser) {
            setState(() {
              int userIndex = userList.indexOf(userToEdit);
              if (userIndex != -1) {
                userList[userIndex] = updatedUser;
              }
              filteredUsers[index] = updatedUser;
              widget.onUsersUpdated(List.from(userList));
            });
          },
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.users == null ? "Add User" : "Edit User"),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterUsers,
              decoration: const InputDecoration(
                hintText: "Search by name",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: filteredUsers.isEmpty
                ? const Center(child: Text("No users found"))
                : ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      user.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text("Email: ${user.email}"),
                        const SizedBox(height: 4),
                        Text("Mobile: ${user.mobile}"),
                        const SizedBox(height: 4),
                        Text("Gender: ${user.gender}"),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 24),
                          onPressed: () => _editUser(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 24, color: Colors.red),
                          onPressed: () => _deleteUser(index),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(CupertinoIcons.heart, size: 24),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
