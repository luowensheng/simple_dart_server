import 'dart:convert';
import 'dart:collection';

class Request {
  late String method;
  late String partialUrl;
  late String protocol;
  late HashMap<String, String> headers;
  Request(String reqStr) {
    headers = HashMap<String, String>();
    parseRequest(reqStr.replaceAll("\r", ""));
  }
  void parseRequest(String reqStr) {
    var splitStr = reqStr.split("\n");
    parseFistLine(splitStr[0]);
    parseToDict(splitStr.sublist(1));
  }

  void parseFistLine(String array) {
    var arraySplit = array.split(" ");
    method = arraySplit[0];
    partialUrl = arraySplit[1];
    protocol = arraySplit[2];
  }

  @override
  String toString() {
    return toJson();
  }

  String toJson() {
    var json = HashMap.from(headers);
    json['method'] = method;
    json['partialUrl'] = partialUrl;
    json['protocol'] = protocol;
    return jsonEncode(json);
  }

  void parseToDict(List<String> array) {
    for (var line in array) {
      var elements = line.split(":");
      if (elements.length == 2) {
        headers[elements[0]] = elements[1];
      } else {
        headers[elements[0]] = elements.sublist(1).join(":");
      }
    }
  }
}
