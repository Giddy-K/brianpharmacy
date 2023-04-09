import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String drug = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Card(
          child: TextField(
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search), hintText: 'Search'),
            onChanged: (val) {
              setState(() {
                drug = val;
              });
            },
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('admin').snapshots(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final query = drug.toLowerCase();

          final filteredDocs = snapshots.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final drugs = List<String>.from(data['drugs']);
            final matches =
                drugs.any((drug) => drug.toLowerCase().contains(query));
            return matches;
          }).toList();

          return ListView.builder(
            itemCount: filteredDocs.length,
            itemBuilder: (context, index) {
              final data = filteredDocs[index].data() as Map<String, dynamic>;
              return InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Popup Dialog Box'),
                        content: Text('This is a popup dialog box.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: ListTile(
                  isThreeLine: true,
                  leading: Text(data['profession']),
                  title: Text(data['name']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Longitude ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: data['location'].first),
                            const TextSpan(
                              text: 'Latitude ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: data['location'].last),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
