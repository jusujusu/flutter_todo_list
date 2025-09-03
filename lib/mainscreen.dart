import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/add_task.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // 변수 선언
  List<String> todoList = [];

  // 텍스트 변경 메서드
  void addTodo({required String todoText}) {
    // 같은 할 일이 있다면 경고창을 띄우고 추가 안함
    if (todoList.contains(todoText)) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Already exists"),
            content: Text("This task is already exists"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Close"),
              ),
            ],
          );
        },
      );
      return;
    }
    setState(() {
      // 추가된 todo는 index 0번째
      todoList.insert(0, todoText);
    });

    writeLocalData();

    // 텍스트 변경 후 입력창 안보이게
    Navigator.pop(context);
  }

  // 데이터 저장
  void writeLocalData() async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save an list of strings to 'items' key.
    await prefs.setStringList('todoList', todoList);
  }

  //데이터 불러오기
  void loadData() async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      todoList = (prefs.getStringList('todoList') ?? []).toList();
    });
  }

  // 앱이 실행될 때 한번만 실행 할 메소드
  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        // 왼쪽 목록창
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text("김준수"),
              accountEmail: const Text("skfkahdk754@gmail.com"),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        // 제목
        title: const Text("TODO App"),
        centerTitle: true,
      ),
      body: (todoList.isEmpty)
          ? Center(
              child: Text(
                "No items on the list",
                style: TextStyle(fontSize: 20),
              ),
            )
          : ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.startToEnd,
                  background: Container(
                    color: Colors.red,
                    child: const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.check),
                        ),
                      ],
                    ),
                  ),
                  // 없어졌을 때 삭제 기능 추가
                  onDismissed: (direction) {
                    setState(() {
                      todoList.removeAt(index);
                    });
                    writeLocalData();
                  },
                  child: ListTile(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            child: ElevatedButton(
                              onPressed: () {
                                // 목록에서 삭제
                                setState(() {
                                  todoList.removeAt(index);
                                });
                                writeLocalData();
                                Navigator.pop(context);
                              },
                              child: Text("Task Done!"),
                            ),
                          );
                        },
                      );
                    },
                    title: Text(todoList[index]),
                  ),
                );
              },
            ),
      //버튼 추가
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: SizedBox(
                  height: 250,
                  // AddTask에 updateText 메서드 전달
                  child: AddTask(addTodo: addTodo),
                ),
              );
            },
          );
        },
        backgroundColor: Colors.black,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
