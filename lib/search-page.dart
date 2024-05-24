import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<String> _allItems = ['Apple', 'Banana', 'Orange', 'Pineapple', 'Strawberry'];
  List<String> _searchResults = [];

  void _search(String query) {
    final results = _allItems.where((item) => item.toLowerCase().contains(query.toLowerCase())).toList();
    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF282b2f),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search',
                    //border: OutlineInputBorder(),
                  ),
                  onChanged: _search,
                ),
                SizedBox(height: 16.0),
                // Expanded(
                //   child: _searchResults.isNotEmpty
                //       ? ListView.builder(
                //           itemCount: _searchResults.length,
                //           itemBuilder: (context, index) {
                //             return ListTile(
                //               title: Text(_searchResults[index]),
                //             );
                //           },
                //         )
                //       : Center(
                //           child: Text('No results found'),
                //         ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}