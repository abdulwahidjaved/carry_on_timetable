import 'package:carry_on_timetable/home_page.dart';
import 'package:carry_on_timetable/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MaterialApp(home: BranchPage()));
}

class BranchPage extends StatefulWidget {
  const BranchPage({super.key});

  @override
  BranchPageState createState() => BranchPageState();
}

class BranchPageState extends State<BranchPage> {
  final List<Map<String, dynamic>> branches = [
    {'name': 'AIML Engineering', 'route': HomePage()},
    {'name': 'Mechanical Engineering', 'route': MechanicalPage()},
    {'name': 'Electronics Engineering', 'route': ElectronicsPage()},
    {'name': 'Civil Engineering', 'route': CivilPage()},
  ];

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select your branch",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 3,
          ),
          itemCount: branches.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => branches[index]['route'],
                  ),
                );
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    branches[index]['name'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class MechanicalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mechanical Engineering")),
      body: const Center(child: Text("Coming Soon")),
    );
  }
}

class ElectronicsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Electronics Engineering")),
      body: const Center(child: Text("Coming Soon")),
    );
  }
}

class CivilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Civil Engineering")),
      body: const Center(child: Text("Coming Soon")),
    );
  }
}
