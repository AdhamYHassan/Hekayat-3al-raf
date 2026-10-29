class ApiEndpoints {
  static const String baseUrl = 'https://sps.beefirst.net/api/';
  static const String vehicles = 'lookups/vehicles';
  static const String sendOtp = 'auth/phone/send-code';
  static const String verifyOtp = 'auth/phone/verify';
  static const String logout = 'auth/logout';
  static const String deleteAccount = 'auth/delete-account';
  static const String updateFirebaseToken = 'auth/firebase-token';
  static const String anonymousLogin = '/auth/check-phone';
  static const String addVehicle = 'me/vehicles';
  static const String requestTypes = 'lookups/request-types';
  static const String requestSparePart = 'part-requests';
  static const String carMakes = 'lookups/car-makes';
  static const String registerVendor = 'vendor/register';
  static const String latestOffers = 'part-requests/latest';
  static const String matchedRequests = 'vendor/requests';
  static const String vendorOffers = 'vendor/offers/history';
  static const String updateProfile = 'auth/profile';
  static const String addresses = 'me/addresses';
  static const String countries = 'lookups/countries';
  static const String slider = 'sliders/';
  static const String homeLookUps = 'lookups/car-makes?show_all=1';
  static const String appContent = 'app/content';
  // Example / common endpoints can be added here
  // static const String login = 'auth/login';
}
