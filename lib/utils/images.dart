import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:image/image.dart';

class _DecodeParam {
  final String filePath;
  final SendPort sendPort;
  final int width;
  final int height;

  _DecodeParam({
    required this.filePath,
    required this.sendPort,
    required this.width,
    required this.height
  });
}

void _decodeIsolate(_DecodeParam param) async {
    final bytes = File(param.filePath).readAsBytesSync();
    final image = decodeImage(bytes);
    Uint8List? encodedThumb;

    if (image != null) {      
      final thumb = copyResize(image, width: param.width, height: param.height);
      encodedThumb = Uint8List.fromList(encodeJpg(thumb));
    }

    param.sendPort.send(encodedThumb);
  }

class ImagesUtils {  
  static Future<Uint8List?> decodeAndResize(String filePath,  { int width = 300, int height = 300 }) async {
    final receivePort = ReceivePort();
    
    await Isolate.spawn(_decodeIsolate, _DecodeParam(
      filePath: filePath, 
      sendPort: receivePort.sendPort,
      width: width,
      height: height
    ));

    final image = await receivePort.first as Uint8List?;
    return image;
  }
}
