class WordGeneration {
  /// Find possible words if the user missed a letter
  static List<String> delete(String word) {
    if (word.length <= 1) {
      return [];
    }

    List<String> deletes = [];

    for (int i = 0; i < word.length; i++) {
      String prefix = word.substring(0, i);
      String suffix = word.substring(i + 1, word.length);

      String block = prefix + suffix;
      deletes.add(block);
    }

    return deletes;
  }

  /*
  def swap(word):
  return [l + r[1] + r[0] + r[2:] for l, r in split(word) if len(r)>1]

print(swap("trash"))
   */
  /// Find possible words if user swapped some chars
  static List<String> swap(String word) {
    if (word.length <= 1) {
      return [];
    }

    List<String> swaps = [];
    //TODO
    return swaps;
  }

  /*
  def insert(word):
  letters = string.ascii_lowercase
  return [l + c + r for l, r in split(word) for c in letters]
   */
  /// Find possible words if user missed some char
  static List<String> insert(String word) {
    if (word.isEmpty) {
      return [];
    }

    List<String> inserted = [];
    //TODO
    return inserted;
  }

  /*
  def replace(word):
  letters = string.ascii_lowercase
  return [l + c + r[1:] for l, r in split(word) if r for c in letters]

print(replace("trash"))
   */
  /// Find possible words if user replaced some char
  static List<String> replace(String word) {
    if (word.isEmpty) {
      return [];
    }

    List<String> inserted = [];
    //TODO
    return inserted;
  }
}
