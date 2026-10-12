import 'package:auto_route/auto_route.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spark/src/core/design_system/components/atoms/icons.dart';
import 'package:spark/src/core/routing/app_router.dart';
import 'package:spark/src/core/design_system/tokens/colors.dart';
@RoutePage()
class AuthPromptPage extends StatelessWidget {
 const AuthPromptPage({super.key,this.onClose});
 final VoidCallback? onClose;
 @override Widget build(BuildContext context)=>Scaffold(
 backgroundColor:Theme.of(context).colorScheme.surface,
 appBar:onClose==null?null:AppBar(leading:IconButton(padding:EdgeInsets.zero,onPressed:onClose,icon:AppIcon(AppIconData.cancel,color:Theme.of(context).colorScheme.onSurface)),backgroundColor:Colors.transparent,elevation:0),
 body:Stack(children:[
 Positioned.fill(child:Image.asset('branding/gradient.webp',fit:BoxFit.cover,package:'assets')),
 SafeArea(child:Center(child:Padding(padding:const EdgeInsets.all(24),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[
 SvgPicture.asset('assets/images/logo_dark_mode.svg',height:140,width:140),
 const SizedBox(height:21),const Text('Welcome to Flow',style:TextStyle(fontSize:26,fontWeight:FontWeight.bold,color:AppColors.white),textAlign:TextAlign.center),
 const SizedBox(height:8),const Text('Log in or create your Flow account to get started.',textAlign:TextAlign.center,style:TextStyle(color:AppColors.white,fontSize:20,height:1.5)),
 const SizedBox(height:48),SizedBox(width:320,child:FilledButton(onPressed:()=>context.router.push(const LoginRoute()),child:const Text('Log in with email'))),
 const SizedBox(height:16),SizedBox(width:320,child:FilledButton.tonal(onPressed:()=>context.router.push(const RegisterRoute()),child:const Text('Create account'))),
 if(onClose!=null)TextButton(onPressed:onClose,child:Text('Continue browsing',style:TextStyle(color:Theme.of(context).colorScheme.onSurface)))
 ]))))
 ]));
}