// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'dart:async';
// import 'dart:math' as math;
// import 'firebase_options.dart';

// // Feature & Presentation Imports
// import 'features/listings/presentation/listing_screen.dart';
// import 'features/listings/presentation/seek_feed_screen.dart';
// import 'features/listings/presentation/pages/creation_form_screen.dart';
// import 'features/listings/presentation/history_screen.dart';
// import 'features/auth/presentation/profile_screen.dart'; // Newly integrated
// import 'features/auth/presentation/splash_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(const CEMApp());
// }

// class CEMApp extends StatelessWidget {
//   const CEMApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         brightness: Brightness.dark,
//         scaffoldBackgroundColor: const Color(0xFF0A1128), // Navy Deep
//         useMaterial3: true,
//       ),
//       initialRoute: '/',
//       routes: {
//         '/': (context) => const SplashScreen(),
//         '/home': (context) => const MainNavigationWrapper(),
//       },
//     );
//   }
// }

// class MainNavigationWrapper extends StatefulWidget {
//   const MainNavigationWrapper({super.key});
//   @override
//   State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
// }

// class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
//   int _selectedIndex = 0; 

//   // Complete list of top-level pages
//   final List<Widget> _pages = [
//     const ListingScreen(),
//     const SeekFeedScreen(),
//     const HistoryScreen(),
//     const ProfileScreen(), 
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // IndexedStack preserves state (scroll position) across tabs
//       body: IndexedStack(index: _selectedIndex, children: _pages),
//       bottomNavigationBar: _buildUnifiedDock(),
//     );
//   }

//   Widget _buildUnifiedDock() {
//     return Stack(
//       clipBehavior: Clip.none,
//       alignment: Alignment.center,
//       children: [
//         Container(
//           height: 80,
//           decoration: BoxDecoration(
//             color: const Color(0xFF0F172A).withOpacity(0.95), // Glassy Navy
//             border: const Border(top: BorderSide(color: Colors.white10)),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               // LEFT SIDE
//               IconButton(
//                 icon: Icon(Icons.house, 
//                   color: _selectedIndex == 0 ? const Color(0xFFFFB74D) : const Color(0xFF94A3B8)),
//                 onPressed: () => setState(() => _selectedIndex = 0),
//               ),
//               IconButton(
//                 icon: Icon(Icons.person_search, 
//                   color: _selectedIndex == 1 ? const Color(0xFFFFB74D) : const Color(0xFF94A3B8)),
//                 onPressed: () => setState(() => _selectedIndex = 1),
//               ),
              
//               // CENTER SYMMETRY SPACE
//               const SizedBox(width: 60),

//               // RIGHT SIDE
//               IconButton(
//                 icon: Icon(Icons.shopping_cart, 
//                   color: _selectedIndex == 2 ? const Color(0xFFFFB74D) : const Color(0xFF94A3B8)),
//                 onPressed: () => setState(() => _selectedIndex = 2),
//               ),
//               IconButton(
//                 icon: Icon(Icons.account_circle, 
//                   color: _selectedIndex == 3 ? const Color(0xFFFFB74D) : const Color(0xFF94A3B8)),
//                 onPressed: () => setState(() => _selectedIndex = 3),
//               ),
//             ],
//           ),
//         ),
        
//         // Symmetrical Diamond FAB
//         Positioned(
//           top: -30,
//           child: GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => CreationFormScreen(isSalePost: _selectedIndex == 0),
//                 ),
//               );
//             },
//             child: Transform.rotate(
//               angle: 45 * math.pi / 180,
//               child: Container(
//                 width: 60, height: 60,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFFF8C00), // Marigold Action
//                   borderRadius: BorderRadius.circular(18),
//                   boxShadow: [
//                     BoxShadow(
//                       color: const Color(0xFFFF8C00).withOpacity(0.4),
//                       blurRadius: 25,
//                       offset: const Offset(0, 10),
//                     )
//                   ],
//                 ),
//                 child: Transform.rotate(
//                   angle: -45 * math.pi / 180,
//                   child: const Icon(Icons.add, color: Colors.white, size: 24),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }










import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:math' as math;
import 'firebase_options.dart';

// Feature & Presentation Imports
import 'features/listings/presentation/listing_screen.dart';
import 'features/listings/presentation/seek_feed_screen.dart';
import 'features/listings/presentation/pages/creation_form_screen.dart';
import 'features/listings/presentation/history_screen.dart';
import 'features/auth/presentation/profile_screen.dart'; 
import 'features/auth/presentation/splash_screen.dart';
import 'features/auth/presentation/auth_page.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const CEMApp());
}

class CEMApp extends StatelessWidget {
  const CEMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A1128),
        useMaterial3: true,
      ),
      initialRoute: '/', // Always starts at Splash -> Login
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const AuthPage(), 
        '/home': (context) => const MainNavigationWrapper(),
      },
    );
  }
}

class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key});
  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _selectedIndex = 0; 

  final List<Widget> _pages = [
    const ListingScreen(),
    const SeekFeedScreen(),
    const HistoryScreen(),
    const ProfileScreen(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: _buildUnifiedDock(),
    );
  }

  Widget _buildUnifiedDock() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A).withOpacity(0.95),
            border: const Border(top: BorderSide(color: Colors.white10)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.house, color: _selectedIndex == 0 ? const Color(0xFFFFB74D) : const Color(0xFF94A3B8)),
                onPressed: () => setState(() => _selectedIndex = 0),
              ),
              IconButton(
                icon: Icon(Icons.person_search, color: _selectedIndex == 1 ? const Color(0xFFFFB74D) : const Color(0xFF94A3B8)),
                onPressed: () => setState(() => _selectedIndex = 1),
              ),
              const SizedBox(width: 60),
              IconButton(
                icon: Icon(Icons.shopping_cart, color: _selectedIndex == 2 ? const Color(0xFFFFB74D) : const Color(0xFF94A3B8)),
                onPressed: () => setState(() => _selectedIndex = 2),
              ),
              IconButton(
                icon: Icon(Icons.account_circle, color: _selectedIndex == 3 ? const Color(0xFFFFB74D) : const Color(0xFF94A3B8)),
                onPressed: () => setState(() => _selectedIndex = 3),
              ),
            ],
          ),
        ),
        Positioned(
          top: -30,
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CreationFormScreen(isSalePost: _selectedIndex == 0)));
            },
            child: Transform.rotate(
              angle: 45 * math.pi / 180,
              child: Container(
                width: 60, height: 60,
                decoration: BoxDecoration(color: const Color(0xFFFF8C00), borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: const Color(0xFFFF8C00).withOpacity(0.4), blurRadius: 25, offset: const Offset(0, 10))]),
                child: Transform.rotate(angle: -45 * math.pi / 180, child: const Icon(Icons.add, color: Colors.white, size: 24)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}