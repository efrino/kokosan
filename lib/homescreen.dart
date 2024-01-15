import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobile_kokosan/koslist.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double minHarga = 0;
  double maxHarga = 1000000;
  double ratingFilter = 0.0;
  String selectedFilter = 'Kota';
  String cityName = 'Semarang'; // Default city
  bool loading = false;

  TextEditingController minHargaController = TextEditingController();
  TextEditingController maxHargaController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  String selectedSorting = 'Harga'; // Default sorting

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16),
            Text(
              'Penawaran Spesial',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 41, 41, 41),
              ),
            ),
            SizedBox(height: 8),
            CarouselSlider(
              items: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: AssetImage('assets/city1.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: AssetImage('assets/city5.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
              options: CarouselOptions(
                height: 200.0,
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Daftar Kos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 41, 41, 41),
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedFilter = 'Harga';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        selectedFilter == 'Harga' ? Colors.blue : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.attach_money),
                      SizedBox(width: 8),
                      Text(
                        'Harga',
                        style: TextStyle(
                          color: selectedFilter == 'Harga'
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (selectedFilter == 'Rating') {
                        selectedFilter =
                            'Kota'; // Ubah ke filter default jika sudah Rating
                      } else {
                        selectedFilter = 'Rating';
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        selectedFilter == 'Rating' ? Colors.blue : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    selectedFilter == 'Rating' ? 'Hide Rating' : 'Rating',
                    style: TextStyle(
                      color: selectedFilter == 'Rating'
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        labelText: 'Cari Kos',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ),
                if (selectedFilter == 'Rating')
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Pilih Rating:'),
                        RatingBar.builder(
                          initialRating: ratingFilter,
                          minRating: 0,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 24,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              ratingFilter = rating;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                if (selectedFilter == 'Harga')
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: minHargaController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Min Harga',
                              prefixText: 'Rp ',
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: maxHargaController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Max Harga',
                              prefixText: 'Rp ',
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            minHarga = double.parse(minHargaController.text);
                            maxHarga = double.parse(maxHargaController.text);
                          });
                        },
                        child: Text('Terapkan'),
                      ),
                    ],
                  ),
              ],
            ),
            SizedBox(height: 8),
            loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    child: KosList(
                      // Pass other parameters as needed
                      searchQuery: selectedFilter == 'Rating'
                          ? null
                          : searchController.text,
                      ratingFilter:
                          selectedFilter == 'Rating' ? ratingFilter : null,
                      // Add other parameters as needed
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
