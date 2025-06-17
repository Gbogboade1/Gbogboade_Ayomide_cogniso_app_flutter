abstract interface class Failure<E> implements Exception {
  E get errorCode;
}
