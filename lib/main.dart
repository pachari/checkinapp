// ignore_for_file: await_only_futures

import 'package:checkinapp/blocs/active_todo_count/active_todo_count_bloc.dart';
import 'package:checkinapp/blocs/filtered_todos/filtered_todos_bloc.dart';
import 'package:checkinapp/blocs/todo_filter/todo_filter_bloc.dart';
import 'package:checkinapp/blocs/todo_list/todo_list_bloc.dart';
import 'package:checkinapp/blocs/todo_search/todo_search_bloc.dart';
import 'package:checkinapp/componants/constants.dart';
import 'package:checkinapp/models/user_model.dart';
import 'package:checkinapp/states/calendar_page.dart';
// import 'package:checkinapp/utility/app_connectionchecker.dart';
import 'package:checkinapp/utility/app_service.dart';
// import 'package:checkinapp/utility/app_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:checkinapp/router.dart';

String initRoute = '/internet';
// AppController controller = Get.put(AppController());
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // runApp(const MyApp());
  await Firebase.initializeApp().then((value) async {
    // Replace with actual values
    // const FirebaseOptions(
    //   apiKey: "AIzaSyADiKBXBJvZVqk-1IMKJ29w91kzWj6R-0o",
    //   appId: "1:742257113647:web:b9a45a575a45ee11b7a4da",
    //   messagingSenderId: "742257113647",
    //   projectId: "checkinapp-76b76",
    // );
    //  firebaseConfig = {
    //   apiKey: "AIzaSyADiKBXBJvZVqk-1IMKJ29w91kzWj6R-0o",
    //   authDomain: "checkinapp-76b76.firebaseapp.com",
    //   projectId: "checkinapp-76b76",
    //   storageBucket: "checkinapp-76b76.appspot.com",
    //   messagingSenderId: "742257113647",
    //   appId: "1:742257113647:web:b9a45a575a45ee11b7a4da",
    //   measurementId: "G-FJF80LS4J0"
    // };
    await FirebaseAuth.instance.authStateChanges().listen((event) async {
      if (event != null) {
        //login
        await FirebaseFirestore.instance
            .collection('user')
            .doc(event.uid)
            // .where('uid', isEqualTo: event.uid)
            .get()
            .then((value) async {
          Map<String, dynamic> data = value.data() as Map<String, dynamic>;
          var array = data['todo']; // array is now List<dynamic>
          List<String> strings = List<String>.from(array);
          UserModel userModel = UserModel(
            email: data['email'],
            name: data['name'],
            role: data['role'],
            todo: strings,
            uid: data['uid'],
            typeworkid: data['typeid'],
          );
          controller.userModels.add(userModel);
          await AppService().readInfoFactoryAll();
          // //เช็คว่าวันไหนมีการบันทึกรายการบ้าง
          await AppService().readCalendarallEventModel2(userModel.uid,DateTime.now());
          // switch (userModel.role) {
          //   case 'admin':
          //     initRoute = '/serviceAdmin';
          runApp(const MyApp());
          //     break;
          //   case 'maid':
          //     initRoute = '/serviceMaid';
          //     runApp(const MyApp());
          //     break;
          //   case 'security':
          //     initRoute = '/serviceSecurity';
          //     runApp(const MyApp());
          //     break;
          //   default:
          //     initRoute = '/singup';
          //     runApp(const MyApp());
          //     break;
          // }
        });
      }
      // else {
      //   // New login
      //   // runApp(const WelcomeScreen());
      runApp(const MyApp());
      // }
    });
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TodoFilterBloc>(
          create: (context) => TodoFilterBloc(),
        ),
        BlocProvider<TodoSearchBloc>(
          create: (context) => TodoSearchBloc(),
        ),
        BlocProvider<TodoListBloc>(
          create: (context) => TodoListBloc(),
        ),
        BlocProvider<ActiveTodoCountBloc>(
          create: (context) => ActiveTodoCountBloc(
            initialActiveTodoCount:
                context.read<TodoListBloc>().state.todos.length,
          ),
        ),
        BlocProvider<FilteredTodosBloc>(
          create: (context) => FilteredTodosBloc(
            initialTodos: context.read<TodoListBloc>().state.todos,
          ),
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'M-Maid',
        theme: ThemeData(
          fontFamily: 'Kanit',
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: kPrimaryColor,
              shape: const StadiumBorder(),
              maximumSize: const Size(double.infinity, 56),
              minimumSize: const Size(double.infinity, 56),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: kPrimaryLightColor,
            iconColor: kPrimaryColor,
            prefixIconColor: kPrimaryColor,
            contentPadding: EdgeInsets.symmetric(
                horizontal: kDefaultPedding, vertical: kDefaultPedding),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(kDefaultCircular)),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(kDefaultCircular)),
              borderSide: BorderSide(color: kPrimaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(kDefaultCircular)),
              borderSide: BorderSide(color: kPrimaryColor),
            ),
          ),
        ),
        routes: map,
        initialRoute: initRoute,
        // home: const ConnectionCheckerDemo(),
      ),
    );
  }
}
