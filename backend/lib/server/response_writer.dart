import 'dart:collection';

class ResponseWriter {
  String protocol = "HTTP/1.1";
  int statusCode = 200;
  String status = "OK";
  String contentType = "text/html";
  String content = "";
  HashMap<String, dynamic> headers = HashMap();

  ResponseWriter();

  operator []=(String key, dynamic value) {
    headers[key] = value;
  }

  void setProtocol(String value) {
    protocol = value;
  }

  void setStatusCode(int value) {
    statusCode = value;
  }

  void setStatus(String value) {
    status = value;
  }

  void setContentType(String value) {
    contentType = value;
  }

  void setContent(String value) {
    content = value;
  }

  void setJsonContent(String value) {
    contentType = "application/json";
    setContent(value);
  }

  int getContentLength() {
    return toString().length;
  }

  String getResponse() {
    return toString();
  }

  @override
  String toString() {
    var headerStr = headers.entries
        .map((e) => "${e.key}: ${e.value}\r\n")
        .toList()
        .join("");

    return "$protocol $statusCode $status\r\nContent-Type: $contentType\r\n$headerStr\r\n\r\n$content";
  }
}
