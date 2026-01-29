class ApiEndpoints {
  static const String login = '/api/Auth/Login';
  static const String getAllDoctors = '/api/Admin/GetAllDoctor';
  static const String getAllPatients = '/api/Admin/GetAllPatients';
  static const String getNotifications = '/api/Admin/GetAdminNotification';
  static const String getDoctorById = '/api/Admin/GetDoctorById';
  static const String getPatientById = '/api/Admin/GetPatientById';
  static const String approveOrDisapprove = '/api/Admin/ApproveOrDisApprove';
    static const String reviewWalletRequest = '/api/Admin/ReviewWalletRequest';
  static const String getAllDoctorsWalletRequests =
      '/api/Admin/GetAllDoctorsWalletRequests';
  static const String getDoctorTransactions = '/api/Admin/GetDoctorTransactions'; // Actually this is dynamic in remote source, but let's keep it here if used or just omit? Wait, I used dynamic string interpolation in RemoteDataSource.
  // The user provided: /api/Admin/3014/transactions?PageNumber=1&PageSize=10
  // So I don't strictly need a constant if I build it dynamically.
  // But AddBalanceToDoctor is: /api/Admin/AddBalanceToDoctor
  static const String addBalanceToDoctor = '/api/Admin/AddBalanceToDoctor';
  static const String fcmSend = 'https://fcm.googleapis.com/fcm/send';
}
