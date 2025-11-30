import 'package:flutter/material.dart';
import "CardItem.dart";

class ItemCard extends StatelessWidget {
  final VoidCallback onTap;
  final CardItem item;
  const ItemCard({Key? key, required this.item, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 220,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item.posterUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                // loadingBuilder: CircularProgressIndicator(),
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(Icons.broken_image, color: Colors.black),
                  );
                },
              ),
            ),

            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.9),
                  ],
                ),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 4),
                      Text(
                        item.rating!.toStringAsFixed(1),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Title
                  Text(
                    item.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),

                  // Year and Type Info
                  _buildBottomInfo(),
                ],
              ),
            ),

            // Top Badges
            Positioned(
              top: 8,
              right: 8,
              child: Column(
                children: [
                  // Content Type Badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: item.color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(item.icon, color: Colors.white, size: 12),
                        SizedBox(width: 2),
                        Text(
                          item.typeDisplayName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods for content type

  Widget _buildBottomInfo() {
    if (item.mediaType == "tv" && item.seasons != null) {
      // TV Series with seasons
      return Row(
        children: [
          Text(
            item.releaseYear.toString(),
            style: TextStyle(color: Colors.grey[300], fontSize: 12),
          ),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${item.seasons} S',
              style: TextStyle(
                color: Colors.blue[200],
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    } else {
      // Movie or TV series without seasons info
      return Text(
        item.releaseYear.toString(),
        style: TextStyle(color: Colors.grey[300], fontSize: 10),
      );
    }
  }
}
