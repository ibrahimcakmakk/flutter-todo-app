import 'package:flutter/material.dart';
import 'package:flutter_application_todo/data/local_storage.dart';
import 'package:flutter_application_todo/main.dart';
import 'package:intl/intl.dart';


import '../models/task_model.dart';

class TaskItem extends StatefulWidget {
    Task task;
   TaskItem({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  final TextEditingController taskNameController = TextEditingController();
  late LocalStorage localStorage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    localStorage = locator<LocalStorage>();
    taskNameController.text =widget.task.name;
    //print('init state tetiklendi');
  }
  @override
  Widget build(BuildContext context) {
    taskNameController.text =widget.task.name;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 10,
            offset: Offset(0,4)
          )
        ]
      ),
      child: ListTile(
        leading: GestureDetector(
          onTap: (){
            widget.task.isCompleted = !widget.task.isCompleted;
            localStorage.uptadeTask(task: widget.task);
            setState(() {
              
            });
          },
          child: Container(child: const Icon(Icons.check,color: Colors.white,),decoration: BoxDecoration(
            color: widget.task.isCompleted ? Color.fromARGB(255, 30, 124, 33) : Colors.white,
            border: Border.all(color: Colors.grey, width: 0.8),
            shape: BoxShape.circle,
          ),),
          
        ),
        title:  widget.task.isCompleted ? Text(widget.task.name,
        style: const TextStyle(decoration: TextDecoration.lineThrough,
         color: Colors.grey),) :  TextField(
          controller: taskNameController,
          minLines: 1,
          maxLength: null,
          decoration:const InputDecoration(border: InputBorder.none) ,
          onSubmitted: (yenideger){
            
            widget.task.name = yenideger;
            localStorage.uptadeTask(task: widget.task);
              setState(() {
                
              });
            
            
          },
        ) ,
        trailing: Text(
          DateFormat('hh:mm a').format(widget.task.createdAt),
           style: TextStyle(fontSize: 14,color: Colors.grey),
           
           
        ),
      ),
    );
  }
}