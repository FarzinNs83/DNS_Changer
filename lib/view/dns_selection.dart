// ignore_for_file: use_build_context_synchronously

import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:netshift/service/dns_provider.dart';
import 'package:netshift/model/dns_model.dart';
import 'package:netshift/component/bottom_sheet.dart';
import 'package:netshift/component/dns_details.dart';
import 'package:netshift/component/custom_dropdown_dns.dart';
import 'package:netshift/service/dns_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DnsSelection extends StatefulWidget {
  final void Function(DnsModel?) onSelect;
  final void Function(DnsModel) onRemove;
  final void Function() onDNSChange;

  const DnsSelection({
    super.key,
    required this.onSelect,
    required this.onRemove,
    required this.onDNSChange,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DnsSelectionState createState() => _DnsSelectionState();
}

class _DnsSelectionState extends State<DnsSelection> {
  DnsModel? selectedDNS;
  int? primaryPingTime;
  int? secondaryPingTime;
  bool _isLoadingPing = false;

  final dnsService = DNSService();
  final TextEditingController primaryController = TextEditingController();
  final TextEditingController secondaryController = TextEditingController();
  List<DnsModel> dnsOptions = [];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    // fetchDNSFromAPI();
  }

  @override
  void dispose() {
    _savePreferences();
    primaryController.dispose();
    secondaryController.dispose();
    super.dispose();
  }

  Future<void> _loadPreferences() async {
    final file = File('dns_options.txt');
    if (file.existsSync()) {
      final dnsList = await file.readAsLines();
      dnsOptions = dnsList.map((dnsString) {
        final parts = dnsString.split(',');
        return DnsModel(name: parts[0], primary: parts[1], secondary: parts[2]);
      }).toList();
    }

    final selectedDnsFile = File('selected_dns.txt');
    String? selectedDnsName;
    if (selectedDnsFile.existsSync()) {
      selectedDnsName = await selectedDnsFile.readAsString();
    }

    selectedDNS = dnsOptions.firstWhere(
      (dns) => dns.name == selectedDnsName,
      orElse: () => dnsOptions.isNotEmpty
          ? dnsOptions[0]
          : DnsModel(name: '', primary: '0.0.0.0', secondary: '0.0.0.0'),
    );

    if (selectedDNS != null) {
      primaryController.text = selectedDNS!.primary;
      secondaryController.text = selectedDNS!.secondary;
      await _updatePingTime(selectedDNS!.primary, selectedDNS!.secondary);
    } else {
      primaryController.clear();
      secondaryController.clear();
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _savePreferences() async {
    final file = File('dns_options.txt');
    final dnsListString = dnsOptions
        .map((dns) => '${dns.name},${dns.primary},${dns.secondary}')
        .join('\n');
    await file.writeAsString(dnsListString);

    final selectedFile = File('selected_dns.txt');
    await selectedFile.writeAsString(selectedDNS?.name ?? '');
  }

  Future<void> _updatePingTime(String primaryDNS, String secondaryDNS) async {
    if (!mounted) return;

    setState(() {
      _isLoadingPing = true;
    });

    final primaryPing = await dnsService.pingDNS(primaryDNS);
    final secondaryPing = await dnsService.pingDNS(secondaryDNS);

    if (mounted) {
      setState(() {
        primaryPingTime = primaryPing;
        secondaryPingTime = secondaryPing;
        _isLoadingPing = false;
      });
    }
  }

  Future<void> _pingSelectedDNS() async {
    if (selectedDNS != null) {
      setState(() {
        _isLoadingPing = true;
      });

      await _updatePingTime(selectedDNS!.primary, selectedDNS!.secondary);

      if (mounted) {
        setState(() {
          _isLoadingPing = false;
        });
      }
    }
  }

  void _showAddDNSSheet(BuildContext context, {DnsModel? dnsToEdit}) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return DNSBottomSheet(
          dnsToEdit: dnsToEdit,
          onSave: (DnsModel newDns) {
            setState(() {
              if (dnsToEdit != null) {
                final index = dnsOptions.indexOf(dnsToEdit);
                if (index != -1) {
                  dnsOptions[index] = newDns;
                }
              } else {
                dnsOptions.add(newDns);
              }

              selectedDNS = newDns;
              primaryController.text = newDns.primary;
              secondaryController.text = newDns.secondary;
              _pingSelectedDNS();

              _savePreferences();
              Provider.of<DNSProvider>(context, listen: false).setDNS(newDns);
            });
          },
        );
      },
    );
  }

  void _removeDNSFromPreferences(DnsModel dns) async {
    dnsOptions.remove(dns);
    final file = File('dns_options.txt');
    final dnsListString = dnsOptions
        .map((dns) => '${dns.name},${dns.primary},${dns.secondary}')
        .join('\n');
    await file.writeAsString(dnsListString);

    if (mounted) {
      setState(() {
        if (selectedDNS == dns) {
          if (dnsOptions.isNotEmpty) {
            selectedDNS = dnsOptions[0];
          } else {
            selectedDNS = null;
          }
        }
        primaryController.text = selectedDNS?.primary ?? '';
        secondaryController.text = selectedDNS?.secondary ?? '';
      });
    }
  }

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

  Future<void> _generateAndAddDNS() async {
    try {
      List<DnsModel> dnsList = await fetchDNSFromAPI();

      final Random random = Random();
      final newDns = dnsList[random.nextInt(dnsList.length)];

      setState(() {
        dnsOptions.add(newDns);
        selectedDNS = newDns;
        primaryController.text = newDns.primary;
        secondaryController.text = newDns.secondary;
        _savePreferences();
      });

      _pingSelectedDNS();
      Provider.of<DNSProvider>(context, listen: false).setDNS(newDns);
    } catch (e) {
      debugPrint('Error fetching DNS: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        children: [
          const SizedBox(
            width: 32,
          ),
          FloatingActionButton(
            onPressed: () => _generateAndAddDNS(),
            tooltip: 'Generate DNS',
            child: const Icon(Icons.radar_rounded),
          ),
          const Spacer(),
          FloatingActionButton(
            onPressed: () => _showAddDNSSheet(context),
            tooltip: 'Add DNS',
            child: const Icon(Icons.add),
          ),
        ],
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Select DNS'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DNSSelector(
              dnsOptions: dnsOptions,
              selectedDNS: selectedDNS,
              onSelected: (DnsModel? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedDNS = newValue;
                    primaryController.text = newValue.primary;
                    secondaryController.text = newValue.secondary;
                  });
                  _savePreferences();
                  widget.onSelect(newValue);
                  _pingSelectedDNS();
                }
              },
              onEdit: (DnsModel dns) {
                _showAddDNSSheet(context, dnsToEdit: dns);
              },
              onDelete: (DnsModel dns) {
                debugPrint('Deleting DNS: ${dns.name}');
                if (mounted) {
                  setState(() {
                    dnsOptions.remove(dns);
                    if (selectedDNS == dns) {
                      if (dnsOptions.isNotEmpty) {
                        selectedDNS = dnsOptions[0];
                      } else {
                        selectedDNS = null;
                      }
                    }
                    primaryController.text = selectedDNS?.primary ?? '';
                    secondaryController.text = selectedDNS?.secondary ?? '';
                  });

                  _removeDNSFromPreferences(dns);
                  _savePreferences();

                  if (selectedDNS != null) {
                    Provider.of<DNSProvider>(context, listen: false)
                        .setDNS(selectedDNS!);
                  } else {
                    Provider.of<DNSProvider>(context, listen: false).clearDNS();
                  }
                }
              },
            ),
            const SizedBox(height: 20),
            if (selectedDNS != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DNSDetailRow(
                    label: 'Primary DNS:',
                    pingTime: primaryPingTime,
                    isLoading: _isLoadingPing,
                    controller: primaryController,
                    copyLabel: 'Primary DNS',
                  ),
                  const SizedBox(height: 20),
                  DNSDetailRow(
                    label: 'Secondary DNS:',
                    pingTime: secondaryPingTime,
                    isLoading: _isLoadingPing,
                    controller: secondaryController,
                    copyLabel: 'Secondary DNS',
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _pingSelectedDNS,
                        child: const Text('Ping'),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
