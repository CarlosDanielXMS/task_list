import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_list/task_model.dart';

class ListaPage extends StatelessWidget {

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future logout(BuildContext context) async {
    await _auth.signOut();

    if (!context.mounted) return;

    context.go('/login');
  }

  Future<void> toggleTask(TaskModel task, bool value) async {
    await _firestore.collection('tasks').doc(task.id).update({
      'checked': value
    });
  }

  Future<void> deleteTask(String taskId) async {
    await _firestore.collection('tasks').doc(taskId).delete();
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text('Usuário não autenticado'),
        ),
      );
    }

    final tasksStream = _firestore
        .collection('tasks')
        .where('userId', isEqualTo: user.uid)
        // .orderBy('createdAt', descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text("Tasks de ${user.displayName}"),
        actions: [
          IconButton(
            onPressed: () => logout(context),
            icon: Icon(Icons.logout_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push("/tasks/new"),
        child: Icon(Icons.add),  
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: 10
          ),
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: tasksStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Falha ao carregar taks"),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final docs = snapshot.data?.docs ?? [];

              if (docs.isEmpty) {
                return const Center(
                  child: Text("Nenhuma task cadastrada"),
                );
              }

              final tasks = docs.map((doc) => TaskModel.fromMap(doc.id, doc.data()))
                  .toList();

              return ListView(
                children: [
                  for (TaskModel task in tasks)
                    Dismissible(
                      key: Key(task.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => deleteTask(task.id),
                      background: Container(
                        color: const Color.fromARGB(48, 33, 149, 243),
                      ),
                      secondaryBackground: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: const Color.fromARGB(48, 244, 67, 54),
                        child: const Icon(Icons.delete),
                      ),
                      child: ListTile(
                        onTap: () => context.push('/tasks/${task.id}/edit'),
                        title: Text(task.title),
                        leading: Checkbox(
                          value: task.checked,
                          onChanged: (value) {
                            if (value != null) {
                              toggleTask(task, value);
                            }
                          }
                        ),
                        // trailing: IconButton(
                        //   onPressed: () => context.push('/tasks/${task.id}/edit'),
                        //   icon: const Icon(Icons.edit),
                        // ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}