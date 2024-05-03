import 'package:bloc/bloc.dart';
import 'package:data_base/cubit/add_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';


class AppCubit extends Cubit<AppStates>{
  AppCubit(): super(InitialState());

  static AppCubit get(context)=> BlocProvider.of(context);
  // Atributes
  var isclicked =false;
  var done =false;
  var bottomIcon = Icons.edit;
  var titleController =new TextEditingController();
  var timeController =new TextEditingController();
  var dateController =new TextEditingController();
  late Database database;


  // Methods
  void changeIcon(bool value ,IconData icon){

      isclicked = value;

      bottomIcon = Icons.add;
    emit(ChangeIcon());
  }
  void changeCheck(bool value){
    done =value;
    emit(ChangeCheck());
  }


  //data base
  void createDataBase(){
    openDatabase(
      'app_cubit.db',
      version:2,
      onCreate: (db,version){
        db.execute('Create Table tasks(id INTEGER PRIMARY KEY , title TEXT , time TEXT , date TEXT)'
        ).then((value) {
          print('Table Created');
        }).catchError((e){
          print(e.toString());
        });
      },
      onOpen: (db){
       print('Data base opened');
       getDataFromDataBase(db);
      }
    ).then((value) {
      database=value;

      emit(CreateDataBase());
    });

  }
  void insertToDataBase(String title,String time,String date)async{

    await database.transaction((txn)async {

      txn.rawInsert("Insert Into tasks (title, time , date) VALUES('${title}','${time}','${date}')").then((value) {
        print('Data Inserted');
        getDataFromDataBase(database);
        emit(InsertDataBase());
      }).catchError((e){
          print(e.toString());
      });
    });
  }
  List<Map> tasks =[];
  void getDataFromDataBase(Database database){
    database.rawQuery('Select * from tasks').then((value)async {
      tasks =value;

      emit(GetDataBase());
      print(tasks);

    }).catchError((e){
      print(e.toString());
    });


  }
  void deletefromDataBase(int id){
    database.rawDelete("Delete From tasks WHERE id =?",[id]).then((value){
      getDataFromDataBase(database);
      emit(DeleteDataBase());
    });
  }
}