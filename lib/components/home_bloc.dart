import 'package:assignment/datamodel.dart';
import 'package:assignment/localdb.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//events

abstract class HomeEvents {}

class OnAdd extends HomeEvents {}

class OnDelete extends HomeEvents {
  int id;
  OnDelete(this.id);
}

class OnScreenUpdate extends HomeEvents {}

//states
abstract class HomeStates {}

class OnLoading extends HomeStates {}

class OnLoaded extends HomeStates {
  List<UserData> userData;
  OnLoaded(this.userData);
}

//bloc

class HomeBloc extends Bloc<HomeEvents, HomeStates> {
  HomeBloc() : super(OnLoading()) {
    on<OnScreenUpdate>((event, emit) async {
      final dataList = await DbManager().getData();
      emit(OnLoaded(dataList));
    });
    on<OnDelete>((event, emit) async {
      final id = event.id;
      if (id > 0) {
        await DbManager().deleteData(id);
        final updateList = await DbManager().getData();
        emit(OnLoaded(updateList));
      }
    });
  }
}
