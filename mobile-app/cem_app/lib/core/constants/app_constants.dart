class AppConstants {
  // Requirement REQ-2: Campus-only user access (Planned)
  static const String campusDomain = 'iitj.ac.in';
  
  // Demo account for early Sprint 2 testing
  static const String demoEmail = 'cemiitjtest@gmail.com';
  
  // Requirement REQ-10: Target admin response time
  static const Duration adminReportTimeout = Duration(hours: 48);

  static const List<String> hostels = [
    'B1', 'B2', 'B3', 'B4', 'B5', 
    'G2', 'G3', 'G4', 'G5', 'G6', 
    'I2', 'I3', 'O3', 'O4', 'Y3', 'Y4'
  ];
}