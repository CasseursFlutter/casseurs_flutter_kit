import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui';
import 'package:image/image.dart' as ImageUtils;

class _DecodeParam {
  final String filePath;  
  final SendPort sendPort;
  Size? size;

  _DecodeParam({
    required this.filePath,
    required this.sendPort,
    this.size,    
  });
}

void _decodeIsolate(_DecodeParam param) async {
    final bytes = File(param.filePath).readAsBytesSync();
    var image = ImageUtils.decodeImage(bytes);
    Uint8List? encodedThumb;

    if (image != null) {
      if (param.size != null ) {
        final sourceHeight = image.height;
        final sourceWidth = image.width;
        final sourceRatio = sourceWidth/sourceHeight;

        final targetHeight = param.size!.height.round();
        final targetWidth = param.size!.width.round();
        final targetRatio = targetWidth/targetHeight;

        if (targetRatio > sourceRatio) {
          final height = sourceWidth~/targetRatio;
          image = ImageUtils.copyCrop(image, x: 0, y: (sourceHeight-height)~/2, width: sourceWidth, height: height);          
        } else if (targetRatio < sourceRatio) {
          final width = (sourceHeight*targetRatio).round();
          image = ImageUtils.copyCrop(image, x: (sourceWidth-width)~/2, y: 0, width: width, height: sourceHeight);          
        }

        final thumb = ImageUtils.copyResize(image, width: targetWidth, height: targetHeight);
        encodedThumb = Uint8List.fromList(ImageUtils.encodeJpg(thumb));
      } else {
        encodedThumb = Uint8List.fromList(ImageUtils.encodeJpg(image));
      }      
    }

    param.sendPort.send(encodedThumb);
  }

class ImagesUtils {  
  
  static Future<Uint8List?> decodeAndResize(String filePath,  { Size? size }) async {
    final receivePort = ReceivePort();
    
    await Isolate.spawn(_decodeIsolate, _DecodeParam(
      filePath: filePath, 
      sendPort: receivePort.sendPort,
      size: size
    ));

    final image = await receivePort.first as Uint8List?;
    return image;
  }
}
