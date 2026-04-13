import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:task_list/app.dart';

const firebaseConfig = FirebaseOptions(
  apiKey: "AIzaSyD8J_HZkG8nmYVJxro2nowb7glrnFAP72c",
  authDomain: "fatec-task-list-37af4.firebaseapp.com",
  projectId: "fatec-task-list-37af4",
  storageBucket: "fatec-task-list-37af4.firebasestorage.app",
  messagingSenderId: "732659792001",
  appId: "1:732659792001:web:35dc15733c39875e607580"
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseConfig);
  runApp(const App());
}