import '../domain/listing_model.dart';

class MockListingService {
  static List<Listing> getDummyListings() {
    return [
      Listing(
        id: '1',
        title: 'Engineering Physics Textbook',
        description: 'Hardly used, perfect for first years.',
        price: 450.0,
        category: 'Books',
      ),
      Listing(
        id: '2',
        title: 'Scientific Calculator',
        description: 'Casio fx-991EX, working perfectly.',
        price: 800.0,
        category: 'Electronics',
      ),
    ];
  }
}