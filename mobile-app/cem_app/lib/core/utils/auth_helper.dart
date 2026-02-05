class AuthHelper {
  // Requirement REQ-2: Campus-only check with demo bypass
  static bool isAuthorized(String? email) {
    if (email == null) return false;
    const String demoEmail = 'cemiitjtest@gmail.com';
    return email.toLowerCase() == demoEmail || 
           email.toLowerCase().endsWith('@iitj.ac.in');
  }
}
