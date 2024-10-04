import 'package:flutter/material.dart';
import 'dart:io';
import 'package:netshift/model/dns_model.dart';
import 'package:netshift/service/dns_service.dart';

class FastestDNSPage extends StatefulWidget {
  final void Function(DnsModel) onApply;
  final void Function() onClear;

  const FastestDNSPage(
      {super.key, required this.onApply, required this.onClear});

  @override
  // ignore: library_private_types_in_public_api
  _FastestDNSPageState createState() => _FastestDNSPageState();
}

class _FastestDNSPageState extends State<FastestDNSPage>
    with WidgetsBindingObserver {
  final dnsService = DNSService();
  List<DnsModel> dnsOptions = [];
  List<DnsModel> sortedDnsOptions = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadDNSOptions();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _loadDNSOptions();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _loadDNSOptions() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    final file = File('dns_options.txt');
    if (!file.existsSync()) {
      setState(() {
        isLoading = false;
        dnsOptions = [];
      });
      return;
    }

    try {
      final dnsList = await file.readAsLines();
      final dnsOptions = dnsList
          .map((dnsString) {
            final parts = dnsString.split(',');
            if (parts.length < 3) return null;
            return DnsModel(
                name: parts[0], primary: parts[1], secondary: parts[2]);
          })
          .whereType<DnsModel>()
          .toList();

      if (dnsOptions.isNotEmpty) {
        await _updatePingTimes(dnsOptions);
      } else {
        setState(() {
          this.dnsOptions = [];
        });
      }
    } catch (e) {
      print('Error loading DNS options: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _updatePingTimes(List<DnsModel> dnsOptions) async {
    final pingTimes = <DnsModel, int>{};

    for (var dns in dnsOptions) {
      try {
        final primaryPing = await dnsService.pingDNS(dns.primary);
        final secondaryPing = await dnsService.pingDNS(dns.secondary);
        final averagePing = ((primaryPing ?? 0) + (secondaryPing ?? 0)) / 2;

        if (!mounted) return;

        dns.primaryPingTime = primaryPing;
        dns.secondaryPingTime = secondaryPing;

        pingTimes[dns] = averagePing.toInt();
      } catch (e) {
        print('Error pinging DNS: $e');
      }
    }

    if (mounted) {
      setState(() {
        sortedDnsOptions = pingTimes.keys.toList()
          ..sort((a, b) {
            final aPing = pingTimes[a]!;
            final bPing = pingTimes[b]!;

            if ((a.primaryPingTime == null && a.secondaryPingTime == null) &&
                (b.primaryPingTime == null && b.secondaryPingTime == null)) {
              return 0;
            } else if (a.primaryPingTime == null &&
                a.secondaryPingTime == null) {
              return 1;
            } else if (b.primaryPingTime == null &&
                b.secondaryPingTime == null) {
              return -1;
            } else {
              return aPing.compareTo(bPing);
            }
          });
      });
    }
  }

  Future<void> _applyFastestDNS() async {
    if (sortedDnsOptions.isNotEmpty) {
      final fastestDNS = sortedDnsOptions.first;
      widget.onApply(fastestDNS);
      await dnsService.setDNS(fastestDNS.primary, fastestDNS.secondary);

      _showConfirmationDialog('DNS set to ${fastestDNS.name}');
    } else {
      _showConfirmationDialog('No DNS options available to apply.');
    }
  }

  void _applyDNS(DnsModel dns) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apply DNS'),
        content: Text('Do you want to apply DNS: ${dns.name}?'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              widget.onApply(dns);
              await dnsService.setDNS(dns.primary, dns.secondary);
              _showConfirmationDialog('DNS set to ${dns.name}');
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
        ],
      ),
    );
  }

  void _clearDNS() {
    widget.onClear();
    _showConfirmationDialog('DNS has been cleared.');
  }

  void _showConfirmationDialog(String message) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('DNS Update',
            style: Theme.of(context).textTheme.headlineSmall),
        content: Text(message, style: Theme.of(context).textTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('DNS Ping Results', style: theme.textTheme.bodySmall),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: theme.iconTheme.color),
            onPressed: _loadDNSOptions,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : sortedDnsOptions.isEmpty
              ? Center(
                  child: Text('No DNS options available',
                      style: theme.textTheme.bodyMedium))
              : ListView.builder(
                  itemCount: sortedDnsOptions.length,
                  itemBuilder: (context, index) {
                    final dns = sortedDnsOptions[index];
                    return GestureDetector(
                      onTap: () => _applyDNS(dns),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.brightness == Brightness.light
                              ? theme.inputDecorationTheme.fillColor
                              : Colors.grey[850],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: theme.dividerColor),
                          boxShadow: [
                            BoxShadow(
                              color: theme.shadowColor,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dns.name,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: theme.brightness == Brightness.light
                                    ? theme.textTheme.headlineMedium?.color
                                    : Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Primary DNS: ${dns.primary}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.brightness == Brightness.light
                                    ? theme.textTheme.bodyMedium?.color
                                    : Colors.white70,
                              ),
                            ),
                            Text(
                              'Secondary DNS: ${dns.secondary}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.brightness == Brightness.light
                                    ? theme.textTheme.bodyMedium?.color
                                    : Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Primary Ping: ${dns.primaryPingTime ?? 'N/A'} ms',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.brightness == Brightness.light
                                        ? theme.textTheme.bodyMedium?.color
                                        : Colors.white70,
                                  ),
                                ),
                                Text(
                                  'Secondary Ping: ${dns.secondaryPingTime ?? 'N/A'} ms',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.brightness == Brightness.light
                                        ? theme.textTheme.bodyMedium?.color
                                        : Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _applyFastestDNS,
              tooltip: 'Apply Fastest DNS',
              backgroundColor: theme.primaryColor,
              child: Icon(Icons.speed,
                  color: theme.floatingActionButtonTheme.foregroundColor),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 48,
            child: FloatingActionButton(
              onPressed: _clearDNS,
              tooltip: 'Clear DNS',
              backgroundColor: Colors.redAccent,
              child: Icon(Icons.clear,
                  color: theme.floatingActionButtonTheme.foregroundColor),
            ),
          ),
        ],
      ),
    );
  }
}
