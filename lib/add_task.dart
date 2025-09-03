import 'package:flutter/material.dart';

class AddTask extends StatefulWidget {
  //텍스트 변경 메서드 추가
  final void Function({required String todoText}) addTodo;

  // 생성자
  const AddTask({super.key, required this.addTodo});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  // 변수 설정
  var todoText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Add task"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            autofocus: true,
            onSubmitted: (value) {
              if (todoText.text.isNotEmpty) {
                // 위젯을 통해 텍스트 변경 메서드 호출
                widget.addTodo(todoText: todoText.text);
              }
              todoText.clear();
            },
            controller: todoText,
            decoration: const InputDecoration(hintText: "Add task"),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (todoText.text.isNotEmpty) {
              // 위젯을 통해 텍스트 변경 메서드 호출
              widget.addTodo(todoText: todoText.text);
            }
            todoText.clear();
          },
          child: Text("Add"),
        ),
      ],
    );
  }
}
