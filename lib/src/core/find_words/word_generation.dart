class WordGeneration {
  /// Find possible words if the user missed a letter
  static List<String> delete(String wordMisspelled) {
    if (wordMisspelled.length <= 1) {
      return [];
    }

    List<String> deletes = [];

    for (int i = 0; i < wordMisspelled.length; i++) {
      String prefix = wordMisspelled.substring(0, i);
      String suffix = wordMisspelled.substring(i + 1, wordMisspelled.length);

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
  static List<String> swap(String wordMisspelled) {
    if (wordMisspelled.length <= 1) {
      return [];
    }

    List<String> swaps = [];

    for (int i = 1; i < wordMisspelled.length - 1; i++) {
      String prefix = wordMisspelled.substring(0, i - 1);
    }

    return swaps;
  }

  /*
  def insert(word):
  letters = string.ascii_lowercase
  return [l + c + r for l, r in split(word) for c in letters]
   */
  /// Find possible words if user missed some char
  static List<String> insert(String wordMisspelled, List<String> letters) {
    if (wordMisspelled.isEmpty) {
      return [];
    }

    List<String> inserted = [];
    for (int i = 0; i < wordMisspelled.length + 1; i++) {
      for (String letter in letters) {
        String prefix = wordMisspelled;
        String suffix = '';

        if (i < wordMisspelled.length) {
          prefix = wordMisspelled.substring(0, i);
          suffix = wordMisspelled.substring(i, wordMisspelled.length);
        }

        String possibleMisspell = prefix + letter + suffix;
        inserted.add(possibleMisspell);
      }
    }
    return inserted;
  }

  /*
  def replace(word):
  letters = string.ascii_lowercase
  return [l + c + r[1:] for l, r in split(word) if r for c in letters]

print(replace("trash"))
   */
  /// Find possible words if user replaced some char
  static List<String> replace(String wordMisspelled, List<String> letters) {
    if (wordMisspelled.isEmpty) {
      return [];
    }

    List<String> inserted = [];
    //TODO
    return inserted;
  }
}
