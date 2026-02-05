import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Fix these imports based on your folder structure
import 'features/listings/data/listing_service.dart';
import 'features/listings/domain/listing_model.dart';

const bool isDemoMode = true; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const CEMApp());
}

class CEMApp extends StatelessWidget {
  const CEMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CEM IITJ',
      theme: ThemeData(
        primaryColor: const Color(0xFF003366),
        useMaterial3: true,
      ),
      // Update: Directly show the live feed for testing
      home: isDemoMode ? MarketplaceFeed() : const LoginPage(),
    );
  }
}

// Update this to use the MarketplaceFeed logic
class MainMarketplacePage extends StatelessWidget {
  const MainMarketplacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MarketplaceFeed(); 
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Real Login Page - REQ-1 Implementation")),
    );
  }
}

// This remains the same as your code, just ensures it's in the same file
class MarketplaceFeed extends StatelessWidget {
  final ListingService _service = ListingService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CEM Marketplace"),
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<Listing>>(
        stream: _service.getListings(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final listings = snapshot.data!;
          
          if (listings.isEmpty) {
            return const Center(child: Text("No items for sale yet. Add one in the console!"));
          }

          return ListView.builder(
            itemCount: listings.length,
            itemBuilder: (context, index) {
              final item = listings[index];
              return ListTile(
                leading: const Icon(Icons.shopping_bag, color: Color(0xFF003366)),
                title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("₹${item.price}"),
                trailing: Chip(label: Text(item.category)),
              );
            },
          );
        },
      ),
    );
  }
}