class ApiPaths {
  /// Url path
  static String baseURL = 'https://m9-driver-api.onrender.com/api/v1';

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
  static String updateAddress = '${baseURL}/user/updateAddress/';
  static String updateProfileImage = '${baseURL}/user/updateProfile/';
  static String editPassword = '${baseURL}/user/updatePassword';
  //---------------------- address ---------------------
  static String provincePath = '${baseURL}/provinces';
  static String districtPath = '${baseURL}/districts?provinceId=';
  static String villageIdPath = '${baseURL}/villages?districtId=';
  //---------------------- PatrollingReport ---------------------
  static String getPatrollingReport = '${baseURL}/parollingReport/getMany';
  static String getOnePatrollingReport = '${baseURL}/parollingReport/get/';
  static String postPatrollingReport = '${baseURL}/parollingReport/create';
  static String putPatrollingReport = '${baseURL}/parollingReport/update/';
  //---------------------- threatend ---------------------

  static String postThreatenedSpecial = '${baseURL}/threatenedSpecies/create';
  static String postHunting = '${baseURL}/hunting/create';
  static String getOneThreatenedSpecial = '${baseURL}/threatenedSpecies/get/';
  static String postOther = '${baseURL}/otherDisturbances/create';
  //---------------------- hunting ---------------------
  static String getOneHunting = '${baseURL}/hunting/get/';
  //---------------------- other ---------------------
  static String getOneotherDisturbances = '${baseURL}/otherDisturbances/get/';
}