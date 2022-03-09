import 'package:flutter/material.dart';
import 'package:flutter_application_todo/data/local_storage.dart';
import 'package:flutter_application_todo/main.dart';
import 'package:flutter_application_todo/widgets/task_list_item.dart';

import '../models/task_model.dart';

class CustomSearchDelegate extends SearchDelegate{
  final List<Task> allTask;

  CustomSearchDelegate({required this.allTask});
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: (){
        query.isEmpty ? null : query = '';
      }, icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
      onTap: (){
        close(context, null);
      },
      child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 24,));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Task> filteredList = allTask.where((gorev) => gorev.name.toLowerCase().contains(query.toLowerCase())).toList();
    return filteredList.length > 0 ?
     ListView.builder(itemCount: filteredList.length,itemBuilder: (context, index) {
        var oAnkiListeElemani = filteredList[index];
        return Dismissible(
          background: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.delete, color: Colors.grey,),
              SizedBox(width: 20,),
              Text('Bu Görev Silindi')],
          ),
          key: Key(oAnkiListeElemani.id),
          onDismissed: (direction)async{
            filteredList.removeAt(index);
            await locator<LocalStorage>().deleteTask(task: oAnkiListeElemani);
            
            
          },
          child: TaskItem(task: oAnkiListeElemani,),
          
        );
     }
     ) : Center(child: Text('Aradığınızı bulamadık'),);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return Container();
  }

  }