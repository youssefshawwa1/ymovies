import 'package:flutter/material.dart';
import "ItemCard.dart";
import "./CardItem.dart";
import "./apiLinks.dart";
import 'Helper.dart';
import "./ItemDetailsPage.dart";
import "./apiKey/apiKey.dart";

class HorizontalSection extends StatelessWidget {
  final String title;
  final List<CardItem> items;
  final String type;
  final String kind;
  final int? id;
  const HorizontalSection({
    Key? key,
    required this.title,
    required this.items,
    required this.type,
    required this.kind,
    this.id,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 15),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  String link = "";
                  if (kind == "similar" || kind == "recommendations") {
                    link =
                        "${links["more"]["url"]}${type}/${id}/${kind}?api_key=$apiKey";
                  } else {
                    link = apiLinks[type][kind]["url"];
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          GridSection(url: link, type: type, title: title),
                    ),
                  );
                },
                child: Text(
                  'Show more +',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ), // or use a different text for the right side
            ],
          ),
        ),
        SizedBox(
          height: 224,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemExtent: 150, // 150 (card width) + 16 (margin)
            clipBehavior: Clip.none,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index] as CardItem;
              return ItemCard(
                item: item,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ItemDetailsPage(id: item.id, type: item.mediaType),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class GridSection extends StatefulWidget {
  final String url;
  final String type;
  final String title;
  const GridSection({
    super.key,
    required this.url,
    required this.type,
    required this.title,
  });
  @override
  State<GridSection> createState() => _GridSectionState();
}

class _GridSectionState extends State<GridSection> {
  List<CardItem> _d = [];
  int currentPage = 1;
  int totalPages = 1;
  bool isloading = true;
  String error = '';
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData({int pageNumber = 1}) async {
    setState(() {
      isloading = true;
    });
    try {
      final data = await Helper.getData(url: "${widget.url}&page=$pageNumber");

      setState(() {
        _d = CardItem.transform(data["results"], widget.type);
        totalPages = data["total_pages"];
      });
    } catch (e) {
      print("whatt");
      print('Error: $e');
      setState(() {
        error = 'Error: $e';
      });
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isloading) {
      return Helper.Loading();
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white), // ← Add this
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GridView.count(
              crossAxisCount: MediaQuery.of(context).size.width ~/ 150,
              shrinkWrap: true, // Constrains height
              physics:
                  NeverScrollableScrollPhysics(), // Disables inner scrolling
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 12.0,
              padding: EdgeInsets.all(16.0),
              childAspectRatio: 0.7,
              children: _d.map((item) {
                return ItemCard(
                  item: item,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ItemDetailsPage(id: item.id, type: item.mediaType),
                      ),
                    );
                  },
                );
              }).toList(),
            ),

            Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (currentPage > 1) // Show previous button only if page > 1
                    IconButton(
                      onPressed: () {
                        setState(() {
                          currentPage = currentPage - 1;
                          _fetchData(pageNumber: currentPage);
                        });
                        ;
                      },
                      icon: Icon(Icons.arrow_back, color: Colors.grey),
                    ),
                  Text(
                    "Page $currentPage of $totalPages",
                    style: TextStyle(color: Colors.grey),
                  ),
                  if (currentPage < totalPages)
                    IconButton(
                      onPressed: () {
                        setState(() {
                          currentPage = currentPage + 1;
                          _fetchData(pageNumber: currentPage);
                        });
                      },
                      icon: Icon(Icons.arrow_forward, color: Colors.grey),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
