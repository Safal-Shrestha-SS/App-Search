import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'search.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<Application> apps;
  List app = [];
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
          builder: (context) => NewScreen(payload: payload)),
    );
  }

  Future<void> showNotificationMediaStyle() async {

   
    

    List<AndroidNotificationChannel> channels =
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            .getNotificationChannels();
    print(channels.length);
    // for (AndroidNotificationChannel channel in channels) {
    //   print(channel.name);
    // }
    if (channels.length==2) {
      print('yaa');
       var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'inbox channel id', 'inboxchannel name', 'inbox channel description',
        ticker: 'ticker', ongoing: true, fullScreenIntent: false);
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          0, 'notification title', null, platformChannelSpecifics,
          payload: 'Welcome to the Local Notification demo');
    } else {
      print('nay');
      await flutterLocalNotificationsPlugin.cancelAll();
      channels = List.empty();
          print(channels.length);

    }
  }

  showNotification() async {
    var androids = AndroidNotificationDetails('id', 'channel ', 'description',
        priority: Priority.high, importance: Importance.max);
    var iOS = IOSNotificationDetails();
    var platform = new NotificationDetails(android: androids, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
        0, 'Flutter devs', 'Flutter Local Notification Demo', platform,
        payload: 'Welcome to the Local Notification demo');
  }

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOs);

    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: selectNotification);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('APP Search'),
          actions: [
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(
                      context: context, delegate: CustomSearchDelegate(apps));
                }),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Text(
                  'You have pushed the button this many times:',
                ),
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
              Expanded(
                child: FutureBuilder(
                    future: DeviceApps.getInstalledApplications(
                        includeAppIcons: true,
                        onlyAppsWithLaunchIntent: true,
                        includeSystemApps: true),
                    builder:
                        (context, AsyncSnapshot<List<Application>> snapshot) {
                      if (snapshot.data == null)
                        return CircularProgressIndicator();
                      apps = snapshot.data;

                      return ListView.builder(
                          itemCount: apps.length,
                          itemBuilder: (context, index) {
                            var app = apps[index];
                            return ListTile(
                              leading: app is ApplicationWithIcon
                                  ? CircleAvatar(
                                      backgroundImage: MemoryImage(app.icon),
                                      backgroundColor: Colors.white,
                                    )
                                  : null,
                              title: GestureDetector(
                                child: Text(snapshot.data[index].appName),
                                onTap: () {
                                  DeviceApps.openApp(
                                      snapshot.data[index].packageName);
                                },
                              ),
                            );
                          });
                    }),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            _incrementCounter();

            await showNotificationMediaStyle();
          },
          tooltip: 'Increment',
          child: Icon(Icons.refresh),
        ),
      ),
    );
  }
}

class NewScreen extends StatelessWidget {
  final String payload;

  NewScreen({
    @required this.payload,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(payload),
      ),
    );
  }
}
