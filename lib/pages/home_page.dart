

import 'package:flutter/material.dart';
import 'package:flutter_application_todo/data/local_storage.dart';
import 'package:flutter_application_todo/main.dart';
import 'package:flutter_application_todo/models/task_model.dart';
import 'package:flutter_application_todo/widgets/task_list_item.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../widgets/costum_search_delegate.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> allTask;
  late LocalStorage localStorage;
@override
  void initState() {
   
    super.initState();
    localStorage = locator<LocalStorage>();
    allTask = <Task>[];
    getAllTaskFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: GestureDetector(
          onTap: () {
            showAddTaskBottomSheet(context);
          },
          child: const Text('Bugün Neler Yapacaksın?',
           style: TextStyle(color: Colors.black),),
        ),
        centerTitle: false,
        actions: [
          IconButton(onPressed: (){
            showSearchPage();
          },
           icon: const Icon(Icons.search)),


           IconButton(onPressed: (){
             showAddTaskBottomSheet(context);
           },
           icon: const Icon(Icons.add))
        ],
      ),
      body:allTask.isNotEmpty ? ListView.builder(itemCount: allTask.length,itemBuilder: (context, index) {
        var oAnkiListeElemani = allTask[index];
        return Dismissible(
          background: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.delete, color: Colors.grey,),
              SizedBox(width: 20,),
              Text('Bu Görev Silindi')],
          ),
          key: Key(oAnkiListeElemani.id),
          onDismissed: (direction){
            allTask.removeAt(index);
            localStorage.deleteTask(task: oAnkiListeElemani);
            setState(() {
              
            });
          },
          child: TaskItem(task: oAnkiListeElemani,)
          
        );
      },) :  Center(child: Text('Hadi Görev Ekle'),)
    );
  }

  void showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context, builder: (context){
        return Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          width: MediaQuery.of(context).size.width,
          child:  ListTile(
            title: TextField(
              style: const TextStyle(fontSize: 20),
              decoration: const InputDecoration(
                hintText: 'Görev Nedir',
                border: InputBorder.none,
              ),
              onSubmitted: (value){
                Navigator.of(context).pop();
                if (value.length > 3) {
                  DatePicker.showTimePicker(context,showSecondsColumn: false,
                  onConfirm: (time) async{
                    var yeniEklenecekGorev = 
                    Task.create(name: value, createdAt: time);
                    allTask.add(yeniEklenecekGorev);
                   await localStorage.addTask(task: yeniEklenecekGorev);
                    setState(() {
                      
                    });
                  });
                }
                
              },
            ),
          ),
        );
    });
  }

  void getAllTaskFromDb() async{
    allTask = await localStorage.getAllTask();

setState(() {
  
});

  }

  void showSearchPage() async{
   await showSearch(context: context, delegate: CustomSearchDelegate(allTask: allTask));
   getAllTaskFromDb();
  }
}