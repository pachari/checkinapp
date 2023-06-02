part of 'todo_search_bloc.dart';

@immutable
abstract class TodoSearchEvent {
  const TodoSearchEvent();

  List<Object> get props => [];
}

// ignore: camel_case_types
class setSearchTermEvent extends TodoSearchEvent {
  final String newSearchTerm;

  const setSearchTermEvent({required this.newSearchTerm});

  @override
  String toString() {
    return 'setSearchTermEvent{newSearchTerm: $newSearchTerm}';
  }

  @override
  List<Object> get props => [newSearchTerm];
}
