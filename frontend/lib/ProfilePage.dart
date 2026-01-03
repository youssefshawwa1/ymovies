import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AuthProvider.dart';
import "Sections.dart";
import 'WatchlistProvider.dart';
import "LovedProvider.dart";
import "EditProfilePage.dart";

class ProfilePage extends StatelessWidget {
  // 1. Remove the 'userData' requirement from the constructor
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 2. "Watch" the AuthProvider for changes
    final authProvider = context.watch<AuthProvider>();
    final userData = authProvider.userData;

    // 3. Handle a potential null case (though usually, they are logged in)
    if (userData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // 1. User Header
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.redAccent,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 15),

          // Now these text widgets will update instantly!
          Text(
            "${userData['firstName']} ${userData['lastName']}",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            "${userData['email']}",
            style: const TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 30),

          // ... rest of your action buttons (Edit Profile, Watchlist, etc.) ...
          _buildProfileOption(
            icon: Icons.edit,
            title: "Edit Profile",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfilePage(),
                ),
              );
            },
          ),

          _buildProfileOption(
            icon: Icons.bookmark,
            title: "My Watchlist",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Consumer<WatchlistProvider>(
                    builder: (context, watchlist, child) {
                      return GridSection(
                        // Use a unique key for the watchlist
                        key: const ValueKey('watchlist_grid'),
                        url: "",
                        type: "mix",
                        title: "My Watchlist",
                        // Pass the live list from the provider
                        items: watchlist.watchlistItems,
                      );
                    },
                  ),
                ),
              );
            },
          ),
          _buildProfileOption(
            icon: Icons.favorite,
            title: "Loved",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Consumer<LovedProvider>(
                    builder: (context, watchlist, child) {
                      return GridSection(
                        // Use a unique key for the watchlist
                        key: const ValueKey('loved_grid'),
                        url: "",
                        type: "mix",
                        title: "My Loved List",
                        // Pass the live list from the provider
                        items: watchlist.lovedItems,
                      );
                    },
                  ),
                ),
              );
            },
          ),

          // ... rest of your options ...
          const Divider(color: Colors.grey, height: 40),

          // 3. Logout Button
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () {
              // Note: Use listen:false inside callbacks like onTap
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}








  // Helper widget to keep the code clean

