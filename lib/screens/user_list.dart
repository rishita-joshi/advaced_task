import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wings_advanced_tasl/main.dart';
import 'package:wings_advanced_tasl/screens/admin_employe_display.dart';
import '../model/user_model.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                userService.deleteUserByEmail();
              },
              icon: Icon(Icons.logout_outlined))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collectionGroup('userInfo')
                      .snapshots(),
                  builder: (context, snapshot) {
                    print("--->");
                    print(snapshot.data!.docs.toString());

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Text('No user data available.');
                    }
                    List<UserModel> userList = snapshot.data!.docs.map((event) {
                      return UserModel.fromDocumentSnapshot(event);
                    }).toList();
                    return ListView.builder(
                        itemCount: userList.length,
                        itemBuilder: (context, index) {
                          return Text("data");
                          //  return Card(
                          //    elevation: 4,
                          //    child: ListTile(
                          //      onTap: () => Navigator.push(
                          //        context,
                          //        MaterialPageRoute(
                          //            builder: (context) => AdminDisplayList(
                          //                userId: userList[index].userId)),
                          //      ),
                          //      title: Text(userList[index].email),
                          //      subtitle: Text(userList[index].userName),
                          //    ),
                          //  );
                        });
                  }))
        ]),
      ),
    );
  }
}
