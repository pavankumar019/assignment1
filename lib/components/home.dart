import 'package:assignment/components/createnote.dart';
import 'package:assignment/components/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool reload = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Note'),
        backgroundColor: Colors.teal.withOpacity(0.8),
      ),
      body: BlocProvider(
        create: (context) => HomeBloc()..add(OnScreenUpdate()),
        child: BlocConsumer<HomeBloc, HomeStates>(
          listener: (context, state) {
            if (reload) {
              BlocProvider.of<HomeBloc>(context).add(OnScreenUpdate());
            }
          },
          builder: (context, state) {
            if (state is OnLoaded) {
              final userLength = state.userData.length;
              return state.userData.isEmpty
                  ? const Center(
                      child: Text("     No Notes At\n make some notes!"),
                    )
                  : ListView.builder(
                      itemCount: userLength,
                      itemBuilder: (context, index) {
                        final user = state.userData[index];
                        final title = user.title;
                        final description = user.description;
                        final id = user.uid;
                        return ListTile(
                          title: Text('$title'),
                          subtitle: Text('$description'),
                          trailing: PopupMenuButton<int>(
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 1,
                                child: Row(
                                  children: [
                                    Icon(Icons.edit),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Edit")
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 2,
                                child: Row(
                                  children: [
                                    Icon(Icons.delete),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Delete")
                                  ],
                                ),
                              ),
                            ],

                            // elevation: 2,
                            onSelected: (value) {
                              if (value == 1) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SimpleDialog(
                                      children: [
                                        CreateNotePage(
                                          userData: user,
                                          update: true,
                                        )
                                      ],
                                    );
                                  },
                                );
                              } else if (value == 2) {
                                if (id != null) {
                                  BlocProvider.of<HomeBloc>(context)
                                      .add(OnDelete(id));
                                }
                              }
                            },
                          ),
                        );
                      },
                    );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.amber.withOpacity(0.6),
          icon: const Icon(Icons.add),
          label: const Text('Add Note'),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  children: [CreateNotePage()],
                );
              },
            );
            setState(() {
              reload = true;
            });
          }),
    );
  }
}
