import 'package:bacsainhardware/checkincheckout.dart';
import 'package:bacsainhardware/findtools.dart';
import 'package:bacsainhardware/identify.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerPage extends StatefulWidget {
  String users_id;
  final label;
  ScannerPage({super.key, required this.label, required this.users_id});

  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  String barcode = 'Scan a code';
  bool hasScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              onDetect: (BarcodeCapture barcodeCapture) {
                if (!hasScanned) {
                  final String? scannedValue =
                      barcodeCapture.barcodes.first.rawValue;

                  setState(() {
                    barcode = scannedValue ?? 'Failed to scan';
                  });

                  if (scannedValue != null) {
                    hasScanned = true;

                    if (widget.label == 'findtools') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FintToolsPage(
                              barcode: scannedValue,
                              label: widget.label,
                              users_id: widget.users_id),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckinCheckoutPage(
                              barcode: scannedValue,
                              label: widget.label,
                              users_id: widget.users_id),
                        ),
                      );
                    }
                  }
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(barcode),
          ),
        ],
      ),
    );
  }
}
