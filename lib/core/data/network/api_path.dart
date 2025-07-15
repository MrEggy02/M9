class ApiPaths {
  /// Url path
  static String baseURL = 'https://m9-driver-api.onrender.com/api/v1';
  static String baseURLSocket = 'wss://m9-driver-api.onrender.com';
  static String registerOnline = 'https://m9-fe.netlify.app?sessionID=';
  static String sessionID = '&path=register-driver';

  /// Http request methods
  static const String getRequest = 'get';
  static const String postRequest = 'post';
  static const String putRequest = 'put';
  static const String patchRequest = 'patch';
  static const String deleteRequest = 'delete';
  //---------------------- auth ---------------------
  static String loginPath = '${baseURL}/user/login';
  static String refreshTokenPath = '${baseURL}/refreshToken';
  static String registerPath = '${baseURL}/register';
  static String forgotPasswordPath = '${baseURL}/user/forgotpassword';
  static String changePasswordPath = '${baseURL}/user/change-password';
  static String getProfilePath = '${baseURL}/user/profile';
  static String updateProfile = '${baseURL}/user/update/';
  static String updateProfileImage = '${baseURL}/user/updateProfile/';
  static String editPassword = '${baseURL}/user/updatePassword';

  //---------------------- home ---------------------
  static String getservicePath = '${baseURL}/user/service/getall';
  static String getbannerPath = '${baseURL}/user/banner/getall';
  static String getCarTypePath = '${baseURL}/user/car-type/getall';
  //---------------------- order ---------------------
  static String createOrderCustomer = '${baseURL}/user/customer/order/create';
  static String createOrderDriver= '${baseURL}/user/driver/order/create';
  static String getUserSurveyDriver = '${baseURL}/user/customer/order/drivers?';
  //---------------------- threatend ---------------------

}