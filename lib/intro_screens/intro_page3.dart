import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Lottie.network(
              'https://assets9.lottiefiles.com/packages/lf20_ZMPtmxotAa.json')),
    );
  }
}
 // Widget build(BuildContext context) {
 //   return Container(
 //     color: Colors.blueGrey,
 //     child: Center(
 //       child: Column(
 //         children: [
 //           Container (
 //               child: Text(
 //                 'this app is created to help you to keep track what you need to do ',
 //               )),
 //           Lottie.network(
 //               'https://assets5.lottiefiles.com/private_files/lf30_TBKozE.json')
  //        ],
  //      ),
  //    ),
//    );
//  }
//}



//Lottie.network(
            //  'https://assets5.lottiefiles.com/private_files/lf30_TBKozE.json')),



// https://assets9.lottiefiles.com/packages/lf20_ZMPtmxotAa.json