import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:netshift/model/dns_model.dart';

class Api {
    Future<List<DnsModel>> fetchDNSFromAPI() async {
    final response =
        await http.get(Uri.parse('https://api.mrsf.ir/api/data/get/?id=1005'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      final List<dynamic>? dnsListJson = data['validateDNS'] as List<dynamic>?;
      if (dnsListJson == null) {
        throw Exception('DNS list is null');
      }

      return dnsListJson.map((json) => DnsModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load DNS');
    }
  }
}