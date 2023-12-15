import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodmanagement/models/usersmodel.dart';
import 'package:http/http.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  Future<List<UsersModel>> showData() async {
    Response res =
        await get(Uri.parse("https://jsonplaceholder.typicode.com/users"));
    try {
      if (res.statusCode == 200) {
        List<dynamic> data = jsonDecode(res.body);
        List<UsersModel> userList =
            data.map((user) => UsersModel.fromJson(user)).toList();
        return userList;
      } else {
        throw 'failed to load data${res.statusCode}';
      }
    } catch (error) {
      throw 'failed to load data';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: showData(),
        builder: (context, AsyncSnapshot<List<UsersModel>> snapshot) {

          if(snapshot.connectionState==ConnectionState.waiting){

            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                UsersModel user = snapshot.data![index];

                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.verified_user,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(user.name!),
                    subtitle: Column(
                      children: [
                        Row(
                          children: [
                            Text(user.email!),
                          ],
                        ),
                        Row(
                          children: [
                            Text(user.phone!),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Text("No data Found");
          }
        },
      ),
    );
  }
}
