import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wings_advanced_tasl/main.dart';
import 'package:wings_advanced_tasl/model/employe_model.dart';

class AdminDisplayList extends StatefulWidget {
  const AdminDisplayList({super.key, required this.userId});
  final String userId;
  @override
  State<AdminDisplayList> createState() => _AdminDisplayListState();
}

class _AdminDisplayListState extends State<AdminDisplayList> {
  @override
  void initState() {
    userService.getCustomers(widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details Screens"),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(widget.userId)
                        .collection('customber_Followed_By')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Text('No user data available.');
                      }
                      List<EmployeModel> employeModel =
                          snapshot.data!.docs.map((event) {
                        return EmployeModel.fromDocumentSnapshot(event);
                      }).toList();
                      return ListView.builder(
                          itemCount: employeModel.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(employeModel[index].login),
                              subtitle: Text(employeModel[index].nodeId),
                            );
                          });
                    }))
          ]),
    );
  }
}
