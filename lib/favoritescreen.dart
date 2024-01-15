import 'package:flutter/material.dart';
import 'package:mobile_kokosan/detailkos.dart';
import 'package:provider/provider.dart';

class FavoritesProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _favorites = [];

  List<Map<String, dynamic>> get favorites => _favorites;

  void addToFavorites(Map<String, dynamic> kosData) {
    _favorites.add(kosData);
    notifyListeners();
  }

  bool isFavorite(Map<String, dynamic> kosData) {
    return _favorites.contains(kosData);
  }

  void toggleFavorite(Map<String, dynamic> kosData) {
    if (isFavorite(kosData)) {
      _favorites.remove(kosData);
    } else {
      _favorites.add(kosData);
    }
    notifyListeners();
  }
}

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    var favoritesProvider = context.watch<FavoritesProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: favoritesProvider.favorites.length,
        itemBuilder: (BuildContext context, int index) {
          var favoriteItem = favoritesProvider.favorites[index];

          return ListTile(
            title: Text(favoriteItem['nama'] ?? 'No Title'),
            subtitle: Text(favoriteItem['alamat'] ?? 'No Location'),
            onTap: () {
              // Aksi ketika item dipilih
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailKosScreen(kosData: favoriteItem),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
