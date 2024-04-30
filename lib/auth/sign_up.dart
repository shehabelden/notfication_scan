import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../utils/var/controllers.dart';
import 'cubit/cubit.dart';
import 'cubit/state.dart';
import 'drower.dart';
import 'login_check.dart';
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    AuthCubit cubit=AuthCubit.get(context);
    final GlobalKey<FormState> formState1 = GlobalKey();
    return  Scaffold(
      body: BlocBuilder<AuthCubit,AuthMainState>(
          builder: (context,state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 200.0,right: 20,left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const  Padding(
                      padding:  EdgeInsets.only(bottom: 20.0),
                      child:  Text("Sign up your account",style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),),
                    ),
                    Form(
                      key: formState1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            style:const TextStyle(
                              color: Color(0xFF888888),
                            ),
                            decoration: InputDecoration(
                              hintText: "user name",
                              hintStyle:
                              const TextStyle(
                                color: Color(0xFF888888),
                              ),
                              filled: true,
                              fillColor:const Color(0xFFFAFAFA), // Change this to the desired background color

                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white.withOpacity(0)), //
                                borderRadius: BorderRadius.circular(12),// Change this to the desired border color
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:const BorderSide(color: Color(0xff888888)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            controller:Controllers.userNameController ,
                          ),
                         const Text("  email",style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF888888),
                          ),),
                          TextFormField(
                            style:const TextStyle(
                              color: Color(0xFF888888),
                            ),
                            controller: Controllers.emailController,
                            decoration: InputDecoration(
                              hintText: "email",
                              hintStyle:
                              const TextStyle(
                                color: Color(0xFF888888),
                              ),
                              filled: true,
                              fillColor:const Color(0xFFFAFAFA), // Change this to the desired background color

                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white.withOpacity(0)), //
                                borderRadius: BorderRadius.circular(12),// Change this to the desired border color
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:const BorderSide(color: Color(0xff888888)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20,),
                          const Text("  chose your layer",style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF888888),
                          ),),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: DropDownTypeList(
                              width: 400,
                              list: cubit.list,
                              fun: cubit,
                            ),
                          ),

                          const Text("  password",style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF888888),
                          ),),
                          TextFormField(
                            style:const TextStyle(
                              color: Color(0xFF888888),
                            ),
                            obscureText:cubit.hidePasse,
                            decoration: InputDecoration(
                              hintText: "password",
                              suffixIcon:IconButton(onPressed: ()async{
                                await cubit.hidePass();
                              },
                                icon: Icon(cubit.hidePasse== true ?Icons.visibility_off :Icons.visibility),),
                              hintStyle:
                              const TextStyle(
                                color: Color(0xFF888888),
                              ),
                              filled: true,
                              fillColor:const Color(0xFFFAFAFA), // Change this to the desired background color

                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white.withOpacity(0)), //
                                borderRadius: BorderRadius.circular(12),// Change this to the desired border color
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:const BorderSide(color: Color(0xff888888)),
                                borderRadius: BorderRadius.circular(12),
                              ),

                            ),
                            controller:Controllers.passwordController ,
                          ),
                          TextFormField(
                            style:const TextStyle(
                              color: Color(0xFF888888),
                            ),
                            obscureText:cubit.hidePasse,
                            decoration: InputDecoration(
                              hintText: "password check",
                              hintStyle:
                              const TextStyle(
                                color: Color(0xFF888888),
                              ),
                              filled: true,
                              fillColor:const Color(0xFFFAFAFA), // Change this to the desired background color
                              suffixIcon:IconButton(onPressed: ()async{
                                await cubit.hidePass();
                              },
                                icon: Icon(cubit.hidePasse== true ?Icons.visibility_off :Icons.visibility),),
                              enabledBorder: OutlineInputBorder(

                                borderSide: BorderSide(color: Colors.white.withOpacity(0)), //
                                borderRadius: BorderRadius.circular(12),// Change this to the desired border color
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:const BorderSide(color: Color(0xff888888)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            controller:Controllers.passwordCheckController ,
                            validator: (value){
                              if(Controllers.passwordController.text !=value){
                                return "password dosent same";
                              }else{
                                return null;
                              }
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0,left: 10.0),
                            child: InkWell(
                              onTap: (){
                                if(!formState1.currentState!.validate()){
                              }else{
                                  Navigator.push(context, MaterialPageRoute(builder: (_){
                                    return const LoginCheck();
                                  }));
                                  cubit.signUpCubit
                                    (Controllers.emailController.text,
                                      Controllers.passwordController.text,
                                      Controllers.userNameController.text,
                                    cubit.userType,
                                  );
                                }
                              },
                              child: Container(
                                height: 50,
                                width: 300,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Color(0xFF800f2f),
                                    borderRadius: BorderRadius.circular(12),
                                ),
                                child:const Text("Sign Up",style: TextStyle(
                                    color: Colors.white
                                ),),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
      ),
    );
  }
}