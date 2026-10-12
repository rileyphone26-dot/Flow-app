import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:spark/src/core/routing/app_router.dart';
@RoutePage()
class LoginPage extends StatefulWidget {
 const LoginPage({super.key});
 @override State<LoginPage> createState()=>_LoginPageState();
}
class _LoginPageState extends State<LoginPage>{
 final email=TextEditingController(), password=TextEditingController();
 bool busy=false; String? error;
 @override void dispose(){email.dispose();password.dispose();super.dispose();}
 Future<void> submit() async {
  if(kIsWeb){setState(()=>error='Firebase Web app configuration is required before web sign-in can work.');return;}
  setState(()=>{busy=true,error=null});
  try {await FirebaseAuth.instance.signInWithEmailAndPassword(email:email.text.trim(),password:password.text);if(mounted)context.router.replaceAll([const MainRoute()]);}
  on FirebaseAuthException catch(e){if(mounted)setState(()=>error=e.message??'Sign-in failed.');}
  catch(_){if(mounted)setState(()=>error='Sign-in failed. Please try again.');}
  finally{if(mounted)setState(()=>busy=false);}
 }
 @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Log in to Flow')),body:SafeArea(child:Center(child:SingleChildScrollView(padding:const EdgeInsets.all(24),child:ConstrainedBox(constraints:const BoxConstraints(maxWidth:420),child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
 TextField(controller:email,keyboardType:TextInputType.emailAddress,decoration:const InputDecoration(labelText:'Email',border:OutlineInputBorder())),
 const SizedBox(height:16),TextField(controller:password,obscureText:true,decoration:const InputDecoration(labelText:'Password',border:OutlineInputBorder()),onSubmitted:(_)=>submit()),
 if(error!=null) Padding(padding:const EdgeInsets.only(top:12),child:Text(error!,style:TextStyle(color:Theme.of(context).colorScheme.error))),
 const SizedBox(height:20),FilledButton(onPressed:busy?null:submit,child:busy?const CircularProgressIndicator():const Text('Log in')),
 TextButton(onPressed:()=>context.router.push(const RegisterRoute()),child:const Text('Create a Flow account'))
]))))));
}