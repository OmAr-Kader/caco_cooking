import 'dart:math';
import 'package:caco_cooking/common/lifecyle.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:palette_generator/palette_generator.dart';

Future<DSack<List<String>, int>> pickImageForFood(Function() showDia, Function(Object? object) failed) async {
  try {
    final image = await ImagePicker().pickMultiImage(imageQuality: 100);
    if (image.isEmpty) {
      failed(null);
      return DSack(one: [], two: 0);
    }
    showDia();
    List<String> images = [];
    int col = await paletteFromImage(await image.first.readAsBytes());
    for (var img in image) {
      Uint8List a = await img.readAsBytes();
      await FirebaseStorage.instance.ref("${Random().nextInt(1000000)}${DateTime
          .now()
          .millisecondsSinceEpoch}").putData(a)
          .then((p0) => p0.ref.getDownloadURL().then((value) => images.add(value)));
    }
    return DSack<List<String>, int>(one: images, two: col);
  } catch (e) {
    failed(e);
    return DSack(one: [], two: 0);
  }
}

Future<int> paletteFromImage(Uint8List a) async {
  try {
    var paletteGenerator = await PaletteGenerator.fromByteData(
      EncodedImage(a.buffer.asByteData(), width: 200, height: 200),
      maximumColorCount: 2,
    );
    return paletteGenerator.colors.last.value;
  } catch (e) {
    return const Color(0xFF000000).value;
  }
}