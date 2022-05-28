import 'dart:convert';

import 'package:backend/server/server.dart';

void run() {
  var app = Server();
  app.get("/home", (responseWriter, request) {
    responseWriter.setContent("home");
  });

    app.get("/about", (responseWriter, request) {
    responseWriter.setContent("about");
  });

    app.get("/surla", (responseWriter, request) {
    responseWriter.setContent("surla");
  });

    app.get("/api", (responseWriter, _) {
    responseWriter.setJsonContent(jsonEncode({"success": true}));
  });

  
  app.listen(() {
    print("server listening at http://localhost:${app.port}");
  });
}
