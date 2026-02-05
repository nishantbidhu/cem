enum ListingStatus { available, sold, archived }

class Listing {
  final String id;
  final String title;
  final String description;
  final double price;
  final String category;
  final String? imageUrl;
  final ListingStatus status;
  final String sellerId; // We will use a dummy ID like 'user_123' for now

  Listing({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    this.imageUrl,
    this.status = ListingStatus.available,
    required this.sellerId,
  });

  // Converts Firestore data to a Listing object
  factory Listing.fromMap(Map<String, dynamic> data, String documentId) {
    return Listing(
      id: documentId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      category: data['category'] ?? 'Uncategorized',
      imageUrl: data['imageUrl'],
      sellerId: data['sellerId'] ?? 'anonymous',
    );
  }

  // Converts Listing object to Firestore data
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'sellerId': sellerId,
      'status': status.name,
    };
  }
}