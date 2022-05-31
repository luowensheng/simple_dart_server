```dart
void run() {

  var app = Server();
  
  app.get("/home", (responseWriter, request) {
    responseWriter.setContent("""
       <h1>Hello Surla</h1>
       <script>
       document.querySelector("h1").addEventListener("click", function(){
            this.textContent = new Date();
       })
       </script>

          """);
    responseWriter["body"] = "Home";
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

```