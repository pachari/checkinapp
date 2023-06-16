import 'package:checkinapp/models/calendarevent_model.dart';
import 'package:checkinapp/models/checktodoresult_model.dart';
import 'package:checkinapp/models/factory_all_model.dart';
import 'package:checkinapp/models/fileupload_model.dart';
import 'package:checkinapp/models/todoresult_model.dart';
import 'package:checkinapp/models/factory_model.dart';
import 'package:checkinapp/models/user_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  RxList<Position> position = <Position>[].obs;
  RxList<FactoryModel> factoryModels = <FactoryModel>[].obs;
  RxList<FactoryAllModel> factoryAllModels = <FactoryAllModel>[].obs;
  RxList<UserModel> userModels = <UserModel>[].obs;
  RxList<TodoResultModels> todoresultModels = <TodoResultModels>[].obs;
  RxList<CheckTodoResultModels> checktodoresultModels = <CheckTodoResultModels>[].obs;
  RxList<CalendarAllEvent> calendaralleventModels = <CalendarAllEvent>[].obs;
  RxList<FileUploads> fileuploadModels = <FileUploads>[].obs;
}
