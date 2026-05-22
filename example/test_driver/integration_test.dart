// ignore_for_file: avoid_print

import 'dart:developer';
import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() async {
  try {
    await integrationDriver(
      onScreenshot: (name, image, [args]) async {
        final File imageFile =
            await File('screenshots/$name.png').create(recursive: true);

        print('imageFile: ${imageFile.absolute.path}');
        imageFile.writeAsBytesSync(image);
        return Future.value(true);
      },
    );
  } catch (e) {
    log('Error occured: $e');
  }
}
