import 'package:netshift/model/dns_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DNSProvider with ChangeNotifier {
  DnsModel? _selectedDNS;
  bool _isDNSSet = false;
  bool _isPowerOn = false;

  DnsModel? get selectedDNS => _selectedDNS;
  bool get isDNSSet => _isDNSSet;
  bool get isPowerOn => _isPowerOn;

  void setDNS(DnsModel dns) {
    _selectedDNS = dns;
    _isDNSSet = true;
    _isPowerOn = false;
    notifyListeners();
  }

  void clearDNS() {
    _selectedDNS = null;
    _isDNSSet = false;
    _isPowerOn = false;
    notifyListeners();
  }

  void activateDNS() {
    if (_isDNSSet && _selectedDNS != null) {
      _isPowerOn = true;
      notifyListeners();
      _savePowerOnState(_isPowerOn);
    }
  }

  void deactivateDNS() {
    if (_isPowerOn) {
      _isPowerOn = false;
      notifyListeners();
      _savePowerOnState(_isPowerOn);
    }
  }

  void toggleDNS() {
    _isPowerOn = !_isPowerOn;
    notifyListeners();
    _savePowerOnState(_isPowerOn);
  }

  void setPowerOn(bool value) {
    _isPowerOn = value;
    notifyListeners();
    _savePowerOnState(_isPowerOn);
  }

  Future<void> _savePowerOnState(bool isPowerOn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPowerOn', isPowerOn);
  }

  Future<bool> _loadPowerOnState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isPowerOn') ?? false;
  }
}
