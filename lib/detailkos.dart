import 'package:flutter/material.dart';
import 'package:mobile_kokosan/favoritescreen.dart';
import 'package:mobile_kokosan/pembayaran.dart';
import 'package:provider/provider.dart';

class DetailKosScreen extends StatelessWidget {
  final Map<String, dynamic> kosData;
  DetailKosScreen({required this.kosData});

  @override
  Widget build(BuildContext context) {
    bool isFavorite = context.watch<FavoritesProvider>().isFavorite(kosData);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Kos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              kosData['nama'] ?? 'No Title',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              kosData['alamat'] ?? 'No Location',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Harga: \Rp.${kosData['harga'] ?? 0},00',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            // Add more details as needed
            Text(
              'Bedrooms: ${kosData['bedrooms'] ?? 0}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Text(
              'Bathrooms: ${kosData['bathrooms'] ?? 0}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            // Add more details as needed

            SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/home.png', // Replace with the actual image URL from kosData
                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            SizedBox(height: 16),

            // Add buttons for additional options
            ElevatedButton.icon(
              onPressed: () {
                context.read<FavoritesProvider>().toggleFavorite(kosData);
              },
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              label: Text('Favorite'),
            ),
            // detailkos.dart
            ElevatedButton(
              onPressed: () async {
                var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Pembayaran(
                      kosData: kosData,
                    ),
                  ),
                );

                // Handle the result if needed
                if (result != null && result is bool) {
                  if (result) {
                    // Payment was successful, update UI or take any necessary actions
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Payment successful!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    // Payment failed or was canceled, handle accordingly
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Payment failed or canceled.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }
              },
              child: Text('Pembayaran'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/pesan');
              },
              child: Text('Chat dengan Pemilik'),
            ),
          ],
        ),
      ),
    );
  }
  // Add additional methods for removing from favorites, etc.
}
