import 'package:flutter/material.dart';
import 'package:eb20242u202114900/utils/db_helper.dart';
import 'package:eb20242u202114900/models/PhotoInfo.dart';
import 'package:eb20242u202114900/utils/http_helper.dart';

class ShowPhotosScreen extends StatefulWidget {
  @override
  State<ShowPhotosScreen> createState() => _ShowPhotosScreenState();
}

class _ShowPhotosScreenState extends State<ShowPhotosScreen> {
  List<PhotoInfo> photos = [];
  bool loading = true;
  late DbHelper dbHelper;
  int page = 1;
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
    initialize();
    initScrollController();
  }

  Future initialize() async {
    await dbHelper.openDb();
    await fetchPhotos();
  }

  Future fetchPhotos() async {
    try {
      List<PhotoInfo> fetchedPhotos = await HttpHelper.fetchPhotos(page: page);
      setState(() {
        photos.addAll(fetchedPhotos);
        page++;
        loading = fetchedPhotos.isNotEmpty;
      });
    } catch (e) {
      print('Error fetching photos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Universe Photos"),
      ),
      body: photos.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: photos.length,
              itemBuilder: (BuildContext context, int index) {
                return PhotoRow(photos[index], dbHelper);
              },
            ),
    );
  }

  void initScrollController() {
    _scrollController = ScrollController();
    _scrollController!.addListener(() {
      if (_scrollController!.position.pixels == _scrollController!.position.maxScrollExtent) {
        fetchPhotos();
      }
    });
  }
}

class PhotoRow extends StatefulWidget {
  final PhotoInfo photo;
  final DbHelper dbHelper;

  PhotoRow(this.photo, this.dbHelper);

  @override
  _PhotoRowState createState() => _PhotoRowState();
}

class _PhotoRowState extends State<PhotoRow> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    checkFavoriteStatus();
  }

  void checkFavoriteStatus() async {
    bool favorite = await widget.dbHelper.isFavorite(widget.photo);
    setState(() {
      isFavorite = favorite;
      widget.photo.isFavorite = favorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = widget.photo.imgSrc;

    return Card(
      color: Colors.white,
      elevation: 2,
      child: ListTile(
        leading: imageUrl.isNotEmpty
            ? SizedBox(
                width: 60,
                height: 60,
                child: Image.network(imageUrl, fit: BoxFit.cover),
              )
            : Icon(Icons.image),
        title: Text(widget.photo.earthDate),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rover: ${widget.photo.roverName ?? "Unknown"}'),
            Text('Camera: ${widget.photo.cameraName ?? "Unknown"}'),
            SizedBox(height: 8),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ShowPhotosScreen()),
          );
        },
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
          ),
          onPressed: () {
            setState(() {
              isFavorite = !isFavorite;
              widget.photo.isFavorite = isFavorite;

            });
            if (isFavorite) {
              widget.dbHelper.insertPhoto(widget.photo);
              print('Photo added to database: ${widget.photo.earthDate}');
            } else {
              widget.dbHelper.deletePhoto(widget.photo);
              print('Photo removed from database: ${widget.photo.earthDate}');
            }
          },
        ),
      ),
    );
  }
}