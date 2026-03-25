// class Listing {
//   final String id;
//   final String title;
//   final String priceText; 
//   final String category;
//   final String location; // Automatically populated from user profile
//   final String condition; 
//   final bool isSeeking;
//   final String description; 
//   final String sellerId;
//   final String? imageUrl;

//   Listing({
//     required this.id,
//     required this.title,
//     required this.priceText,
//     required this.category,
//     required this.location,
//     required this.condition,
//     this.isSeeking = false,
//     required this.description,
//     required this.sellerId,
//     this.imageUrl,
//   });

//   factory Listing.fromMap(Map<String, dynamic> data, String documentId) {
//     return Listing(
//       id: documentId,
//       title: data['title'] ?? '',
//       priceText: data['priceText'] ?? '₹0',
//       category: data['category'] ?? 'General',
//       location: data['location'] ?? 'IITJ Campus',
//       condition: data['condition'] ?? 'Used',
//       isSeeking: data['isSeeking'] ?? false,
//       description: data['description'] ?? '',
//       sellerId: data['sellerId'] ?? 'anonymous',
//       imageUrl: data['imageUrl'],
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'title': title,
//       'priceText': priceText,
//       'category': category,
//       'location': location,
//       'condition': condition,
//       'isSeeking': isSeeking,
//       'description': description,
//       'sellerId': sellerId,
//       'imageUrl': imageUrl,
//     };
//   }
// }







class Listing {
  final String id;
  final String title;
  final String priceText; 
  final String category;
  final String location;
  final String condition; 
  final bool isSeeking;
  final String description; 
  final String sellerId;
  final String? transactionCode; // Secure 6-digit handshake code
  final String? boughtBy;        // Records the student who verified the exchange
  final String? imageUrl;

  Listing({
    required this.id,
    required this.title,
    required this.priceText,
    required this.category,
    required this.location,
    required this.condition,
    this.isSeeking = false,
    required this.description,
    required this.sellerId,
    this.transactionCode,
    this.boughtBy,
    this.imageUrl,
  });

  factory Listing.fromMap(Map<String, dynamic> data, String documentId) {
    return Listing(
      id: documentId,
      title: data['title'] ?? '',
      priceText: data['priceText'] ?? '₹0',
      category: data['category'] ?? 'General',
      location: data['location'] ?? 'IITJ Campus',
      condition: data['condition'] ?? 'Used',
      isSeeking: data['isSeeking'] ?? false,
      description: data['description'] ?? '',
      sellerId: data['sellerId'] ?? 'anonymous',
      transactionCode: data['transactionCode'],
      boughtBy: data['boughtBy'],
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'priceText': priceText,
      'category': category,
      'location': location,
      'condition': condition,
      'isSeeking': isSeeking,
      'description': description,
      'sellerId': sellerId,
      'transactionCode': transactionCode,
      'boughtBy': boughtBy,
      'imageUrl': imageUrl,
    };
  }
}