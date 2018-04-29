import 'package:flutter/material.dart';
import 'package:hablamos/chat.dart';

void main() {
  runApp(new Hablamos());
}

class Hablamos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Hablamos",
      home: new HomeScreen(),
      theme: new ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.red[400],
        highlightColor: Colors.red[300],
        accentColor: Colors.redAccent,
      ),
    );
  }
}

// HomeScreen base stateful controller
class HomeScreen extends StatefulWidget {
  @override
  State createState() => new HomeScreenBaseState();
}

class HomeScreenBaseState extends State<HomeScreen> {
  List<FriendCard> _friends = <FriendCard>[];
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Hablamos"),
          // The Add button just adds a default friend
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.add),
              tooltip: 'Add Friends',
              onPressed: () {setState((){_friends.insert(0, FriendCard("Jack Liu", "This random developer"));});},
            ),
          ],
      ),
      body: new ListView.builder(
        padding: new EdgeInsets.all(8.0), // Padding
        itemBuilder: (_, int index) => _friends[index], // Build each item from index
        itemCount: _friends.length,
      ),
    );
  }
}

class FriendCard extends StatelessWidget {
  final String name, description;
  FriendCard(this.name, this.description);
  @override
  Widget build(BuildContext context) {
    return new FlatButton(
      padding: new EdgeInsets.all(0.0),
      onPressed: () {
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => new ChatScreen("id", name, description)),
        );
      },
      child: new Column(
        children: <Widget>[
          new Container(
            child: new ListTile(
              leading: const CircleAvatar(child: const Text("tmp")),
              title: new Text(name),
              subtitle: new Text(description),
            ),
          ),
          new Divider(height: 1.0), // A pixel
        ],
      ),
    );
  }
}