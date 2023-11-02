// To parse this JSON data, do
//
//     final employeModel = employeModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

List<EmployeModel> employeModelFromJson(String str) => List<EmployeModel>.from(
    json.decode(str).map((x) => EmployeModel.fromJson(x)));

String employeModelToJson(List<EmployeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EmployeModel {
  String login;
  int id;
  String nodeId;
  String avatarUrl;
  String gravatarId;
  String url;
  String htmlUrl;
  String followersUrl;
  String followingUrl;
  String gistsUrl;
  String starredUrl;
  String subscriptionsUrl;
  String organizationsUrl;
  String reposUrl;
  String eventsUrl;
  String receivedEventsUrl;
  String? type;
  bool siteAdmin;
  bool isChecked = false;

  EmployeModel({
    required this.login,
    required this.id,
    required this.nodeId,
    required this.avatarUrl,
    required this.gravatarId,
    required this.url,
    required this.htmlUrl,
    required this.followersUrl,
    required this.followingUrl,
    required this.gistsUrl,
    required this.starredUrl,
    required this.subscriptionsUrl,
    required this.organizationsUrl,
    required this.reposUrl,
    required this.eventsUrl,
    required this.receivedEventsUrl,
    this.type,
    required this.siteAdmin,
  });

  EmployeModel copyWith({
    String? login,
    int? id,
    String? nodeId,
    String? avatarUrl,
    String? gravatarId,
    String? url,
    String? htmlUrl,
    String? followersUrl,
    String? followingUrl,
    String? gistsUrl,
    String? starredUrl,
    String? subscriptionsUrl,
    String? organizationsUrl,
    String? reposUrl,
    String? eventsUrl,
    String? receivedEventsUrl,
    String? type,
    bool? siteAdmin,
    bool? isChecked = false,
  }) =>
      EmployeModel(
        login: login ?? this.login,
        id: id ?? this.id,
        nodeId: nodeId ?? this.nodeId,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        gravatarId: gravatarId ?? this.gravatarId,
        url: url ?? this.url,
        htmlUrl: htmlUrl ?? this.htmlUrl,
        followersUrl: followersUrl ?? this.followersUrl,
        followingUrl: followingUrl ?? this.followingUrl,
        gistsUrl: gistsUrl ?? this.gistsUrl,
        starredUrl: starredUrl ?? this.starredUrl,
        subscriptionsUrl: subscriptionsUrl ?? this.subscriptionsUrl,
        organizationsUrl: organizationsUrl ?? this.organizationsUrl,
        reposUrl: reposUrl ?? this.reposUrl,
        eventsUrl: eventsUrl ?? this.eventsUrl,
        receivedEventsUrl: receivedEventsUrl ?? this.receivedEventsUrl,
        type: type ?? this.type,
        siteAdmin: siteAdmin ?? this.siteAdmin,
        // isChecked: isChecked ?? this.isChecked,
      );

  factory EmployeModel.fromJson(Map<String, dynamic> json) => EmployeModel(
        login: json["login"] ?? "",
        id: json["id"] ?? "",
        nodeId: json["node_id"] ?? "",
        avatarUrl: json["avatar_url"] ?? "",
        gravatarId: json["gravatar_id"] ?? "",
        url: json["url"] ?? "",
        htmlUrl: json["html_url"] ?? "",
        followersUrl: json["followers_url"] ?? "",
        followingUrl: json["following_url"] ?? "",
        gistsUrl: json["gists_url"] ?? "",
        starredUrl: json["starred_url"] ?? "",
        subscriptionsUrl: json["subscriptions_url"] ?? "",
        organizationsUrl: json["organizations_url"],
        reposUrl: json["repos_url"] ?? '',
        eventsUrl: json["events_url"] ?? "",
        receivedEventsUrl: json["received_events_url"] ?? "",
        type: json["type"],
        siteAdmin: json["site_admin"] ?? "",
        // isChecked: json["isChecked"] ?? false
      );

  Map<String, dynamic> toJson() => {
        "login": login,
        "id": id,
        "node_id": nodeId,
        "avatar_url": avatarUrl,
        "gravatar_id": gravatarId,
        "url": url,
        "html_url": htmlUrl,
        "followers_url": followersUrl,
        "following_url": followingUrl,
        "gists_url": gistsUrl,
        "starred_url": starredUrl,
        "subscriptions_url": subscriptionsUrl,
        "organizations_url": organizationsUrl,
        "repos_url": reposUrl,
        "events_url": eventsUrl,
        "received_events_url": receivedEventsUrl,
        "type": type,
        "site_admin": siteAdmin,
        "isChecked": isChecked
      };

  factory EmployeModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EmployeModel(
      login: data["login"] ?? "",
      id: data["id"] ?? "",
      nodeId: data["node_id"] ?? "",
      avatarUrl: data["avatar_url"] ?? "",
      gravatarId: data["gravatar_id"] ?? "",
      url: data["url"] ?? "",
      htmlUrl: data["html_url"] ?? "",
      followersUrl: data["followers_url"] ?? "",
      followingUrl: data["following_url"] ?? "",
      gistsUrl: data["gists_url"] ?? "",
      starredUrl: data["starred_url"] ?? "",
      subscriptionsUrl: data["subscriptions_url"] ?? "",
      organizationsUrl: data["organizations_url"],
      reposUrl: data["repos_url"] ?? '',
      eventsUrl: data["events_url"] ?? "",
      receivedEventsUrl: data["received_events_url"] ?? "",
      type: data["type"],
      siteAdmin: data["site_admin"] ?? "",
    );
  }
}
