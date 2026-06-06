import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FoodBubble extends StatelessWidget {
  final String img;
  final double s;

  const FoodBubble({super.key, required this.img, required this.s});

  @override
  Widget build(BuildContext c) {
    return Container(
      width: s,
      height: s,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 3),
        boxShadow: const [
          BoxShadow(color: Color(0xff6C63FF), offset: Offset(5, 5)),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(s * 0.15),
        child: Image.asset(img),
      ),
    );
  }
}

class LandingView extends StatelessWidget {
  const LandingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    left: 20,
                    top: 40,
                    child: FoodBubble(img: 'assets/images/fries.png', s: 140),
                  ),
                  Positioned(
                    right: 50,
                    top: 10,
                    child: FoodBubble(img: 'assets/images/taco.png', s: 90),
                  ),
                  Positioned(
                    right: 10,
                    top: 180,
                    child: FoodBubble(img: 'assets/images/rice.png', s: 70),
                  ),
                  Positioned(
                    left: 40,
                    top: 330,
                    child: FoodBubble(img: 'assets/images/pizza.png', s: 80),
                  ),
                  Positioned(
                    left: 150,
                    top: 400,
                    child: FoodBubble(img: 'assets/images/cake.png', s: 120),
                  ),
                  Positioned(
                    right: 30,
                    top: 310,
                    child: FoodBubble(img: 'assets/images/apple.png', s: 130),
                  ),
                  Positioned(
                    left: 10,
                    bottom: 30,
                    child: FoodBubble(img: 'assets/images/burger.png', s: 150),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: FoodBubble(img: 'assets/images/pasta.png', s: 180),
                  ),
                  Positioned(
                    left: 190,
                    top: 210,
                    child: FoodBubble(
                      img: 'assets/images/chocolate.png',
                      s: 100,
                    ),
                  ),
                  Positioned(
                    left: 220,
                    top: 60,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 160,
                    top: 350,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xff6C63FF)),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 90,
                    bottom: 120,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xff6C63FF)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              'Explore, Scan and',
              style: TextStyle(fontSize: 38, fontWeight: FontWeight.w700),
            ),
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Eat ',
                    style: TextStyle(
                      color: Color(0xff6C63FF),
                      fontSize: 38,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: 'Healthy!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 38,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Eat Healthy and tasty food with us.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),

            // Your updated, styled button integrated here:
            SizedBox(
              width: 260,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () => context.go('/home'),
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
