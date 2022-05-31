// ignore_for_file: unnecessary_this, prefer_initializing_formals

import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:backend/server/request_details.dart';
import 'package:backend/server/response_writer.dart';

class Server {
  late HashMap<String, HashMap<String, Function(ResponseWriter, Request)>>
      urlMapping;
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

  void listen(Function onMount) async {
    var server = await ServerSocket.bind(InternetAddress.anyIPv4, port);
    onMount();
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

  void handleFavicon(ResponseWriter rw, Request r) {
    // https://img.icons8.com/ios-filled/344/internet.png
    const fav = """
    <html>
    <head>
    </head>
    <body>
    <img src="https://img.icons8.com/ios-filled/344/internet.png">
    </body>
    </html>
    """;
    rw.setContent(fav);
    // rw.setContentType("image/*");

    // rw["accept"] = "image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8";
    // rw["accept-encoding"] = "gzip, deflate, br";
    // rw["accept-language"] = "en-US,en;q=0.9";
    // rw["referer"] = "https://img.icons8.com/ios-filled/344/internet.png";
    // rw["sec-ch-ua"] =
    //     """" Not A;Brand";v="99", "Chromium";v="101", "Microsoft Edge";v="101""";
    // rw["sec-ch-ua-mobile"] = "?0";
    // rw["sec-ch-ua-platform"] = "Windows";
    // rw["sec-fetch-dest"] = "image";
    // rw["sec-fetch-mode"] = "'no-cors'";
    // rw["sec-fetch-site"] = "same-origin";
    // rw["user-agent"] =
    //     "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.64 Safari/537.36 Edg/101.0.1210.53";
  }

  void processRequest(ResponseWriter rw, Request r) {
    if (r.partialUrl.contains("favicon.i")) return handleFavicon(rw, r);

    urlMapping[r.method]![r.partialUrl]!(rw, r);
  }

  void get(String pattern, Function(ResponseWriter, Request) function) {
    route("GET", pattern, function);
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
