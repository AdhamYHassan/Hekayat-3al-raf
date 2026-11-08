class ApiEndpoints {
  // Use direct language prefix to eliminate 302 redirects and save 300-500ms network round-trip.
  static const String baseUrl = 'https://hekayat3alraf.com/ar/api/v1/mobile/';
  static const String home = 'home/';
  static const String contact = 'contact/';
  static const String profile = 'auth/me/';
  static const String login = 'auth/login/';
  static const String register = 'auth/register/';
  static const String refreshToken = 'auth/token/refresh/';
  static const String passwordReset = 'auth/password/reset/';
  static const String passwordResetConfirm = 'auth/password/reset/confirm/';
  static String storyDetails(String id) => 'stories/$id/';
  static String voteStory(String id) => 'stories/$id/vote/';
  static String ambassadorDetails(String slug) => 'ambassadors/$slug/';
  static String ambassadorQuestions(String slug) => 'ambassadors/$slug/questions/';
  static String ambassadors({int limit = 10, int offset = 0}) =>
      'ambassadors/?limit=$limit&offset=$offset';
  static const String storyTypes = 'stories/types/';
  static const String submitStory = 'stories/submit/';
  static const String myStories = 'stories/my/';
  static String stories({
    int limit = 10,
    int offset = 0,
    String? q,
    String? sort,
    String? kind,
    String? type,
  }) {
    final params = <String, String>{
      'limit': '$limit',
      'offset': '$offset',
    };
    if (q != null && q.trim().isNotEmpty) params['q'] = q.trim();
    if (sort != null && sort.isNotEmpty) params['sort'] = sort;
    if (kind != null && kind.isNotEmpty) params['kind'] = kind;
    if (type != null && type.isNotEmpty) params['type'] = type;

    final query = Uri(queryParameters: params).query;
    return 'stories/?$query';
  }
}
