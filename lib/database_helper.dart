import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo/models/task.dart';
import 'package:todo/models/todo.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), "todo.db"),
      onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE todos(id INTEGER PRIMARY KEY, taskId INTEGER, title TEXT, isDone INTEGER)");
        await db.execute(
            "CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)");
        return Future.value();
      },
      version: 1,
    );
  }

  //Inserts tasks into the database
  Future<int?> insertTask(Task task) async {
    int? taskId = 0;

    Database _db = await database();
    await _db
        .insert('tasks', task.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      taskId = value;
    });
    return taskId;
  }

  //Update the title of an existing task
  Future<void> updateTaskTitle(int? id, String title) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE tasks SET title = '$title' WHERE id = '$id'");
  }

  //Update the description of a task
  Future<void> updateTaskDescription(int? id, String description) async {
    Database _db = await database();
    await _db.rawUpdate(
        "UPDATE tasks SET description = '$description' WHERE id = '$id'");
  }

  Future<void> updateIsDone(int? id, int? isDone) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE todos SET isDone = '$isDone' WHERE id = '$id'");
  }

  //Inserts todos into the database
  Future<void> insertTodo(Todo todo) async {
    Database _db = await database();
    await _db.insert('todos', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //Get the tasks out of the database
  Future<List<Task>> getTasks() async {
    Database _db = await database();
    List<Map<String, dynamic>> taskMap = await _db.query("tasks");
    return List.generate(taskMap.length, (index) {
      return Task(
        id: taskMap[index]["id"],
        title: taskMap[index]["title"],
        description: taskMap[index]["description"],
      );
    });
  }

  //Get the todos out of the database
  Future<List<Todo>> getTodos(int? taskId) async {
    Database _db = await database();
    List<Map<String, dynamic>> todoMap =
        await _db.rawQuery("SELECT * FROM todos WHERE taskId = $taskId");
    return List.generate(todoMap.length, (index) {
      return Todo(
        id: todoMap[index]["id"],
        taskId: todoMap[index]["taskId"],
        title: todoMap[index]["title"],
        isDone: todoMap[index]["isDone"],
      );
    });
  }

  Future<void> removeTask(int? taskId) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM tasks WHERE id = '$taskId'");
    await _db.rawDelete("DELETE FROM todos WHERE taskId = '$taskId'");
  }

  //TODO: Method to remove Task from the database.
}
