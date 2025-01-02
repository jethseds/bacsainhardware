import 'dart:convert';
import 'dart:typed_data';
import 'package:bacsainhardware/api.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;

class InvoicePage extends StatefulWidget {
  InvoicePage({super.key});

  @override
  _InvoicePage createState() => _InvoicePage();
}

class _InvoicePage extends State<InvoicePage> {
  List<List<dynamic>> data = [];
  double total = 0.0;
  Future<void> fetchData() async {
    ApiServices services = ApiServices();
    final linkurl = await services.fetchURL();
    final response = await http.get(
      Uri.parse('${linkurl}/mobilecontroller/products.php'),
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      var jsonBody = response.body;
      var jsonData = json.decode(jsonBody);

      if (jsonData is List) {
        total = 0.0;
        List<List<dynamic>> formattedData = jsonData.map<List<dynamic>>((item) {
          return [
            item['title'] ?? '',
            item['price'] ?? '', // Adjust to match your actual JSON keys
          ];
        }).toList();

        for (var item in jsonData) {
          var price = item['price'] != null
              ? double.tryParse(item['price'].toString())
              : 0.0;

          // Add item to formatted data

          // Accumulate the total
          total += price ?? 0.0;
        }

        setState(() {
          data = formattedData;
          print(total);
          print("Formatted data: $data");
        });
      } else {
        print("Unexpected JSON format: $jsonData");
      }
    } else {
      print("Failed to fetch data: ${response.statusCode}");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // Function to generate the PDF document
  Future<Uint8List> _generateInvoice() async {
    if (data.isEmpty) {
      await fetchData(); // Ensure data is fetched before generating the PDF
    }

    final pdf = pw.Document();

    int totalItems = data.length;
    int itemsPerPage = 5; // First page displays 5 items

    for (int i = 0; i < totalItems; i += itemsPerPage) {
      // Determine if it's the first page
      bool isFirstPage = i == 0;

      // Adjust itemsPerPage for the first page and subsequent pages
      if (isFirstPage) {
        itemsPerPage = 5; // 5 items for the first page
      } else if (i + itemsPerPage < totalItems) {
        itemsPerPage = 20; // 20 items for the middle pages
      } else {
        // For the last page, display the remaining items, which might be less than 20
        itemsPerPage = totalItems - i; // Adjust for the remaining items
      }

      // Get the data for this page
      List<List<dynamic>> pageData = data.sublist(
          i, (i + itemsPerPage) > totalItems ? totalItems : (i + itemsPerPage));

      bool isLastPage = (i + itemsPerPage) >= totalItems;

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(16),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  if (isFirstPage)
                    pw.Text(
                      "J. Bacsain",
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  if (isFirstPage)
                    pw.Text(
                      "Hardware & Construction Supplies",
                      style: pw.TextStyle(
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  if (isFirstPage) pw.SizedBox(height: 20),
                  if (isFirstPage)
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("OFFICIAL RECEIPT:",
                            style: pw.TextStyle(
                              fontSize: 18,
                              fontWeight: pw.FontWeight.bold,
                            )),
                        pw.Text("No:",
                            style: pw.TextStyle(
                              fontSize: 18,
                              fontWeight: pw.FontWeight.bold,
                            )),
                      ],
                    ),
                  if (isFirstPage)
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("(Type of industry):",
                            style: pw.TextStyle(fontSize: 18)),
                        pw.Text("Date:", style: pw.TextStyle(fontSize: 18)),
                      ],
                    ),
                  if (isFirstPage) pw.SizedBox(height: 20),
                  if (isFirstPage)
                    pw.Text("Received from______________________",
                        style: pw.TextStyle(fontSize: 16)),
                  if (isFirstPage)
                    pw.Text(
                        "with TIN____________________and address at______________",
                        style: pw.TextStyle(fontSize: 16)),
                  if (isFirstPage)
                    pw.Text(
                        "the business style__________________engaged in______________ the business style of____________ths sum of Pesos_________________(P______________) in full/partial payment for_______________",
                        style: pw.TextStyle(fontSize: 16)),
                  if (isFirstPage) pw.SizedBox(height: 20),
                  if (isFirstPage)
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Check No:", style: pw.TextStyle(fontSize: 18)),
                      ],
                    ),
                  if (isFirstPage)
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Bank:", style: pw.TextStyle(fontSize: 18)),
                        pw.Text("_______________",
                            style: pw.TextStyle(fontSize: 18)),
                      ],
                    ),
                  if (isFirstPage)
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Cash:", style: pw.TextStyle(fontSize: 18)),
                        pw.Text("Authorized Signature",
                            style: pw.TextStyle(fontSize: 18)),
                      ],
                    ),
                  if (isFirstPage) pw.SizedBox(height: 10),
                  if (isFirstPage) pw.Divider(),
                  if (isFirstPage) pw.Divider(),
                  if (isFirstPage)
                    pw.Text("IN PAYMENT OF:",
                        style: pw.TextStyle(fontSize: 18)),
                  pw.Expanded(
                    child: pw.Table.fromTextArray(
                      headers: ["Name", "Column 2"],
                      data: pageData.isEmpty
                          ? [
                              ["No data available", ""],
                            ]
                          : pageData +
                              (isLastPage
                                  ? [
                                      [
                                        "TOTAL SALES",
                                        "${total.toStringAsFixed(2)}"
                                      ],
                                      ["Less: Withholding Tax:", ""],
                                      ["Amount Due:", ""],
                                      ["", ""],
                                      [
                                        "",
                                        ""
                                      ], // Add an empty row to complete the table
                                    ]
                                  : []),
                    ),
                  ),
                  if (isLastPage)
                    pw.Container(
                      width: PdfPageFormat.a4.width - 32,
                      decoration: pw.BoxDecoration(
                        border: pw.Border(
                          left: pw.BorderSide(color: PdfColors.black, width: 1),
                          right:
                              pw.BorderSide(color: PdfColors.black, width: 1),
                        ),
                      ),
                      padding: const pw.EdgeInsets.symmetric(vertical: 8.0),
                      child: pw.Text(
                        "Form of Payment",
                        style: pw.TextStyle(
                            fontSize: 18, fontWeight: pw.FontWeight.bold),
                        textAlign:
                            pw.TextAlign.center, // Center text in the cell
                      ),
                    ),
                  if (isLastPage)
                    pw.Table(
                      border: pw.TableBorder.all(), // Add borders to the table
                      children: [
                        pw.TableRow(
                          children: [
                            // Checkbox representation for Cash
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Container(
                                  width: 12,
                                  height: 12,
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(
                                        color: PdfColors.black, width: 1),
                                    borderRadius: pw.BorderRadius.circular(2),
                                  ),
                                  child: pw.Container(
                                      // Uncomment the following line to represent a checked checkbox
                                      // decoration: pw.BoxDecoration(color: PdfColors.black, borderRadius: pw.BorderRadius.circular(2)),
                                      ),
                                ),
                                pw.SizedBox(width: 8),
                                pw.Text("Cash",
                                    style: pw.TextStyle(fontSize: 16)),
                              ],
                            ),
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Container(
                                  width: 12,
                                  height: 12,
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(
                                        color: PdfColors.black, width: 1),
                                    borderRadius: pw.BorderRadius.circular(2),
                                  ),
                                  child: pw.Container(
                                      // Uncomment the following line to represent a checked checkbox
                                      // decoration: pw.BoxDecoration(color: PdfColors.black, borderRadius: pw.BorderRadius.circular(2)),
                                      ),
                                ),
                                pw.SizedBox(width: 8),
                                pw.Text("Payment",
                                    style: pw.TextStyle(fontSize: 16)),
                              ],
                            ),
                          ],
                        ),
                        // Add more rows if needed...
                      ],
                    ),
                ],
              ),
            );
          },
        ),
      );
    }

    return pdf.save();
  }

  // Function to preview and share the PDF document
  void _showPdfPreview(BuildContext context) async {
    final pdfData = await _generateInvoice();

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfData,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Invoice PDF Generator"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showPdfPreview(context),
          child: Text("Generate Invoice PDF"),
        ),
      ),
    );
  }
}
