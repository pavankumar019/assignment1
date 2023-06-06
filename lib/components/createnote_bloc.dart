import 'package:assignment/datamodel.dart';
import 'package:assignment/localdb.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//events

abstract class CreateNoteEvents {}

class OnAdd extends CreateNoteEvents {
  UserData userData;
  OnAdd(this.userData);
}

class OnUpdate extends CreateNoteEvents {
  UserData userData;
  OnUpdate(this.userData);
}

class OnGetDetails extends CreateNoteEvents {
  int id = 0;
  OnGetDetails(this.id);
}

class OnIntialPageLoaded extends CreateNoteEvents {
  UserData? userData;
  bool updata;
  OnIntialPageLoaded(this.userData, {this.updata = false});
}

//states

abstract class CreateNoteStates {}

class OnLoaded extends CreateNoteStates {
  List<UserData>? userData;
  String title = '';
  String description = '';
  OnLoaded({this.title = '', this.description = '', this.userData});
}

//bloc

class CreateNoteBloc extends Bloc<CreateNoteEvents, CreateNoteStates> {
  CreateNoteBloc() : super(OnLoaded()) {
    on<OnIntialPageLoaded>((event, emit) async {
      if (event.updata) {
        final data = await DbManager().getDataWithId(event.userData!.uid);
        final title = data[0].title.toString();
        final description = data[0].description;
        emit(OnLoaded(description: description.toString(), title: title));
      } else {
        emit(OnLoaded());
      }
    });
    on<OnAdd>((event, emit) async {
      await DbManager().insertData(event.userData);
    });
    on<OnUpdate>((event, emit) async {
      await DbManager().updateData(event.userData);
    });
    on<OnGetDetails>((event, emit) async {
      final dataList = await DbManager().getDataWithId(event.id);
      emit(OnLoaded(userData: dataList));
    });
  }
}
