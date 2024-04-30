import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/cubit.dart';
import 'cubit/state.dart';
class ScanFamily extends StatelessWidget {
  const ScanFamily({super.key});
  @override
  Widget build(BuildContext context) {
    AuthCubit cubit=AuthCubit.get(context);
    cubit.myProfile();
    return BlocBuilder<AuthCubit,AuthMainState>(
        builder: (context,state) {
          return Scaffold(
            body:SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0,left: 10),
                    child: Text("hi ${cubit.myProfileData["name"]}  to scan \n app for ${cubit.myProfileData["userLayer"]}",style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 200.0,left: 120),
                    child: InkWell (
                      onTap: ()async{
                        await cubit.redar(cubit.myProfileData["userLayer"]);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('scan my card',style: TextStyle(
                                color: Colors.white
                            ),),
                            action: SnackBarAction(
                              label: '',
                              onPressed: () {
                              },
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 120,
                        height: 50,
                        alignment: Alignment.center,
                        color: Color(0xFF800f2f),
                        child:const Text("scan family card",style: TextStyle(
                            color: Colors.white
                        ),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}