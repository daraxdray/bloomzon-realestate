import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;

class MainProvider {
  Dio dio = new Dio(BaseOptions(
    baseUrl: "https://bloomzon.com/estate/",
  ));

  FormData toDioData(data) {
    return FormData.fromMap(data);
  }

  multipartFile(file) async {
    return MultipartFile.fromFile(
      file.path,
      filename: path.basename(file.path),
    );
  }
}
