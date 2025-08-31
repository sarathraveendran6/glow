import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  // Load tasks from API
  Future<void> loadTasks() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final fetchedTasks = await TaskService.getTasks();
      
      setState(() {
        tasks = fetchedTasks;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadTasks,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading tasks:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: loadTasks,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (tasks.isEmpty) {
      return const Center(
        child: Text(
          'No tasks found',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          child: ListTile(
            leading: Icon(
              task.completed ? Icons.check_circle : Icons.radio_button_unchecked,
              color: task.completed ? Colors.green : Colors.grey,
            ),
            title: Text(
              task.title,
              style: TextStyle(
                decoration: task.completed 
                    ? TextDecoration.lineThrough 
                    : TextDecoration.none,
              ),
            ),
            subtitle: task.description != null 
                ? Text(task.description!)
                : null,
            trailing: Text(
              task.createdAt.day.toString() + '/' + 
              task.createdAt.month.toString(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        );
      },
    );
  }
}
