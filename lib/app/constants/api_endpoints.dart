class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);
  static const String baseUrl = "http://10.0.2.2:8000/";

  // Auth Routes
  static const String login = "auth/login";
  static const String register = "auth/register";
  static const String imageUrl = "http://10.0.2.2:3000/uploads/";
  static const String uploadImage = "auth/uploadImage";
  static const String authCheck = "auth/check-auth";
  static const String updateProfile = "auth/update";



  //course routes
  static const String getCourse = "student/course/get";
  static const String getCourseById = "student/course/get/details";
  static const String purchaseInfo = "student/course/purchase-info";

  //payment
  static const String enroll = "student/courses-bought/enroll";

  //quiz and test
  static const String getQuiz = "instructor/quiz";
  static const String getQuestion = "instructor/question";




}
