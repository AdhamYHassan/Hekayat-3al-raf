import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    Center(
      child: Text(
        'Hello Home',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    ),
    Center(
      child: Text(
        'Hello More',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? 'Home' : 'More'),
        centerTitle: true,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: GNav(
            gap: 8,
            activeColor: Theme.of(context).primaryColor,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(milliseconds: 300),
            tabBackgroundColor: Theme.of(
              context,
            ).primaryColor.withValues(alpha: 0.1),
            color: Colors.grey,
            selectedIndex: _currentIndex,
            onTabChange: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            tabs: const [
              GButton(icon: Icons.home_rounded, text: 'Home'),
              GButton(icon: Icons.more_horiz_rounded, text: 'More'),
            ],
          ),
        ),
      ),
    );
  }
}
