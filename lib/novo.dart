import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NewTaskPage extends StatefulWidget {
  final String? taskId;

  const NewTaskPage({super.key, this.taskId});

  @override
  State<NewTaskPage> createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  TextEditingController txtTitle = TextEditingController();

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  bool loading = false;
  
  bool get isEditing => widget.taskId != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      loadTask();
    }
  }

  Future<void> loadTask() async {
      setState(() => loading = true);

      final doc = await _firestore.collection('tasks').doc(widget.taskId).get();

      if (doc.exists) {
        final data = doc.data()!;
        txtTitle.text = data['title'] ?? '';
      }

      setState(() => loading = false);
  }

  Future<void> saveTask() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final title = txtTitle.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informa o nome da task')),
      );
      return;
    }

    setState(() => loading = true);

    if (isEditing) {
      await _firestore.collection('tasks').doc(widget.taskId!).update({
        'title': title,
      });
    } else {
      await _firestore.collection('tasks').add({
        'title': title,
        'checked': false,
        'userId': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    if (!mounted) return;
    context.go('/tasks');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? "Editar Task" : "Nova Task")),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(20),
          child: loading
            ? const Center(child: CircularProgressIndicator(),)
            : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 12,
              children: [
                TextField(
                  controller: txtTitle,
                  decoration: InputDecoration(border: OutlineInputBorder(), label: Text("Task")),
                  minLines: 1,
                  maxLines: 5,
                ),
                ElevatedButton(onPressed: saveTask, child: Text(isEditing ? "Atualizar" : "Salvar")),
              ],
            ),
        ),
      ),
    );
  }
}
