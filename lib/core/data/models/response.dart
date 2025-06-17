abstract class Response<E> {
  int get status;
  E? get data;
  String? get message;
  String? get code;
  List<String>? get params;
}
