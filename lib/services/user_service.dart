import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/employe_model.dart';
import '../model/user_model.dart';

class UserService {
  var firebaseUser = FirebaseAuth.instance.currentUser;
  final fireStore = FirebaseFirestore.instance;

  Future<String> saveToFirebase(UserModel userModel) async {
    final docTodo = fireStore
        .collection("users")
        .doc(firebaseUser!.uid)
        .collection("userInfo");
    await docTodo.add(userModel.toJson());
    return docTodo.id;
  }

  Future<String> saveAdminToFirebase(UserModel userModel) async {
    final docTodo = fireStore
        .collection("admin")
        .doc(firebaseUser!.uid)
        .collection("adminInfo");
    await docTodo.add(userModel.toJson());
    return docTodo.id;
  }

  Future<String> saveCustomerToFirebase(List<EmployeModel> customerList) async {
    final docTodo = fireStore
        .collection("users")
        .doc(firebaseUser!.uid)
        .collection("customber_Followed_By");
    for (var item in customerList) {
      await docTodo.add(item.toJson());
    }
    return docTodo.id;
  }

  getCustomers(String email) {
    var data = fireStore
        .collection("users")
        .doc(firebaseUser!.uid)
        .collection('customber_Followed_By')
        .snapshots();

    return data;
  }

  Future<Map<String, dynamic>> getUserDataByEmail(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    return querySnapshot.docs[0].data() as Map<String, dynamic>;
  }

  Future<bool> isEmailExists(String nameToCheck) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('admin')
          .doc(firebaseUser!.uid)
          .collection("adminInfo")
          .where('email', isEqualTo: nameToCheck)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking name existence: $e');
      return false;
    }
  }

  Future<void> deleteUserByEmail() async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('admin')
          .doc(firebaseUser!.uid)
          .collection("adminInfo")
          .where('email', isEqualTo: "testwtsm@gmail.com")
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await FirebaseFirestore.instance
            .collection('admin')
            .doc(firebaseUser!.uid)
            .collection("adminInfo")
            .doc(doc.id)
            .delete();
      }

      print('User with email deleted successfully.');
    } catch (e) {
      print('Error deleting user: $e');
    }
  }

//   Future deleteTodos(DocumentSnapshot snapshot) {
//     var docid = fireStore
//         .collection("users")
//         .doc(firebaseUser!.uid)
//         .collection('usereInfo')
//         .doc(snapshot.id)
//         .delete();
//     print(docid);
//     return docid;
//   }

//   static Future updateTodo(UserModel userModel) async {
//     //Todo todo =Todo(createdTime: DateTime.now(),title: "test",description: "desc",isDone: true);
//     final updateId = FirebaseFirestore.instance
//         .collection("users")
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .collection('userInfo')
//         .doc(todo.id)
//         .update({"title":todo.title});

//   }
}
