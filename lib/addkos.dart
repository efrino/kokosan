import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddKosPage extends StatefulWidget {
  final String pemilikID;
  final String? kosID;

  AddKosPage(this.pemilikID, [this.kosID]);

  @override
  _AddKosPageState createState() => _AddKosPageState();
}

class _AddKosPageState extends State<AddKosPage> {
  TextEditingController _namaController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  TextEditingController _hargaController = TextEditingController();
  TextEditingController _bathroomsController = TextEditingController();
  TextEditingController _bedroomsController = TextEditingController();
  File? _selectedImage;
  String? _imageURL;

  @override
  void initState() {
    super.initState();
    if (widget.kosID != null) {
      _fetchKosData();
    }
  }

  void _fetchKosData() async {
    try {
      var kosData = await FirebaseFirestore.instance
          .collection('kokosan')
          .doc('kota')
          .collection('semarang')
          .doc(widget.kosID)
          .get();

      setState(() {
        _namaController.text = kosData['nama'];
        _alamatController.text = kosData['alamat'];
        _hargaController.text = kosData['harga'].toString();
        _bathroomsController.text = kosData['bathrooms'].toString();
        _bedroomsController.text = kosData['bedrooms'].toString();
        _imageURL = kosData['gambarURL'];
      });
    } catch (error) {
      print('Error fetching Kos data: $error');
    }
  }

  Future<String> uploadImageToFirebaseStorage(
      File imageFile, String imageName) async {
    try {
      var ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/$imageName');
      var uploadTask = ref.putFile(imageFile);

      var snapshot = await uploadTask;

      var downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      return '';
    }
  }

  Widget _buildImageWidget() {
    return Column(
      children: [
        _buildProfilePicture(),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildProfilePicture() {
    if (_selectedImage != null) {
      return _buildImageFromFile(_selectedImage!);
    } else if (_imageURL != null) {
      return _buildImageFromNetwork(_imageURL!);
    } else {
      return _buildPlaceholderIcon();
    }
  }

  Widget _buildImageFromFile(File file) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Image.file(
        file,
        fit: BoxFit.cover,
        width: 100,
        height: 100,
      ),
    );
  }

  Widget _buildImageFromNetwork(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: kIsWeb
          ? Image.network(
              url,
              fit: BoxFit.cover,
              width: 100,
              height: 100,
            )
          : Image.network(
              url,
              fit: BoxFit.cover,
              width: 100,
              height: 100,
            ),
    );
  }

  Widget _buildPlaceholderIcon() {
    return Icon(
      Icons.photo,
      size: 100,
      color: Colors.grey,
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text(widget.kosID != null ? 'Edit Data Kos' : 'Tambah Data Kos'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _namaController,
                  decoration: InputDecoration(labelText: 'Nama Kos'),
                ),
                TextField(
                  controller: _alamatController,
                  decoration: InputDecoration(labelText: 'Alamat Kos'),
                ),
                TextField(
                  controller: _hargaController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Harga Kos'),
                ),
                TextField(
                  controller: _bedroomsController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Bedrooms'),
                ),
                TextField(
                  controller: _bathroomsController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Bathrooms'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _uploadImage();
                  },
                  child: Text('Upload Gambar'),
                ),
                SizedBox(height: 16),
                _buildImageWidget(),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    widget.kosID != null ? _editKosData() : _addKosData();
                  },
                  child: Text(widget.kosID != null
                      ? 'Edit Data Kos'
                      : 'Tambah Data Kos'),
                ),
              ],
            ),
          ),
        ));
  }

  void _addKosData() {
    try {
      String namaKos = _namaController.text.trim();
      String alamatKos = _alamatController.text.trim();
      int hargaKos = int.tryParse(_hargaController.text) ?? 0;
      int bedrooms = int.tryParse(_bedroomsController.text) ?? 0;
      int bathrooms = int.tryParse(_bathroomsController.text) ?? 0;

      if (namaKos.isEmpty || alamatKos.isEmpty || hargaKos == 0) {
        _showSnackBar('Semua field harus diisi dengan benar!');
        return;
      }

      FirebaseFirestore.instance
          .collection('kokosan')
          .doc('kota')
          .collection('semarang')
          .add({
        'nama': namaKos,
        'alamat': alamatKos,
        'harga': hargaKos,
        'isPaid': false,
        'uid': "",
        'pemilikID': widget.pemilikID,
        'gambarURL': _imageURL,
        'bedrooms': bedrooms,
        'bathrooms': bathrooms,
      }).then((value) {
        _showSnackBar('Data Kos berhasil ditambahkan!');
        Navigator.pop(context); // Close the page
      }).catchError((error) {
        _showSnackBar('Terjadi kesalahan. Silakan coba lagi.');
      });
    } catch (error) {
      print('Error adding Kos data: $error');
    }
  }

  Future<void> _uploadImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });

        String imageName = 'kos_${DateTime.now().millisecondsSinceEpoch}.jpg';
        String imageURL =
            await uploadImageToFirebaseStorage(_selectedImage!, imageName);

        if (imageURL.isNotEmpty) {
          setState(() {
            _imageURL = imageURL;
          });

          // Call the function to add or edit data after the image upload is complete
          widget.kosID != null ? _editKosData() : _addKosData();
        } else {
          // Handle error uploading image
          _showSnackBar('Error uploading image');
        }
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

// Fungsi tambahan untuk edit gambar pada _editKosData
  Future<void> _editUploadImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });

        String imageName = 'kos_${DateTime.now().millisecondsSinceEpoch}.jpg';
        String imageURL =
            await uploadImageToFirebaseStorage(_selectedImage!, imageName);

        if (imageURL.isNotEmpty) {
          setState(() {
            _imageURL = imageURL;
          });

          // Call the function to edit data after the image upload is complete
          _editKosData();
        } else {
          // Handle error uploading image
          _showSnackBar('Error uploading image');
        }
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

// Fungsi edit data yang akan memanggil _editUploadImage
  void _editKosData() {
    try {
      String namaKos = _namaController.text.trim();
      String alamatKos = _alamatController.text.trim();
      int hargaKos = int.tryParse(_hargaController.text) ?? 0;
      int bedrooms = int.tryParse(_bedroomsController.text) ?? 0;
      int bathrooms = int.tryParse(_bathroomsController.text) ?? 0;

      if (namaKos.isEmpty || alamatKos.isEmpty || hargaKos == 0) {
        _showSnackBar('Semua field harus diisi dengan benar!');
        return;
      }

      if (_selectedImage != null) {
        // Jika user memilih gambar baru, replace gambar lama
        uploadImageToFirebaseStorage(_selectedImage!,
                'kos_${DateTime.now().millisecondsSinceEpoch}.jpg')
            .then((newImageURL) {
          // Setelah gambar baru di-upload, update data di Firestore
          FirebaseFirestore.instance
              .collection('kokosan')
              .doc('kota')
              .collection('semarang')
              .doc(widget.kosID)
              .update({
            'nama': namaKos,
            'alamat': alamatKos,
            'harga': hargaKos,
            'gambarURL': newImageURL,
            'bedrooms': bedrooms,
            'bathrooms': bathrooms,
          }).then((value) {
            _showSnackBar('Data Kos berhasil diedit!');
            Navigator.pop(context); // Close the page
          }).catchError((error) {
            _showSnackBar('Terjadi kesalahan. Silakan coba lagi.');
          });
        });
      } else {
        // Jika user tidak memilih gambar baru, update data tanpa mengganti gambar
        FirebaseFirestore.instance
            .collection('kokosan')
            .doc('kota')
            .collection('semarang')
            .doc(widget.kosID)
            .update({
          'nama': namaKos,
          'alamat': alamatKos,
          'harga': hargaKos,
          'bedrooms': bedrooms,
          'bathrooms': bathrooms,
        }).then((value) {
          _showSnackBar('Data Kos berhasil diedit!');
          Navigator.pop(context); // Close the page
        }).catchError((error) {
          _showSnackBar('Terjadi kesalahan. Silakan coba lagi.');
        });
      }
    } catch (error) {
      print('Error editing Kos data: $error');
    }
  }
}
