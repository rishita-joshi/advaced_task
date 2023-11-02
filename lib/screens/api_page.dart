import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:wings_advanced_tasl/api/http_config.dart';
import 'package:wings_advanced_tasl/main.dart';
import 'package:wings_advanced_tasl/model/employe_model.dart';

import '../notification/awesome_notification.dart';

class APIPage extends StatefulWidget {
  const APIPage({super.key});
  @override
  State<APIPage> createState() => _APIPageState();
}

class _APIPageState extends State<APIPage> {
  List<EmployeModel> employeModel = [];
  List<EmployeModel> filterEmployeList = [];
  List<EmployeModel> duplicateList = [];
  List<EmployeModel> followEmployeList = [];
  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  int per_page = 10;
  int since = 0;
  bool isLoading = false;
  bool isLongPress = false;
  int followPeopleCount = 0;
  @override
  void initState() {
    super.initState();
    getAdminToken();
    getMoreData();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        getMoreData();
      }
    });
  }

  followCustomber() {
    userService.saveCustomerToFirebase(followEmployeList);
    sendNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User List"),
        actions: [
          followEmployeList.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(right: 17),
                  child: Row(
                    children: [
                      Text(followEmployeList.length.toString()),
                      ElevatedButton(
                          onPressed: () {
                            followCustomber();
                          },
                          child: Text("Follow Customber"))
                    ],
                  ),
                )
              : SizedBox()
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 60,
            ),
            TextFormField(
              onChanged: (value) {
                filterList(value);
              },
              //decoration: InputDecoration(
              //    suffixIcon:
              //        IconButton(onPressed: () {}, icon: Icon(Icons.search))),
              controller: searchController,
            ),
            filterEmployeList.isNotEmpty
                ? Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      itemCount: filterEmployeList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(filterEmployeList[index].id.toString()),
                          subtitle: Text(filterEmployeList[index].login),
                          leading: SizedBox(
                            height: 50,
                            width: 70,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Stack(
                                children: [
                                  Image.network(
                                    filterEmployeList[index].avatarUrl,
                                    fit: BoxFit.fitWidth,
                                  ),
                                  isLongPress && employeModel[index].isChecked
                                      ? Positioned(
                                          top: 30,
                                          bottom: 0,
                                          right: 0,
                                          left: 20,
                                          child: Container(
                                            height: 40,
                                            width: 20,
                                            decoration: BoxDecoration(
                                                color: Colors.green.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: Icon(
                                              Icons.check,
                                              color: Colors.purple,
                                            ),
                                          ))
                                      : SizedBox(),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          color: Colors.grey,
                          height: 2.0,
                        );
                      },
                    ),
                  )
                : filterEmployeList.isEmpty && employeModel.isNotEmpty
                    ? Expanded(
                        child: ListView.separated(
                          controller: scrollController,
                          itemCount: employeModel.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () {
                                if (isLongPress) {
                                  setState(() {
                                    employeModel[index].isChecked =
                                        !employeModel[index].isChecked;
                                    if (employeModel[index].isChecked) {
                                      followEmployeList
                                          .add(employeModel[index]);
                                    }
                                    if (!employeModel[index].isChecked) {
                                      followEmployeList
                                          .remove(employeModel[index]);
                                    }
                                  });
                                }
                              },
                              onLongPress: () {
                                setState(() {
                                  isLongPress = true;
                                  employeModel[index].isChecked = true;
                                  //  followPeopleCount = followPeopleCount + 1;
                                  followEmployeList.add(employeModel[index]);
                                });
                              },
                              title: Text(employeModel[index].id.toString()),
                              subtitle: Text(employeModel[index].login),
                              leading: InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        child: Image.network(
                                            employeModel[index].avatarUrl),
                                      );
                                    },
                                  );
                                },
                                child: SizedBox(
                                  height: 50,
                                  width: 70,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Stack(
                                      children: [
                                        Image.network(
                                          employeModel[index].avatarUrl,
                                          fit: BoxFit.fitWidth,
                                        ),
                                        isLongPress &&
                                                employeModel[index].isChecked
                                            ? Positioned(
                                                top: 30,
                                                bottom: 0,
                                                right: 0,
                                                left: 20,
                                                child: Container(
                                                  height: 40,
                                                  width: 20,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          Colors.green.shade300,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  child: Icon(
                                                    Icons.check,
                                                    color: Colors.purple,
                                                  ),
                                                ))
                                            : SizedBox(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(
                              color: Colors.grey,
                              height: 2.0,
                            );
                          },
                        ),
                      )
                    : Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  getMoreData() {
    HttPConfig().getUser(per_page, since).then((value) => {
          setState(() {
            employeModel.addAll(value);
            isLoading = false;
          })
        });
  }

  void filterList(String value) {
    filterEmployeList.clear();
    duplicateList.addAll(employeModel
        .where((customer) => customer.login.toLowerCase().contains(value)));

    setState(() {
      filterEmployeList = removeDuplicates(duplicateList);
    });

    print("here filterList");
    print(filterEmployeList.length);
  }

  List<T> removeDuplicates<T>(List<T> list) {
    // Convert the list to a set to remove duplicates
    Set<T> set = Set<T>.from(list);

    // Convert the set back to a list
    List<T> deduplicatedList = set.toList();

    return deduplicatedList;
  }

  void getAdminToken() {
    userService.getUserDataByEmail("testwtsm@gmail.com").then((value) => {
          print(value),
        });
  }

  void sendNotification() {
    //  NotificationController.createNewNotification();
  }
}
