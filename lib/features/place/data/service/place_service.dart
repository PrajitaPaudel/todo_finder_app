

import 'package:dio/dio.dart';

import '../model/place_model.dart';

class PalaceService{
  final Dio dio;

  PalaceService(this.dio);


  Future<List<TodoModel>> getPlaace()async{
    
    try{
      final data =await dio.get('https://jsonplaceholder.typicode.com/todos');

      if(data.statusCode==200||data.statusCode==201){

        final List model = data.data;
        return model.map((e)=>TodoModel.fromJson(e)).toList();

      }else{
        return  throw Exception('something went wrong');
      }

      
    }catch(e){
    return  throw Exception(e);
    }
    
  }
}