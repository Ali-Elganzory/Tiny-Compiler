extension Retraction on StringBuffer {
  String retracted() {
    return toString().substring(0, length - 1);
  }
}
