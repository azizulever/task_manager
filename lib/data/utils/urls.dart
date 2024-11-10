class Urls {
  static const String _baseUrl = 'http://35.73.30.144:2005/api/v1';
  static const String registration = '$_baseUrl/Registration';
  static const String login = '$_baseUrl/Login';
  static String getEmail(String email) {
    return '$_baseUrl/RecoverVerifyEmail/$email';
  }
  static String getOTP(String email, String otp) {
    return '$_baseUrl/RecoverVerifyOtp/$email/$otp';
  }
  static const String recoverResetPassword = '$_baseUrl/RecoverResetPassword';
  static const String addNewTask = '$_baseUrl/createTask';
  static const String newTaskList = '$_baseUrl/listTaskByStatus/New';
}