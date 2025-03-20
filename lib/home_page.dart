import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name = "";
  List<Map<String, dynamic>> items = [
    {
      'date': 'Tue, 13 May, 2025',
      'time': '02:30 PM to 05:30 PM',
      'name': 'Maths-4',
      'checked': false,
    },
    {
      'date': 'Tue, 15 May, 2025',
      'time': '02:30 PM to 05:30 PM',
      'name': 'AOA',
      'checked': false,
    },
    {
      'date': 'Tue, 19 May, 2025',
      'time': '02:30 PM to 05:30 PM',
      'name': 'DBMS',
      'checked': false,
    },
    {
      'date': 'Tue, 21 May, 2025',
      'time': '02:30 PM to 05:30 PM',
      'name': 'OS',
      'checked': false,
    },
    {
      'date': 'Tue, 123 May, 2025',
      'time': '02:30 PM to 05:30 PM',
      'name': 'MP',
      'checked': false,
    },
    {
      'date': '2025-03-19',
      'time': '11:30 AM',
      'name': ' Extra',
      'checked': false,
    },
  ];
  List<Map<String, dynamic>> deletedItems = [];
  List<int> deletedIndices = [];

  @override
  void initState() {
    super.initState();
    _loadName();
    _loadItems();
    _loadDeletedItems();
  }

  void _loadName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('username') ?? "User";
    });
  }

  void _loadItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      List<String>? savedItems = prefs.getStringList('items');
      if (savedItems != null) {
        items =
            savedItems.map((item) {
              return Map<String, dynamic>.from(json.decode(item));
            }).toList();
      }
    });
  }

  void _loadDeletedItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      List<String>? savedDeletedItems = prefs.getStringList('deletedItems');
      if (savedDeletedItems != null) {
        deletedItems =
            savedDeletedItems.map((item) {
              return Map<String, dynamic>.from(json.decode(item));
            }).toList();
      }
      // Load deleted indices
      String? indicesString = prefs.getString('deletedIndices');
      if (indicesString != null) {
        deletedIndices = (json.decode(indicesString) as List).cast<int>();
      }
    });
  }

  void _saveItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedItems = items.map((item) => json.encode(item)).toList();
    prefs.setStringList('items', encodedItems);
  }

  void _saveDeletedItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedDeletedItems =
        deletedItems.map((item) => json.encode(item)).toList();
    prefs.setStringList('deletedItems', encodedDeletedItems);
    // Save deleted indices
    prefs.setString('deletedIndices', json.encode(deletedIndices));
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void _deleteRow(int index) {
    setState(() {
      deletedItems.insert(0, items[index]);
      deletedIndices.insert(0, index);
      items.removeAt(index);
      _saveItems();
      _saveDeletedItems();
    });
  }

  void _undoDelete() {
    if (deletedItems.isNotEmpty) {
      setState(() {
        int restoreIndex = deletedIndices.removeAt(0);
        items.insert(restoreIndex, deletedItems.removeAt(0));
        _saveItems();
        _saveDeletedItems();
      });
    }
  }

  void _restoreDeletedItems() {
    if (deletedItems.isNotEmpty) {
      setState(() {
        // Create a list of items with their original indices
        List<MapEntry<int, Map<String, dynamic>>> itemsToRestore = [];
        for (int i = 0; i < deletedItems.length; i++) {
          int originalIndex = deletedIndices[i];
          originalIndex = originalIndex.clamp(0, items.length);
          itemsToRestore.add(MapEntry(originalIndex, deletedItems[i]));
        }

        // Sort by original index in ascending order to maintain order
        itemsToRestore.sort((a, b) => a.key.compareTo(b.key));

        // Insert items back in their original positions
        for (var entry in itemsToRestore) {
          items.insert(entry.key, entry.value);
        }

        deletedItems.clear();
        deletedIndices.clear();
        _saveItems();
        _saveDeletedItems();
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No items to restore')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Hi, $name",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Time Table",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(items[index]['name']),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    _deleteRow(index);
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                items[index]['date'],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                items[index]['time'],
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                items[index]['name'],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Checkbox(
                                value: items[index]['checked'],
                                onChanged: (bool? value) {
                                  setState(() {
                                    items[index]['checked'] = value ?? false;
                                    _saveItems();
                                  });
                                },
                                activeColor: Colors.blue,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (deletedItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _undoDelete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: Text("Undo", style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: _restoreDeletedItems,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: Text(
                      "Restore All",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
