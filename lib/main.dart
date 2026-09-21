import 'package:firebase_core/firebase_core.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_firebase/student_page.dart'; 
 
import 'firebase_options.dart'; 

 
Future<void> main() async { 
  WidgetsFlutterBinding.ensureInitialized(); 
 
  await Firebase.initializeApp( 
    options: DefaultFirebaseOptions.currentPlatform, 
  ); 
 
  runApp(const MyApp());
}
 
class MyApp extends StatelessWidget { 
  const MyApp({super.key}); 
 
  @override 
  Widget build(BuildContext context) { 
    return MaterialApp( 
      debugShowCheckedModeBanner: false, 
      title: 'Flutter Firebase App', 
      theme: ThemeData( 
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), 
        useMaterial3: true, 
      ), 
      home: const FirebaseHomePage(), 
    ); 
  } 
} 
 
class FirebaseHomePage extends StatelessWidget { 
  const FirebaseHomePage({super.key}); 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar( 
        title: const Text('Flutter Firebase'), 
        centerTitle: true, 
      ), 
      body: Center( 
        child: Column( 
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [ 
            Icon(Icons.cloud_done, size: 80, color: Colors.green), 
            SizedBox(height: 16), 
            Text( 
              'Firebase connected successfully!', 
              style: TextStyle( 
                fontSize: 20, 
                fontWeight: FontWeight.bold, 
              ), 
            ), 

            SizedBox(height: 10),

            ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (_) => StudentPage()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Text("Create Student"),
            )
          ], 
        ), 
      ), 
    ); 
  } 
}