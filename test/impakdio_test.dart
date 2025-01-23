import 'dart:developer';

import 'package:impakdio/config/impakdio_response.dart';
import 'package:impakdio/config/request_methods.dart';

import 'package:impakdio/impakdio.dart';

void main() async{
  Impakdio impakdio = Impakdio();
  const url = "https://nbabackend.com:8005";
  const queryParam = {
    "search": "Endurance Agbor"
  };
  final result = await impakdio.typeSafeCall<Response>(
    baseUrl: url,
    path: '/api/lawyers/find-a-lawyers',
    queryParams: queryParam,
    method: RequestMethod.GET,
    successFromJson: Response.fromJson,
  );
  switch(result){
    case ImpakdioSuccess():
      log(result.data.toString());
    case ImpakdioFailure():
      log(result.error.toString());
    default: log(result.toString());
  }
  /*setUp((){
    impakdio = Impakdio();
  });
  test("TESTING API", ()async{
    const url = "https://nbabackend.com:8005";
    const queryParam = {
      "search": "Endurance Agbor"
    };
    final responseData = Response.fromJson({"items":[{"id":117682,"scn":"SCN106120","email":"agborendurance@gmail.com","first_name":"ENDURANCE","last_name":"AGBOR,","middle_name":"OKPA","date_of_call":"30TH NOV. 2016","year_of_call":2016}],"pagination":{"page":1,"page_size":10,"total_rows":1}});
    final error = Error.fromJson({"messages": "BAD_REQUEST"});
    final result = await impakdio.typeSafeCall<Response, Error>(
      baseUrl: url,
      path: '/api/lawyers/find-a-lawyers',
      queryParams: queryParam,
      method: RequestMethod.GET,
      successFromJson: Response.fromJson,
      failureFromJson: Error.fromJson,
    );
    // Assert
    expect(result.error?.message, error.message);
  });*/
}

class Response {
  final List<Lawyer> items;

  Response({required this.items});

  factory Response.fromJson(dynamic json) {
    final items = (json['items'] as List).map((item) => Lawyer.fromJson(item)).toList();
    return Response(items: items);
  }
}

class Lawyer {
  final int id;
  final String scn;

  Lawyer({required this.id, required this.scn});

  factory Lawyer.fromJson(Map<String, dynamic> json) {
    return Lawyer(id: json['id'], scn: json['scn']);
  }
}

class Error {
  final String message;

  Error({required this.message});

  factory Error.fromJson(Map<String, dynamic> json) {
    return Error(message: json['message']);
  }
}
