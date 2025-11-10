import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../core/api/api_config.dart';
import '../core/api/gloable_status_code.dart';
import '../core/api/network_repository.dart';
import '../core/widgets/component.dart';
import '../data/models/kpi/kpi_model.dart';
import '../main.dart';

class KpiProvider with ChangeNotifier {
  late List<String> years;
  late String selectedYear;

  KpiProvider() {
    final currentYear = DateTime.now().year;
    years = List.generate(5, (index) => (currentYear - index).toString());
    selectedYear = currentYear.toString(); // 👈 Default to current year
  }

  Future<void> setYear(String year) async {
    selectedYear = year;

    notifyListeners();
    await getAPIList(date: year);
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  List<KpiModel> _kpiList = [];

  List<KpiModel> get kpiList => _kpiList;

  Future<void> getAPIList({required String date}) async {
    _setLoading(true);
    try {
      final response = await callApi(
        url: '${ApiConfig.kpiListUrl}?year=$date',
        method: HttpMethod.get,
        headers: null,
      );

      if (globalStatusCode == 200) {
        final decoded = json.decode(response);

        // Ensure it's a list
        if (decoded is List) {
          _kpiList = decoded.map((e) => KpiModel.fromJson(e)).toList();
        } else {
          _kpiList = [];
        }
      } else {
        showCommonDialog(
          showCancel: false,
          title: "Error",
          context: navigatorKey.currentContext!,
          content: errorMessage,
        );
      }
    } catch (e) {
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }
}
