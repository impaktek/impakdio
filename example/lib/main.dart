import 'dart:developer';

import 'package:example/src/domain/sample_api_response_model.dart';
import 'package:flutter/material.dart';
import 'package:impakdio/config/exceptions/impakdio_exceptions.dart';
import 'package:impakdio/config/impakdio_response.dart';
import 'package:impakdio/config/request_methods.dart';
import 'package:impakdio/impakdio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

String token = "";
String baseUrl = "";
class _MyHomePageState extends State<MyHomePage> {
  String? error;
  List<Post> _response = [];
  late Impakdio impakdio;

  @override
  void initState() {
    impakdio = Impakdio();
    impakdio.initBaseUrl(baseUrl);
    Impakdio.setAuthenticationToken(token);
    WidgetsBinding.instance.addPostFrameCallback((_){
      _safeCall();
    });
    super.initState();
  }

  void _call() async{
    try {
      setState(() {
        _response = [];
      });
      final params = {
        "page": 19,
        "size": 3
      };
      final header = {
        "Authorization": "Bearer $token"
      };
      final result = await impakdio.call(
        path: '/api/v1/feeds/news',
        queryParams: params,
        headers: header,
        useAuthorization: false,
        withCancelToken: true,
        method: RequestMethod.GET,
      );
      if(result.isSuccessful){
        final response = ApiResponseModel.fromJson(result.data);
        _response = response.data.posts;
        error = null;
      }else {
        _response = [];
        error = result.error["message"];
      }

    } catch(e){
      if(e.runtimeType == ImpakdioException){
        e as ImpakdioException;
        setState(() {
          _response = [];
          error = e.message;
        });
        switch(e.type){
          case ExceptionType.TIMEOUT_ERROR:
          // TODO: Handle this case.
          case ExceptionType.SERVER_ERROR:
          // TODO: Handle this case.
          case ExceptionType.UNKNOWN_ERROR:
          // TODO: Handle this case.
          case ExceptionType.AUTHORISATION_ERROR:
          // TODO: Handle this case.
          case ExceptionType.CONNECTION_ERROR:
          // TODO: Handle this case.
          case ExceptionType.MAPPING_ERROR:
          // TODO: Handle this case.
          case ExceptionType.BAD_REQUEST:
            // TODO: Handle this case.
          case ExceptionType.CANCELLED_ERROR:
            // TODO: Handle this case.
        }
      }else{
        setState(() {
        _response = [];
        error = e.toString();
      });
      }

    }
  }

  void _safeCall() async{
    final result = await impakdio.typeSafeCall<ApiResponseModel>(
      path: '/api/v1/feeds/news',
      method: RequestMethod.GET,
      baseUrl: baseUrl,
      successFromJson: (json)=> ApiResponseModel.fromJson(json),
    );
    setState(() {
      switch(result){
        case ImpakdioSuccess():
          _response = result.data.data.posts;
          log(result.data.toString());
        case ImpakdioFailure():
          error = result.error["message"];
          log(result.error.toString());
        case ImpakdioError():
          log(result.exception.toString());
          error = result.exception.message;
        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        
        child: Column(
          children: <Widget>[
            
            if(_response.isNotEmpty)...[
              Text('TODOS', style: TextStyle(fontWeight: FontWeight.w600),),
              Flexible(child: ListView.builder(itemCount: _response.length, itemBuilder: (_, index)=> Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Column(
                  children: [
                    Text(_response[index].title, style: TextStyle(fontWeight: FontWeight.w500),),
                    const SizedBox(height: 8,),
                    Text(_response[index].title),
                  ],
                ),
              )))
            ],
            if(error != null)...[
              Text(
                'Request Error',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                '$error',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ]
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _call,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
