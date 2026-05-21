import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/place_entity.dart';
import '../bloc/place_bloc.dart';
import '../bloc/place_event.dart';
import '../bloc/place_state.dart';

class PlaceFinderScreen extends StatefulWidget {
  const PlaceFinderScreen({super.key});

  @override
  State<PlaceFinderScreen> createState() => _PlaceFinderScreenState();
}

class _PlaceFinderScreenState extends State<PlaceFinderScreen> {
  late PlaceBloc bloc;

  String filter = "all";
  String sort = "none";

  @override
  void initState() {
    super.initState();
    bloc = context.read<PlaceBloc>();
    bloc.add(GetPlaceEvent());
  }

  List<TodoEntity> applyFilters(List<TodoEntity> list) {
    List<TodoEntity> result = [...list];

    if (filter == "completed") {
      result = result.where((e) => e.completed).toList();
    } else if (filter == "incomplete") {
      result = result.where((e) => !e.completed).toList();
    }

    if (sort == "az") {
      result.sort((a, b) => a.title.compareTo(b.title));
    } else if (sort == "za") {
      result.sort((a, b) => b.title.compareTo(a.title));
    }

    return result;
  }

  void reset() {
    setState(() {
      filter = "all";
      sort = "none";
    });
    bloc.add(GetPlaceEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo Finder"),
        actions: [
          IconButton(
            onPressed: reset,
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),


          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(width: 10,),
                filterChip("All", "all"),
                filterChip("Completed", "completed"),
                filterChip("Incomplete", "incomplete"),
                const SizedBox(width: 10),
                sortChip("A-Z", "az"),
                const SizedBox(width: 10),
                sortChip("Z-A", "za"),
                SizedBox(width: 10,)

              ],
            ),
          ),
          SizedBox(height: 20,),
          Expanded(
            child: BlocBuilder<PlaceBloc, PlaceState>(
              builder: (context, state) {
                if (state is PlaceLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is PaceLoadedErrorState) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (state is PlaceLoadedState) {
                  final list = applyFilters(state.entity);

                  if (list.isEmpty) {
                    return const Center(
                      child: Text("No data found"),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(10),
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = list[index];

                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              item.completed
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: item.completed
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                item.title,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }


  Widget filterChip(String label, String value) {
    final isSelected = filter == value;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          setState(() => filter = value);
        },
      ),
    );
  }


  Widget sortChip(String label, String value) {
    final isSelected = sort == value;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() => sort = value);
      },
    );
  }
}
