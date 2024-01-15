// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSettingsScreen extends StatefulWidget {
  final String? userUid;

  ProfileSettingsScreen({this.userUid});

  @override
  _ProfileSettingsScreenState createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  TextEditingController _nomorTeleponController = TextEditingController();
  TextEditingController _namaController = TextEditingController();
  String _selectedJenisKelamin = 'Belum diatur';
  DateTime? _selectedDate;
  PickedFile? _pickedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nomor Telepon',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _nomorTeleponController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Masukkan nomor telepon',
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Nama',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _namaController,
              decoration: InputDecoration(
                hintText: 'Masukkan nama',
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Jenis Kelamin',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            DropdownButton<String>(
              value: _selectedJenisKelamin,
              items: ['Belum diatur', 'Perempuan', 'Laki-laki', 'Tidak ada']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedJenisKelamin = newValue ?? 'Belum diatur';
                });
              },
            ),
            SizedBox(height: 16),
            Text(
              'Tanggal Lahir',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Text(_selectedDate != null
                    ? '${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}'
                    : 'Belum diatur'),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () {
                    _selectDate(context);
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Gambar Profil',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            _buildImagePicker(),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _updateProfile();
              },
              child: Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        _pickedImage != null
            ? CircleAvatar(
                radius: 50,
                backgroundImage: FileImage(
                  File(_pickedImage!.path),
                ),
              )
            : CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                    'https://via.placeholder.com/150'), // Ganti dengan URL gambar profil
              ),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            _pickImage();
          },
          child: Text('Pilih Gambar'),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final PickedFile? pickedImage = await _picker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      setState(() {
        _pickedImage = pickedImage;
      });
    }
  }

  void _updateProfile() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Update nomor telepon
      String nomorTelepon = _nomorTeleponController.text.trim();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'nomor_telepon': nomorTelepon});

      // Update jenis kelamin
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'jenis_kelamin': _selectedJenisKelamin});

      // Update tanggal lahir
      if (_selectedDate != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'tanggal_lahir': _selectedDate});
      }

      // Update nama
      String nama = _namaController.text.trim();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'nama': nama});

      // Update gambar profil
      if (_pickedImage != null) {
        // Upload gambar ke Firebase Storage atau sumber penyimpanan lainnya
        // Ambil URL gambar dan simpan di Firestore
        // Contoh penggunaan Firebase Storage:
        // Reference ref = FirebaseStorage.instance.ref().child('path/to/image');
        // UploadTask uploadTask = ref.putFile(File(_pickedImage.path));
        // TaskSnapshot snapshot = await uploadTask;
        // String imageUrl = await snapshot.ref.getDownloadURL();

        // Setelah mendapatkan URL gambar, simpan di Firestore
        // await FirebaseFirestore.instance
        //     .collection('users')
        //     .doc(user.uid)
        //     .update({'gambar_profil': imageUrl});
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Perubahan berhasil disimpan!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
