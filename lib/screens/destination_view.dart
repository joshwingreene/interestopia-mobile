import 'package:flutter/material.dart';
import 'package:interestopia/models/destination.dart';
import 'package:interestopia/observers/view_navigator_observer.dart';
import 'package:interestopia/screens/search/search.dart';
import 'package:interestopia/screens/settings/setting.dart';


class DestinationView extends StatefulWidget {

  final Destination destination;
  final VoidCallback onNavigation;

  const DestinationView({ Key key, this.destination, this.onNavigation }) : super(key: key);

  @override
  _DestinationViewState createState() => _DestinationViewState();
}

class _DestinationViewState extends State<DestinationView> {
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: 'sample test: ${widget.destination.title}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      observers: <NavigatorObserver>[
        ViewNavigatorObserver(widget.onNavigation),
      ],
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            // ignore: missing_return
            builder: (BuildContext context) {
              switch (settings.name) {
                case '/':
                  if (widget.destination.index == 0) {
                      return RootPage(destination: widget.destination);
                  } else if (widget.destination.index == 1) {
                    return Search(destination: widget.destination);
                  } else if ((widget.destination.index == 2)) {
                    return Settings(destination: widget.destination);
                  }
                  break;
                // the other routes will depend on the destination index
                case '/list':
                  return ListPage(destination: widget.destination);
                case '/text':
                  return TextPage(destination: widget.destination);
              }
            },
        );
      },
    );
  }
}

class RootPage extends StatelessWidget {
  const RootPage({ Key key, this.destination }) : super(key: key);

  final Destination destination;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(destination.title),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: SizedBox.expand(
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, "/list");
          },
        ),
      ),
    );
  }
}

class ListPage extends StatelessWidget {
  const ListPage({ Key key, this.destination }) : super(key: key);

  final Destination destination;

  @override
  Widget build(BuildContext context) {
    const List<int> shades = <int>[50, 100, 200, 300, 400, 500, 600, 700, 800, 900];

    return Scaffold(
      appBar: AppBar(
        title: Text(destination.title),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey,
      body: SizedBox.expand(
        child: ListView.builder(
          itemCount: shades.length,
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 128,
              child: Card(
                color: Colors.grey,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "/text");
                  },
                  child: Center(
                    child: Text('Item $index', style: Theme.of(context).primaryTextTheme.display1),
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

class TextPage extends StatefulWidget {
  const TextPage({ Key key, this.destination }) : super(key: key);

  final Destination destination;

  @override
  _TextPageState createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: 'sample text: ${widget.destination.title}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.destination.title),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[400],
      body: Container(
        padding: const EdgeInsets.all(32.0),
        alignment: Alignment.center,
        child: TextField(controller: _textController),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}