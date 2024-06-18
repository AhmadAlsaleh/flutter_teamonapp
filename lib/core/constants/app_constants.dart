class AppConstants {
  static const String authShared = 'auth_model';

  static const String baseUrl = 'http://192.168.0.162:3000/api';
  static const String loginEndpoint = '/auth/login';
  static const String logoutEndpoint = '/auth/logout';
  static const String checkAuthEndpoint = '/auth/check';
  static const String usersEndpoint = '/users';

  static const String workSessionsEndpoint = '/workSessions';
  static const String workStepsEndpoint = '/workSteps';

  static const String addFCMTokenEndpoint = '/fcm/add-token';
  static const String notificationsEndpoint = '/fcm/get-notifications';
  static const String readNotificationEndpoint = '/fcm/read-notification';
}
