// ignore_for_file: unnecessary_this, prefer_initializing_formals

import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:backend/server/request_details.dart';
import 'package:backend/server/response_writer.dart';

class Server {
  late HashMap<String, HashMap<String, Function(ResponseWriter, Request)>>
      urlMapping;
  late ServerSocket server;
  late int port;
  Server({int port = 8000}) {
    this.port = port;
    urlMapping =
        HashMap<String, HashMap<String, Function(ResponseWriter, Request)>>();

    urlMapping["GET"] = HashMap<String, Function(ResponseWriter, Request)>();
    urlMapping["PUT"] = HashMap<String, Function(ResponseWriter, Request)>();
    urlMapping["POST"] = HashMap<String, Function(ResponseWriter, Request)>();
    urlMapping["DELETE"] = HashMap<String, Function(ResponseWriter, Request)>();
  }

  setup() async {
    this.server = await ServerSocket.bind(InternetAddress.anyIPv4, port);
  }

  void listen(Function function) async {
    await setup();
    function();
    server.listen((client) {
      handleConnection(client);
    },
        onDone: () {},
        // onError: (Error e) {
        //   print(e);
        // },
        cancelOnError: false);
  }

  void handleConnection(Socket client) async {
    var responseWriter = ResponseWriter();
    var request = Request(utf8.decode(await client.first));
    try {
      processRequest(responseWriter, request);
    } catch (e) {
      responseWriter.setStatusCode(500);
    }
    client.add(utf8.encode(responseWriter.getResponse()));
    client.close();
  }

  void get(String pattern, Function(ResponseWriter, Request) function) {
    route("GET", pattern, function);
  }

  void processRequest(ResponseWriter rw, Request r) {
    urlMapping[r.method]![r.partialUrl]!(rw, r);
  }

  void post(String pattern, Function(ResponseWriter, Request) function) {
    route("POST", pattern, function);
  }

  void put(String pattern, Function(ResponseWriter, Request) function) {
    route("PUT", pattern, function);
  }

  void delete(String pattern, Function(ResponseWriter, Request) function) {
    route("DELETE", pattern, function);
  }

  void route(String method, String pattern,
      Function(ResponseWriter, Request) function) {
    urlMapping[method]?.putIfAbsent(pattern, () => function);
  }
}
