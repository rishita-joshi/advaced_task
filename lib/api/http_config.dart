import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wings_advanced_tasl/model/employe_model.dart';

class HttPConfig {
  List<EmployeModel> employeModel = [];
  Future<List<EmployeModel>> getUser(int currentPage, int since) async {
    final response = await http.get(Uri.parse(
        "https://api.github.com/users?per_page=$currentPage&since=$since"));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      employeModel = data.map((item) => EmployeModel.fromJson(item)).toList();
      print("--->$employeModel");
    }
    return employeModel;
  }
}
