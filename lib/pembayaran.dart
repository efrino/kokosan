import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Pembayaran extends StatefulWidget {
  final Map<String, dynamic> kosData;

  Pembayaran({required this.kosData});

  @override
  _PembayaranState createState() => _PembayaranState();
}

class _PembayaranState extends State<Pembayaran> {
  bool isPaid = false;
  late String nama;
  late String alamat;
  late double harga;

  @override
  void initState() {
    super.initState();
    nama = widget.kosData['nama'] ?? '';
    alamat = widget.kosData['alamat'] ?? '';
    harga = widget.kosData['harga']?.toDouble() ?? 0.0;
  }

  Widget _buildPaymentPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Detail Kos',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          _buildKosInfo(),
          SizedBox(height: 16.0),
          _buildQrCode(),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () async {
              await _markPaymentAsPaid();
              // The rest of your code after the payment is marked as paid
              if (isPaid) {
                Navigator.pop(context, true);
              }
            },
            child: Text('Saya Sudah Membayar'),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoicePage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Invoice Detail',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          _buildKosInfo(),
          SizedBox(height: 16.0),
          _buildPaymentDetails(), // Add payment details here
        ],
      ),
    );
  }

  Widget _buildPaymentDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Metode Pembayaran: Transfer Bank',
            style: TextStyle(fontSize: 18.0)),
        SizedBox(height: 8.0),
        Text('Jumlah Pembayaran: Rp.${harga.toInt()},00',
            style: TextStyle(fontSize: 18.0)),
        SizedBox(height: 8.0),
        Text('Status Pembayaran: Lunas', style: TextStyle(fontSize: 18.0)),
        SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () {
            // Add any action you want when the user views the invoice
          },
          child: Text('Lihat Invoice'),
        ),
      ],
    );
  }

  Widget _buildKosInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Nama Kos: $nama', style: TextStyle(fontSize: 18.0)),
        SizedBox(height: 8.0),
        Text('Alamat: $alamat', style: TextStyle(fontSize: 18.0)),
        SizedBox(height: 8.0),
        Text('Harga: Rp.${harga.toInt()},00', style: TextStyle(fontSize: 18.0)),
      ],
    );
  }

  Widget _buildQrCode() {
    return Image.asset(
      'assets/qris.png',
      width: 200.0,
      height: 200.0,
    );
  }

  Future<void> _markPaymentAsPaid() async {
    try {
      String? documentId = widget.kosData['documentId'];
      String? pemilikID = widget.kosData['pemilikID'];
      String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;

      if (documentId != null && pemilikID != null && currentUserUid != null) {
        await FirebaseFirestore.instance
            .collection('kokosan')
            .doc('kota')
            .collection('semarang')
            .doc(documentId)
            .update({
          'isPaid': true,
          'uid': currentUserUid, // Set the 'uid' to the current user's UID
        });

        setState(() {
          isPaid = true;
        });
      } else {
        print('Error: DocumentId, pemilikID, or currentUserUid is null.');
      }
    } catch (e) {
      print('Error marking payment as paid: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Pembayaran'),
      ),
      body: isPaid ? _buildInvoicePage() : _buildPaymentPage(),
    );
  }
}
