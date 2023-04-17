
import '../resources/repository.dart';

class ImagessBloc {
  final Repository _repository = Repository();

  
  Future<Object> uploadImage(String path,String containerName,String uploader,String entityName) async {
    
    var response = await _repository.uploadImage(path ,containerName,uploader,entityName);

    return response;
  }
}
final imagesBloc = ImagessBloc();