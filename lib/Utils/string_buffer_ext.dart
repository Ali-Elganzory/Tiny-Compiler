extension retraction on StringBuffer {
  String retracted() {
    return this.toString().substring(0, length - 1);
  }
}
