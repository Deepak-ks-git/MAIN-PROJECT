import 'package:flutter/material.dart';
import 'package:project3/CompanyRegisterPage.dart';
import 'package:project3/LoginPage.dart';
import 'package:project3/SupplierLogin.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            
            Center(
              child: Image.asset(
                'assets/logo.png',
                height: 300,
                width: 300,
              ),
            ),
            Text(
              'Use the smart way for your',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(
              'procurement management.',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 150),
            GradientButtonFb4(text: 'Login or SignUp', onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
              
            }),
            const SizedBox(height: 15),
            GradientButtonFb4(text: 'Supplier login', onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>SupplierLogin()));
              
            }),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      ' Or for new Company ',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            GradientButtonFb4(
              text: 'Register Company',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CompanyRegisterPage()),
                );
              },
            ),
            const SizedBox(height: 20), // Add some additional space at the bottom
          ],
        ),
      ),
    );
  }
}

class GradientButtonFb4 extends StatelessWidget {
  final String text;
  final Function() onPressed;

  const GradientButtonFb4({
    required this.text,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final double borderRadius = 25;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 22, 41, 125),
            Color.fromARGB(255, 3, 16, 27),
          ],
        ),
      ),
      child: ElevatedButton(
        
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          alignment: Alignment.center,
          padding: MaterialStateProperty.all(
            const EdgeInsets.only(right: 70, left: 70, top: 5, bottom: 5),
          ),
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white,fontSize: 14),
          
        ),
      ),
    );
  }
}
