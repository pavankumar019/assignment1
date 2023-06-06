import 'package:assignment/datamodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../notifier.dart';
import 'createnote_bloc.dart';

// ignore: must_be_immutable
class CreateNotePage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  bool update;
  UserData? userData;
  CreateNotePage({this.update = false, this.userData, super.key});
  TextEditingController text = TextEditingController();
  TextEditingController description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<CreateNoteBloc>(
            create: (context) {
              return CreateNoteBloc()
                ..add(OnIntialPageLoaded(userData, updata: update));
            },
          )
        ],
        child: BlocBuilder<CreateNoteBloc, CreateNoteStates>(
          builder: (context, state) {
            if (state is OnLoaded) {
              text.text = state.title;
              description.text = state.description;

              return Column(children: [
                Center(
                    child: update
                        ? Text(
                            'Update Note',
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.amber.withOpacity(0.8)),
                          )
                        : Text(
                            'Create Note',
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.amber.withOpacity(0.8)),
                          )),
                const SizedBox(
                  height: 15,
                ),
                Form(
                    key: _formKey,
                    child: Column(children: [
                      TextFormField(
                        controller: text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Valid title";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            labelText: 'Title',
                            labelStyle: const TextStyle(color: Colors.teal),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                                borderSide: const BorderSide(
                                    color: Colors.transparent)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                                borderSide:
                                    const BorderSide(color: Colors.teal))),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter valid description";
                          } else {
                            return null;
                          }
                        },
                        maxLines: 3,
                        controller: description,
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.teal),
                          labelText: 'Description',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide:
                                  const BorderSide(color: Colors.black)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: const BorderSide(color: Colors.teal)),
                        ),
                      ),
                    ])),
                const SizedBox(
                  height: 20,
                ),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.green.withOpacity(0.8)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        UserData data = UserData();
                        data.title = text.text;
                        data.description = description.text;

                        if (update) {
                          data.uid = userData!.uid;
                          BlocProvider.of<CreateNoteBloc>(context)
                              .add(OnUpdate(data));
                          Navigator.pop(context);

                          ScreenUpdate().changeValue(true);
                        } else {
                          BlocProvider.of<CreateNoteBloc>(context)
                              .add(OnAdd(data));
                          Navigator.pop(context);
                          ScreenUpdate().changeValue(true);
                        }
                      }
                    },
                    child: update
                        ? const Text(
                            'UPDATE',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'SUBMIT',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ))
              ]);
            }
            return Container();
          },
        ),
      ),
    );
  }
}
