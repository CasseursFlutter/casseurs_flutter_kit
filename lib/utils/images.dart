import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:image/image.dart' as ImageUtils;

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
    var image = ImageUtils.decodeImage(bytes);
    Uint8List? encodedThumb;

    if (image != null) {
      final sourceHeight = image.height;
      final sourceWidth = image.width;
      final sourceRatio = sourceWidth/sourceHeight;

      final targetHeight = param.height;
      final targetWidth = param.width;
      final targetRatio = targetWidth/targetHeight;

      
      if (targetRatio > sourceRatio) {
        final height = sourceWidth~/targetRatio;
        image = ImageUtils.copyCrop(image, 0, (sourceHeight-height)~/2, sourceWidth, height);          
      } else if (targetRatio < sourceRatio) {
        final width = (sourceHeight*targetRatio).round();
        image = ImageUtils.copyCrop(image, (sourceWidth-width)~/2, 0, width, sourceHeight);          
      }

      final thumb = ImageUtils.copyResize(image, width: targetWidth, height: targetHeight);
      encodedThumb = Uint8List.fromList(ImageUtils.encodeJpg(thumb));
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
