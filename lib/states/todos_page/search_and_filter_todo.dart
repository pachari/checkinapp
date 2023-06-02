import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/blocs.dart';
import 'package:checkinapp/models/todo_model.dart';
import 'package:checkinapp/componants/constants.dart';

class SearchAndFilterTodo extends StatelessWidget {
  const SearchAndFilterTodo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //  const Text(
          //   'Search',
          //   style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,),
          // ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              filterButton(context, Filter.all),
              filterButton(context, Filter.active),
              filterButton(context, Filter.completed),
            ],
          ),
          const SizedBox(height: 5.0),
          TextField(
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 5),
              labelText: 'ค้นหา',
              border: InputBorder.none,
              filled: true,
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (String? newSearchTerm) {
              if (newSearchTerm != null) {
                context
                    .read<TodoSearchBloc>()
                    .add(setSearchTermEvent(newSearchTerm: newSearchTerm));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget filterButton(BuildContext context, Filter filter) {
    return TextButton(
      onPressed: () {
        context
            .read<TodoFilterBloc>()
            .add(ChangeFilterEvent(newFilter: filter));
      },
      child: Text(
        filter == Filter.all
            ? 'All' //ทั้งหมด
            : filter == Filter.active
                ? 'Pending' //Pending รอดำเนินการ
                : 'Completed', //Completed สำเร็จ
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: textColor(context, filter),
        ),
      ),
    );
  }

  Color textColor(BuildContext context, Filter filter) {
    final currentFilter = context.watch<TodoFilterBloc>().state.filter;
    return currentFilter == filter ? kPrimaryColor : Colors.grey;
  }
}
