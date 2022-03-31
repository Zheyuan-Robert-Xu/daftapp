import 'package:daftapp/display/page/HealthCalculators.dart';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// reference: https://github.com/JideGuru/youtube_videos
class AnimationScreen extends StatefulWidget {
  const AnimationScreen({Key? key}) : super(key: key);

  @override
  State<AnimationScreen> createState() => _AnimationScreenState();
}

class _AnimationScreenState extends State<AnimationScreen>
    with TickerProviderStateMixin {
  ///
  late AnimationController _coffeeController;
  bool copAnimated = false;

  /// whether the Animation is completed
  bool isTextReady = false;

  @override
  void initState() {
    super.initState();
    _coffeeController = AnimationController(vsync: this);

    /// need to use TickerProviderStateMixin
    _coffeeController.addListener(() {
      if (_coffeeController.value > 0.9) {
        _coffeeController.stop();
        copAnimated = true;
        setState(() {});
        Future.delayed(const Duration(seconds: 1), () {
          isTextReady = true;
          setState(() {});

          /// setSate to reflesh the screen
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _coffeeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Stack(
        children: [
          // White Container top half
          AnimatedContainer(
            duration: const Duration(seconds: 1),
            height: copAnimated ? screenHeight / 3 : screenHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(copAnimated ? 40.0 : 0.0),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Visibility(
                    visible: !copAnimated,
                    child: Lottie.asset(
                      'assets/health.json',
                      // height: MediaQuery.of(context).size.height / 2,
                      fit: BoxFit.fill,
                      controller: _coffeeController,
                      onLoaded: (composition) {
                        _coffeeController
                          ..duration = composition.duration
                          ..forward();
                      },

                      /// change the size of file, in the whole screen it may raise error
                    ),
                  ),
                  Visibility(
                    visible: copAnimated,
                    child: Image.asset(
                      'assets/health.png',
                      height: 190.0,
                      width: 190.0,
                    ),
                  ),
                  Center(
                    child: AnimatedOpacity(
                      opacity: isTextReady ? 1 : 0,
                      duration: const Duration(seconds: 1),
                      child: const Text(
                        'Health Summary',
                        style: TextStyle(
                            fontSize: 50.0, color: Colors.orangeAccent),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Text bottom part
          Visibility(visible: copAnimated, child: const _BottomPart()),
        ],
      ),
    );
  }
}

class _BottomPart extends StatelessWidget {
  const _BottomPart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.green),
              child: const Text(
                'Health Calculators',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HealthCalculators()));
              },
            ),
            // const Text(
            //   'Find The Best Coffee for You',
            //   style: TextStyle(
            //       fontSize: 27.0,
            //       fontWeight: FontWeight.bold,
            //       color: Colors.white),
            // ),
            // const SizedBox(height: 30.0),
            // Text(
            //   'Lorem ipsum dolor sit amet, adipiscing elit. '
            //   'Nullam pulvinar dolor sed enim eleifend efficitur.',
            //   style: TextStyle(
            //     fontSize: 15.0,
            //     color: Colors.white.withOpacity(0.8),
            //     height: 1.5,
            //   ),
            // ),
            // const SizedBox(height: 50.0),
            // Align(
            //   alignment: Alignment.centerRight,
            //   child: Container(
            //     height: 85.0,
            //     width: 85.0,
            //     decoration: BoxDecoration(
            //       shape: BoxShape.circle,
            //       border: Border.all(color: Colors.white, width: 2.0),
            //     ),
            //     child: const Icon(
            //       Icons.chevron_right,
            //       size: 50.0,
            //       color: Colors.white,
            //     ),
            //   ),
            // ),
            const SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }
}
