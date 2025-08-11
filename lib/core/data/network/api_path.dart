class ApiPaths {
  /// Url path
  static String baseURL = 'https://m9-driver-api.onrender.com/api/v1';
  static String baseURLWebView = 'https://m9.skvgroup.online/';
  static String baseURLSocket = 'wss://m9-driver-api.onrender.com';
  static String baseURLMQTT = 'mqtt://13.229.79.236:1883';
  static String baseURLMQTT2 = 'ws://13.229.79.236:8083/mqtt';
  static String registerOnline = 'https://m9-fe.netlify.app?sessionID=';
  static String mqtt = 'https://h41770c0.ala.dedicated.aws.emqxcloud.com';
  static String mqttURL = 'mqtts://mqtt.lxserve.xyz:8883';
  static String mqttURL2 = 'https://mqtt.lxserve.xyz:1883';
  static String sessionID = '&path=register-driver';
  
  /// Http request methods
  static const String getRequest = 'get';
  static const String postRequest = 'post';
  static const String putRequest = 'put';
  static const String patchRequest = 'patch';
  static const String deleteRequest = 'delete';
  //---------------------- auth ---------------------
  static String loginPath = '${baseURL}/user/login';
  static String refreshTokenPath = '${baseURL}/user/refreshToken';
  static String registerPath = '${baseURL}/user/register';
  static String forgotPasswordPath = '${baseURL}/user/forget-password';
  static String resetPasswordPath = '${baseURL}/user/reset-password';
  static String google = '${baseURL}/user/register/google';
  static String changePasswordPath = '${baseURL}/user/change-password';
  static String getProfilePath = '${baseURL}/user/me';
  static String updateProfile = '${baseURL}/user/update/';
  static String updateProfileImage = '${baseURL}/user/updateProfile/';
  static String editPassword = '${baseURL}/user/updatePassword';
  static String editBank = '${baseURL}/user/updatePassword';
  //---------------------- bank account ---------------------
  static String getBankAccountsPath = '${baseURL}/user/bank-account';
  static String addBankAccountPath = '${baseURL}/user/add-bank-account';
  static String editBankAccountPath = '${baseURL}/user/edit-bank-account';
  //---------------------- phone number ---------------------
  static String checkPhoneAvailablePath = '${baseURL}/user/available-phone';
  static String changePhoneNumberPath = '${baseURL}/user/change-phone-number';
  static String availablePhoneNumber = '${baseURL}/user/available-phone';
  //---------------------- home ---------------------
  static String getservicePath = '${baseURL}/user/service/getall';
  static String getbannerPath = '${baseURL}/user/banner/getall';
  static String getCarTypePath = '${baseURL}/user/car-type/getall';
  //---------------------- order ---------------------
  static String createOrderCustomer = '${baseURL}/user/customer/order/create'; // ການສ້າງ
  static String createOrderDriver = '${baseURL}/user/driver/order/create';
  static String getUserSurveyDriver = '${baseURL}/user/customer/order/drivers?';
  //---------------------- driver ---------------------
 static String chooseOrder = '${baseURL}user/driver/order/choose/:id'; // ແມ່ນdriver ກົດຍອມຮັບ ຕ້ອງ login ເຂົ້າ driver ແລະ customer ແຍກກັນ
 static String chooseDriver = '${baseURL}/user/customer/order/choose-driver'; // ລູກຄ້າກົດຍອດຮັບ
 static String updateDriverProgress = '${baseURL}/user/driver/order/progress/:id'; // ເຈົ້າຂອງລົດກົດຮັບຄົນຂື້ນລົດ
 static String updateDriverSuccess = '${baseURL}/user/driver/order/complete'; // ເຈົ້າຂອງລົດກົດຮັບຄົນຂື້ນລົດ
 static String reviewDriver = "${baseURL}user/order/customer/review"; // review driver
}
