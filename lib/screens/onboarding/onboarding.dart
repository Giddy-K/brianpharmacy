import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}
final controller = PageController();

@override
void dispose(){
  super.dispose();
  controller.dispose();
  
}



class _OnboardingScreenState extends State<OnboardingScreen> {

  @override
  Widget build(BuildContext context) => Scaffold(
      body: Container(
        padding:const EdgeInsets.only(bottom: 80),
      )
      child: PageView(
          controller: controller,
          children: [
           Container(
           color:Colors.red,
          child:const Center(child: Text('page 1'))
                ), //container
         Container(
           color:Colors.indigo,
             child:const Center(child: Text('page 2'))
         ),
            Container(
             color: Colors.green,
           child: const Center(child: Text('page 3')) 
           ),//container  
           ],
        ), //pageview
      bottomSheet:Container(
        padding:const EdgeInsets.symmetric(horizontal)
        height: 80,
        child:Row(
          mainAxisAlignment:MainAxisAlignment.spaceBetween,
       children: [
         TextButton(
          child:const Text('SKIP'),
          onPressed:(){},
        ),
        Center(
          child: SmoothPageIndicator (
            controller:controller,
            count:3,
          )
        ),
        TextButton(
          child: const Text('NEXT'),
           onPressed:(){},
        ),
       ],
        ),
      ),
  ),
  }
