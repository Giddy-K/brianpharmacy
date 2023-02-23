import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}


class _OnboardingScreenState extends State<OnboardingScreen> {
final controller = PageController();

@override
void dispose(){
  controller.dispose();
  super.dispose();
}
  @override
  Widget build(BuildContext context) => Scaffold(
      body: Container(
        padding:const EdgeInsets.only(bottom: 80),
      child: PageView(
          controller: controller,
          children: [
           Container(
           color:Colors.transparent,
          child: Center(child: Image.asset("assets/images/drug.png"))
                ), //container
         Container(
           color:Colors.transparent,
             child: Center(child: Image.asset("assets/images/pills.png"))
         ),
          //   Container(
          //    color: Colors.green,
          //  child: const Center(child: Text('page 3')) 
          //  ),//container  
           ],
             ), 
            ),      //pageview
      bottomSheet:Container(
        padding:const EdgeInsets.symmetric(horizontal:3.0 ),
        height: 80,
        child:Row(
          mainAxisAlignment:MainAxisAlignment.spaceBetween,
       children: [
         TextButton(
          child:const Text('SKIP'),
          onPressed:() =>controller.jumpToPage(2),
        ),
        Center(
          child: SmoothPageIndicator (
            controller:controller,
            count:2,
            effect:WormEffect(
              spacing:16,
              dotColor: Colors.black26,
              activeDotColor: Colors.teal.shade700
            ),
            onDotClicked: (index) => controller.animateToPage(
              index,
              duration: const Duration(milliseconds:500),
              curve:Curves.easeIn,
            ),
          )
        ),
        TextButton(
          child: const Text('NEXT'),
           onPressed:() => controller.nextPage(
            duration:const Duration(milliseconds:500),
          curve:Curves.easeInOut ),
        ),
       ],
        ),
      ),
  );
  }
