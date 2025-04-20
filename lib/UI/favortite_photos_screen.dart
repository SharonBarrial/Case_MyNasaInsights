import 'package:flutter/material.dart';
import 'package:eb20242u202114900/utils/db_helper.dart';
import 'package:eb20242u202114900/models/PhotoInfo.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<PhotoInfo> favoritePhotos = [];
  late DbHelper dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    List<PhotoInfo> favorites = await dbHelper.getFavorites();
    setState(() {
      favoritePhotos = favorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Favorite Photos"),
      ),
      body: favoritePhotos.isEmpty
          ? Center(
              child: Text(
                "No favorite photos yet",
                style: TextStyle(fontSize: 18),
              ),
            )
              : ListView.builder(
              itemCount: favoritePhotos.length,
              itemBuilder: (BuildContext context, int index) {
                return PhotoRow(favoritePhotos[index], onFavoriteToggled: loadFavorites);
              },
            ),
    );
  }
}

class PhotoRow extends StatelessWidget {
  final PhotoInfo photo;
  final Function onFavoriteToggled;

  PhotoRow(this.photo, {required this.onFavoriteToggled});

  @override
  Widget build(BuildContext context) {
    String imageUrl = photo.imgSrc;
    return Card(
      color: Colors.white,
      elevation: 2,
      child: ListTile(
        leading: Hero(
          tag: 'photo_${photo.id}',
          child: imageUrl.isNotEmpty
              ? Image.network(imageUrl, fit: BoxFit.cover, width: 50, height: 50)
              : Icon(Icons.image),
        ),
        title: Text(photo.earthDate),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rover: ${photo.roverName}'),
            Text('Camera: ${photo.cameraName}'),
            SizedBox(height: 8),
          ],
        ),
        trailing: FavoriteButton(photo: photo, onFavoriteToggled: onFavoriteToggled),
      ),
    );
  }
}

class FavoriteButton extends StatefulWidget {
  final PhotoInfo photo;
  final Function onFavoriteToggled;

  FavoriteButton({required this.photo, required this.onFavoriteToggled});

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late bool isFavorite;
  late DbHelper dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
    isFavorite = widget.photo.isFavorite ?? false;
  }

  void toggleFavorite() async {
    if (isFavorite) {
      await dbHelper.deletePhoto(widget.photo);
      print("Photo removed from My favorite Photos: ${widget.photo.earthDate}");
    } else {
      await dbHelper.insertPhoto(widget.photo);
    }
    setState(() {
      isFavorite = !isFavorite;
      widget.photo.isFavorite = isFavorite;
    });
    widget.onFavoriteToggled();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : null,
      ),
      onPressed: toggleFavorite,
    );
  }
}