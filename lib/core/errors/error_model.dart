class ErrorModel {
  final String? errorMessage;
  final List<String>? errors;

  ErrorModel({
    this.errorMessage,
    this.errors,
  });

  factory ErrorModel.fromJson(Map<String, dynamic>? jsonData) {
    if (jsonData == null) {
      return ErrorModel(
        errorMessage: 'Something went wrong',
        errors: ['Something went wrong'],
      );
    }

    // Check for 'success' boolean and 'message' field from new API format
    final bool success = jsonData['success'] ?? false;
    final String errorMessage = jsonData['message'] ?? 'Unknown error';
    
    // If success is false, treat message as the error
    if (!success && jsonData.containsKey('message')) {
       return ErrorModel(
         errorMessage: errorMessage,
         errors: [errorMessage],
       );
    }

    final dynamic errorsRaw = jsonData['errors'];

    List<String> errorsList = [];

    if (errorsRaw is List) {
      errorsList = errorsRaw.map((e) => e.toString()).toList();
    } else if (errorsRaw is String) {
      errorsList = [errorsRaw];
    } else {
       // Fallback: if errors is null but there is a message, use it
       errorsList = [errorMessage];
    }

    return ErrorModel(
      errorMessage: errorMessage,
      errors: errorsList,
    );
  }
}
