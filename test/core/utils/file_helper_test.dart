import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/core/utils/file_helper.dart';

void main() {
  String url = "Library/Caches/test12.png";

  test('FileHelper@getFileName should return correct file name', () {
    String fileName = FileHelper.getFileName(url);
    expect(fileName, "test12.png");
  });

  test('FileHelper@getFileName should return correct file name having multiple dots', () {
    String multipleDotUrl = "Library/Caches/test1.png.png";
    String multipleDotUrl2 = "Library/Caches/test1.abc.png";


    String fileName = FileHelper.getFileName(multipleDotUrl);
    expect(fileName, "test1.png.png");

    fileName = FileHelper.getFileName(multipleDotUrl2);
    expect(fileName, "test1.abc.png");
  });

  test('FileHelper@getFileExtension should return correct extension name in lowercase', () {
    String pngImageUrl = "Library/Caches/test12.PNG";
    String jpegImageUrl = "Library/Caches/test12.Jpeg";

    String? pngExtName = FileHelper.getFileExtension(pngImageUrl);
    String? jpegExtName = FileHelper.getFileExtension(jpegImageUrl);

    expect(pngExtName, "png");
    expect(jpegExtName, "jpeg");
  });

  test('FileHelper@getFileExtension should return correct extension for filename having spaces', () {
    String pngImageUrl = "Library/Caches/test%2012.PNG";
    String jpegImageUrl = "Library/Caches/test%20_&12.Jpeg";

    String? pngExtName = FileHelper.getFileExtension(pngImageUrl);
    String? jpegExtName = FileHelper.getFileExtension(jpegImageUrl);

    expect(pngExtName, "png");
    expect(jpegExtName, "jpeg");
  });

  test('FileHelper@getFileExtension should return null if url is having invalid extension', (){
    String invalidExtUrl = "Library/Caches/test12.abc";

    String? invalidExtName = FileHelper.getFileExtension(invalidExtUrl);

    expect(invalidExtName, null);
  });

  test('FileHelper@getFileExtension should return null if url does not contain extension', () {
    String withoutExtUrl = "Library/Caches/test%20_&1";

    String? withoutExtName = FileHelper.getFileExtension(withoutExtUrl);

    expect(withoutExtName, null);
  });

  test('FileHelper@getFileSizeWithUnit should convert bytes to KB/MB', (){
    String fileSizeInKb = FileHelper.getFileSizeWithUnit(10000);
    expect(fileSizeInKb, '10.00 KB');
    String fileSizeInMb = FileHelper.getFileSizeWithUnit(10000000);
    expect(fileSizeInMb, '10.00 MB');
  });

}
