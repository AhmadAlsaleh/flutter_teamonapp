class AppConstants {
  static const String authShared = 'auth_model';

  static const String baseUrl = 'https://teamon.activebitsllc.com/api';
  static const String loginEndpoint = '/auth/login';
  static const String logoutEndpoint = '/auth/logout';
  static const String checkAuthEndpoint = '/auth/check';
  static const String changePasswordEndpoint = '/auth/change-password';

  static const String usersEndpoint = '/users';

  static const String workSessionsEndpoint = '/workSessions';
  static const String filterWorkSessionsEndpoint = '/workSessions/filter';
  static const String workStepsEndpoint = '/workSteps';

  static const String addFCMTokenEndpoint = '/fcm/add-token';
  static const String receivedNotificationsEndpoint = '/notifications/received';
  static const String sentNotificationsEndpoint = '/notifications/sent';
  static const String sendNotificationsEndpoint =
      '/notifications/send-notification';
  static const String readNotificationEndpoint =
      '/notifications/read-notification';
}
