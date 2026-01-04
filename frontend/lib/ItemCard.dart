import 'package:flutter/material.dart';
import "CardItem.dart";

//this is the widget Card of any title.
class ItemCard extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onWatchlistToggle;
  final VoidCallback onLovedToggle;
  final CardItem item;
  final bool isSaved;
  final bool isLoved;

  const ItemCard({
    Key? key,
    required this.item,
    required this.onTap,
    required this.onWatchlistToggle,
    required this.onLovedToggle,
    this.isSaved = false,
    this.isLoved = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 220,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 1. Background Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item.posterUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.broken_image, color: Colors.white54),
                ),
              ),
            ),

            // 2. Gradient Overlay (Darker at top and bottom for visibility)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.9),
                  ],
                  stops: const [0.0, 0.2, 0.5, 1.0],
                ),
              ),
            ),

            // 3. TOP LEFT: Loved Toggle
            Positioned(
              top: 2,
              left: 2,
              child: IconButton(
                onPressed: onLovedToggle,
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
                icon: Icon(
                  isLoved ? Icons.favorite : Icons.favorite_border,
                  color: isLoved ? Colors.red : Colors.white,
                  size: 24,
                ),
              ),
            ),

            // 4. TOP RIGHT: Watchlist Toggle
            Positioned(
              top: 2,
              right: 2,
              child: IconButton(
                onPressed: onWatchlistToggle,
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
                icon: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_add_outlined,
                  color: isSaved ? Colors.green : Colors.white,
                  size: 24,
                ),
              ),
            ),

            // 5. BOTTOM CONTENT
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Metadata Row: Rating and Type Badge
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        item.rating!.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      // NEW TYPE BADGE LOCATION
                      _buildTypeBadge(),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  _buildBottomInfo(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Small refined Badge for the bottom metadata row
  Widget _buildTypeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: item.color.withOpacity(0.8),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        item.typeDisplayName.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 8,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildBottomInfo() {
    bool isTv = item.mediaType == "tv" && item.seasons != null;
    return Text(
      isTv
          ? "${item.releaseYear} • ${item.seasons} Seasons"
          : "${item.releaseYear}",
      style: TextStyle(color: Colors.grey[400], fontSize: 10),
    );
  }
}
