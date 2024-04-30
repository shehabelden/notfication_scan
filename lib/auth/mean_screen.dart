import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/cubit.dart';
import 'cubit/state.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});
  @override
  Widget build(BuildContext context) {
    AuthCubit cubit =AuthCubit.get(context);
    return  BlocBuilder<AuthCubit,AuthMainState>(
        builder: (context,state) {
          return Scaffold(
            body:cubit.screens[cubit.index],
            bottomNavigationBar: BottomNavigationBar(
              items: const[
                BottomNavigationBarItem(icon: Icon(Icons.credit_card),label: "card"),
                BottomNavigationBarItem(icon: Icon(Icons.family_restroom),label:"family"),

              ],
              currentIndex :cubit.index,
              unselectedLabelStyle: TextStyle(color: Colors.grey),
              unselectedItemColor: Colors.grey,
              selectedItemColor:const Color(0xFF800f2f),
              showUnselectedLabels: true,
              onTap: (i){
                cubit.screenCubit(i);
              },
            ),
          );
        }
    );
  }
}
