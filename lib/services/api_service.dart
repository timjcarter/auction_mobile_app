import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:auction_mobile_app/models/user_model.dart';
import 'package:auction_mobile_app/models/accounts_model.dart';
import 'package:auction_mobile_app/models/items_model.dart';
import 'package:auction_mobile_app/models/ended_items_model.dart';
import 'package:auction_mobile_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  Future<List<String>?> login(String username, String password) async {
    try {
      Map<String, dynamic> data = {'username': username, 'password': password};
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.loginEndpoint);
      var response = await http.post(url,
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        String userId = jsonResponse['userId'].toString();
        String token = jsonResponse['token'];
        List<String> IdToken = [userId, token];
        return IdToken;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void logout(token) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.logoutEndpoint);
      await http.post(url, headers: {'Authorization': 'Token $token'});
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<UserModel>?> getUsers() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<UserModel> _model = userModelFromJson(response.body);
        return _model;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<AccountsModel>?> getAccounts() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.accountsEndpoint);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<AccountsModel> _model = accountsModelFromJson(response.body);
        return _model;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<ItemsModel?> getItem(int itemId) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.itemsEndpoint}$itemId/');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        ItemsModel item = ItemsModel.fromJson(jsonResponse);
        return item;
      }
    } catch (e) {
      log(e.toString());
    }

    return null;
  }

  Future<List<ItemsModel>?> getItems() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.itemsEndpoint);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<ItemsModel> _model = itemsModelFromJson(response.body);
        return _model;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<EndedItemsModel?> getEndedItem(int itemId) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.endedItemsEndpoint}$itemId/');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        EndedItemsModel item = EndedItemsModel.fromJson(jsonResponse);
        return item;
      }
    } catch (e) {
      log(e.toString());
    }

    return null;
  }

  Future<List<EndedItemsModel>?> getEndedItems() async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.endedItemsEndpoint);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<EndedItemsModel> _model = endedItemsModelFromJson(response.body);
        return _model;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void createItem(
    String name,
    double price,
    double postageCost,
    double bidIncrement,
    String condition,
    DateTime endDateTime,
    bool acceptsReturns,
    String description,
    int sellerId,
    String token,
  ) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.createItemEndpoint);
      Map<String, dynamic> data = {
        'name': name,
        'price': price,
        'postageCost': postageCost,
        'bidIncrement': bidIncrement,
        'condition': condition,
        'endDateTime': endDateTime.toIso8601String(),
        'acceptsReturns': acceptsReturns,
        'description': description,
        'sellerId': sellerId,
      };
      await http.post(url, body: json.encode(data), headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json'
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void submitBid(double bid, int itemId, int accountId, String token) async {
    var url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.itemsEndpoint}$itemId/${ApiConstants.bidEndpoint}');
    Map<String, dynamic> data = {
      'price': bid,
      'accountId': accountId,
    };
    await http.post(url, body: json.encode(data), headers: {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json',
    });
  }
}
