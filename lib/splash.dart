import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project3/HomeScreen.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}); // Corrected constructor syntax

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  
  @override
  void initState() {
    super.initState();
    


    
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(Duration(seconds: 2),(){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen(),));
    });
  }
  
  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays: SystemUiOverlay.values);
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/logo.png',height: 300,width: 300,),
      ),
    );
  }
}
