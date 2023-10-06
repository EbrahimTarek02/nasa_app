class ResponseModel {
  String response;

  ResponseModel({required this.response});

  factory ResponseModel.fromJSON (jsonBody) {
    return ResponseModel(response: jsonBody['endPointttttttttt']);
  }
}