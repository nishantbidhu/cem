import 'package:flutter/material.dart';

class CemLogo extends StatelessWidget {
  final double size;

  const CemLogo({super.key, this.size = 140.0});

  @override
  Widget build(BuildContext context) {
    // Sizing ratios based on your CSS
    final double fontSize = size * 0.3; // 42px on 140px box
    final double borderRadius = size * 0.25; // 35px on 140px box

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 20, offset: Offset(0, 10)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            // --- BOTTOM LAYER (Dark Base, Orange Text) ---
            Container(
              color: const Color(0xFF1E293B), // navy-light
              alignment: Alignment.center,
              child: Text(
                "CEM",
                style: TextStyle(
                  color: const Color(0xFFFF8C00), // marigold
                  fontSize: fontSize,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.5,
                  height: 1.0,
                ),
              ),
            ),

            // --- TOP LAYER (Orange Base, Dark Text with Diagonal Clip) ---
            ClipPath(
              clipper: DiagonalClipper(),
              child: Container(
                color: const Color(0xFFFF8C00), // marigold
                alignment: Alignment.center,
                child: Text(
                  "CEM",
                  style: TextStyle(
                    color: const Color(0xFF0A1128), // navy-deep
                    fontSize: fontSize,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.5,
                    height: 1.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- THE MAGIC CLIPPER ---
// This perfectly slices the top layer diagonally from bottom-left to top-right
class DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width, 0); // Start at Top-Right
    path.lineTo(size.width, size.height); // Draw to Bottom-Right
    path.lineTo(0, size.height); // Draw to Bottom-Left
    path.close(); // Connect back to Top-Right
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}