import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  final String title;
  final String duration;
  final Widget? nutritionInfo;

  // Width Control Parameters
  final double widthFactor;
  final double minWidth;
  final double maxWidth;

  // Visual styling
  final double borderRadius;
  final double borderWidth;

  // Spacing
  final double horizontalOuterPadding;
  final double verticalOuterPadding;
  final double innerPadding;

  // Nutrition Info specific controls
  final double nutritionHorizontalPadding;
  final double nutritionTopPadding;

  // Vertical position control
  final double verticalPositionFactor; // 0.0 (top) to 1.0 (bottom)

  // space between border and title
  final double titleTopPadding;

  const RecipeCard({
    super.key,
    required this.title,
    required this.duration,
    this.nutritionInfo,

    // Width defaults
    this.widthFactor = 0.95,
    this.minWidth = 300.0,
    this.maxWidth = 500.0,

    // Style defaults
    this.borderRadius = 12.0,
    this.borderWidth = 1.0,

    // Spacing defaults
    this.horizontalOuterPadding = 12.0,
    this.verticalOuterPadding = 8.0, //space between each card
    this.innerPadding = 15.0,

    // Nutrition info defaults
    this.nutritionHorizontalPadding = 0.0, // controls width of the nutrition info box using padding
    this.nutritionTopPadding = 8.0, // space between time and nutrition info

    // Vertical position default (centered)
    this.verticalPositionFactor = 0.5, // if used a single widget it appears in the middle
        
    this.titleTopPadding = 10, // space between the border and the heading
  });

  @override
  Widget build(BuildContext context) { 
    final screenSize = MediaQuery.of(context).size;
    double cardWidth = screenSize.width * widthFactor;
    cardWidth = cardWidth.clamp(minWidth, maxWidth);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalOuterPadding,
        vertical: verticalOuterPadding,
      ),
      
      child: SizedBox(
        width: cardWidth,
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(color: Colors.black, width: borderWidth),
          ),
          child: Padding(
            padding: EdgeInsets.all(innerPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Chivo',
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                      height: 1.0,
                      letterSpacing: 0.0,
                    ),
                  ),
                ),

                const SizedBox(height: 8), // space between Title and Time

                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    duration,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ),

                if (nutritionInfo != null) ...[
                  SizedBox(height: nutritionTopPadding),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: nutritionHorizontalPadding,
                    ),
                    child: nutritionInfo!,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}