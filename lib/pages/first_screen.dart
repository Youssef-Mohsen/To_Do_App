import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:data_base/cubit/add_states.dart';
import 'package:data_base/cubit/app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


var scaffoldkey=GlobalKey<ScaffoldState>();
var formkey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AppCubit cubit =  AppCubit();
    return BlocProvider(
  create: (context) => AppCubit()..createDataBase(),
  child: BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is InsertDataBase){
          Navigator.pop(context);
          cubit.changeIcon(true, Icons.edit);
        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);

        return Scaffold(
          key: scaffoldkey,
          appBar: AppBar(title: const Text('TODO_APP'),centerTitle: true,),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if(cubit.isclicked) {
                  if (formkey.currentState!.validate()) {
                    cubit.insertToDataBase(cubit.titleController.text,cubit.timeController.text,cubit.dateController.text);

                  }
                } else {
                  cubit.changeIcon(true, Icons.add);
              scaffoldkey.currentState?.showBottomSheet((context) {

                return Container(
                  width: 800,
                  color: Colors.grey[300],
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Form(
                      key: formkey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: cubit.titleController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Title Must Not Be Empty';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Task Title',
                              prefixIcon: Icon(Icons.title),

                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          TextFormField(
                            controller: cubit.timeController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Time Must Not Be Empty';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Time',
                              prefixIcon: Icon(Icons.watch_later),

                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          TextFormField(
                            controller: cubit.dateController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Date Must Not Be Empty';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Date',
                              prefixIcon: Icon(Icons.calendar_month),

                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              elevation: 40.0,
              ).closed.then((value) {
                cubit.changeIcon(false, Icons.edit);

              });
                  cubit.changeIcon(true, Icons.edit);
            }
              },
              child: Icon(cubit.bottomIcon),

            ),
          body:ConditionalBuilder(
            condition: cubit.tasks.length >0,
            builder: (context) {
              return  ListView.separated(itemBuilder: (context, index) =>
                  Dismissible(
                    key:Key(cubit.tasks[index]['id'].toString()),
                    onDismissed: (direction) {
                      cubit.deletefromDataBase(cubit.tasks[index]['id']);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            child: Text(cubit.tasks[index]['time']
                                ,style: TextStyle(fontWeight: FontWeight.bold),
                                maxLines: 1),
                            radius: 40,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(cubit.tasks[index]['title'],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                  ),),
                                Text(cubit.tasks[index]['date'],
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey
                                  ),)
                              ],
                            ),
                          ),
                          IconButton(onPressed: () {
                            if(cubit.done==false) {
                              cubit.changeCheck(true);
                            }
                            else{
                              cubit.changeCheck(false);
                            }
                          }, icon: Icon(cubit.done?Icons.check_box_rounded:Icons.check_box_outline_blank),
                              color: Colors.green)
                        ],
                      ),
                    ),
                  ) ,
                  separatorBuilder: (context, index) => Container(
                    color: Colors.amber[200],
                    height: 2,
                    width: 500,
                  ),
                  itemCount: cubit.tasks.length);
            },
            fallback: (context) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.menu
                      ,color: Colors.grey,size: 70,),
                    Text("No Tasks Yet",style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold
                    ),)
                  ],
                ),
              );
            },

          ),

        );
      },
    ),

);
  }
}