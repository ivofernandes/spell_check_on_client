import 'package:spell_check_on_client/src/core/spell_check.dart';
import 'package:test/test.dart';

void main() {
  test('Simple Amharic test', () {
    final SpellCheck spellCheck = SpellCheck.fromWordsList(
      ['እንቋዕ', 'ሰላም', 'ሀሌሉያ'], // ['Hello', 'Peace', 'Hallelujah']
      letters:
          'አኡኢኣኤእኦኧከኩኪካኬክኮኳኸኹኺኻኼኽኾወዉዊዋዌውዎዐዑዒዓዔዕዖቀቁቂቃቄቅቆቋቌቍቐቑቒቓቔቕቖቘ቙ቚቛቜቝ቞በቡቢባቤብቦቧቨቩቪቫቬቭቮቯተቱቲታቴትቶቷቸቹቺቻቼችቾኀኁኂኃኄኅኆኋኌኍነኑኒናኔንኖኗኘኙኚኛኜኝኞኟአኡኢኣኤእኦኧከኩኪካኬክኮኳኸኹኺኻኼኽኾወዉዊዋዌውዎዐዑዒዓዔዕዖቀቁቂቃቄቅቆቋቌቍቐቑቒቓቔቕቖቘ቙ቚቛቜቝ቞በቡቢባቤብቦቧቨቩቪቫቬቭቮቯተቱቲታቴትቶቷቸቹቺቻቼችቾኀኁኂኃኄኅኆኋኌኍነኑኒናኔንኖኗ'
              .split(''), // Amharic letters
    );

    // Test for exact match
    String didYouMean = spellCheck.didYouMeanWord('ሰላም'); // 'Peace'
    expect(didYouMean, 'ሰላም'); // 'Peace'

    // Test for a close match
    // Both translate to the american greeting 'Hello' a.k.a 'Selam'
    didYouMean =
        spellCheck.didYouMeanWord('ሰላምም'); // 'Peace' with an extra letter
    expect(didYouMean, 'ሰላም'); // 'Peace'

    // Test for a completely different word
    didYouMean = spellCheck.didYouMeanWord('አማርኛ'); // 'Amharic'
    expect(didYouMean, isNot('ሰላም')); // 'Peace'

    // Test for a word with similar spelling
    didYouMean = spellCheck.didYouMeanWord('ሀሌሉያ'); // 'Hallelujah'
    expect(didYouMean, 'ሀሌሉያ'); // 'Hallelujah'
  });
}
