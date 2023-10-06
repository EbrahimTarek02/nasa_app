import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nasa_app/model/response_model.dart';

class Predictions {

  Future<ResponseModel?> response () async{

    String question = 'How are you?';

    ResponseModel? responseModel;

    //////////////////////////add url
    String url = 'http://10.0.2.2:5000/predict';

    final encodedBody = json.encode(question);

    final headers = {
      'Content-Type': 'application/json',
    };

    http.Response response = await http.post(Uri.parse(url), headers: headers, body: encodedBody);
    ////////////// check datatypes
    Map<String, dynamic> data = jsonDecode(response.body);
    print('data =  ${data}');
    responseModel = ResponseModel.fromJSON(data);
    print('model = ${responseModel.response}');


    if (responseModel == Null){
      print('object');
      return ResponseModel(response: 'ssss');
    }

    return responseModel;
  }
}