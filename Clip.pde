class Clip {
  String Dance;
  String file;

  public Clip(String d, String f) {
    Dance = d;
    file = f;
  }

  String getFile() {
    return file;
  }

  String getDanceName() {
    return Dance;
  }
}