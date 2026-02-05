import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/listing_model.dart';



class ListingService {
  // Access the 'listings' collection in Firestore
  final CollectionReference _listings = 
      FirebaseFirestore.instance.collection('listings');

  // REQ-3: Function to save a new item to the database
  Future<void> addListing(Listing listing) {
    return _listings.add(listing.toMap());
  }

  // REQ-4: Function to fetch all items in real-time
  // This is what the team will use to show the product feed
  Stream<List<Listing>> getListings() {
    return _listings.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Listing.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }
}