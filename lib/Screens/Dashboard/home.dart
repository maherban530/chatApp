import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Core/route_path.dart';
import '../../Models/user_model.dart';
import '../../Provider/auth_provider.dart';
import '../../Widgets/utils.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    ThemeData applicationTheme = Theme.of(context);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.amber,
          actions: [
            TextButton.icon(
              style: applicationTheme.textButtonTheme.style,
              onPressed: () {
                final provider =
                    Provider.of<AuthProvider>(context, listen: false);
                provider.logOut();
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.signup,
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text("LogOut"),
            ),
          ],
        ),
        body: StreamProvider(
          create: (BuildContext context) =>
              Provider.of<AuthProvider>(context, listen: false).getUsersData(),
          initialData: null,
          child: const UserList(),
        ));
  }
}

class UserList extends StatelessWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context) {
    List<Users>? userList = Provider.of<List<Users>?>(context);
    var provider = Provider.of<AuthProvider>(context, listen: false);
    return userList == null
        ? const Center(child: CircularProgressIndicator())
        : userList.isEmpty
            ? const Center(child: Text("Users Not Found"))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: userList.length,
                itemBuilder: (_, int index) {
                  var users = userList[index];
                  return
                      //  provider.currentUserId == users.uid
                      //     ? Container()
                      //     :
                      ListTile(
                    leading: Icon(provider.currentUserId == users.uid
                        ? Icons.account_circle
                        : Icons.account_circle_outlined),
                    title: Text(provider.currentUserId == users.uid
                        ? "You"
                        : users.name.toString()),
                    subtitle: Text(users.email.toString()),
                    onTap: () {
                      if (provider.currentUserId == users.uid) {
                        buildShowSnackBar(
                            context, "You can't send message to yourself");
                      } else {
                        provider.usersClickListener(users, context);
                      }
                    },
                  );
                });
  }
}
