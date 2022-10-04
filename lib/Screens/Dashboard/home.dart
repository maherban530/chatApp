import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Core/route_path.dart';
import '../../Provider/auth_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    provider.getUsersData(context);
    // print(usersList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Center(
            child: InkWell(
                onTap: () {
                  final provider =
                      Provider.of<AuthProvider>(context, listen: false);
                  provider.logOut();
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.login,
                  );
                },
                child: Container(
                    color: Colors.red, height: 70, child: Text("LogOut"))),
          ),
          Consumer<AuthProvider>(builder: (_, data, child) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: data.userList.length,
                itemBuilder: (context, index) {
                  var userData = data.userList[index];
                  return ListTile(
                    title: Text(userData.name.toString()),
                  );
                });
          })
        ],
      ),
    );
  }
}
