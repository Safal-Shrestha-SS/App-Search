import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
class CustomSearchDelegate extends SearchDelegate {
  final List<Application> app;
  CustomSearchDelegate(this.app);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: () {}),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Application> suggestionList = [];
    List<Application> hello(app) {
      List<Application> test = [];
      suggestionList.clear();
      // test.clear();
      app.forEach((element) {
        if (element.appName.toLowerCase().startsWith(query.toLowerCase()))
          test.add(element);
      });
      return test;
    }
    print('test');
    print(suggestionList.length);
    suggestionList = query.isEmpty ? List.empty() : hello(app);
        if (suggestionList.isEmpty) print('yes ');
    return suggestionList.isEmpty
        ? Center(child: Text('App not found'))
        : ListView.builder(
            itemBuilder: (context, index) {
              var app = suggestionList[index];

              return ListTile(
                onTap: () {
                  query = suggestionList[index].appName;
                  DeviceApps.openAppSettings(
                                      suggestionList[index].packageName);
                },
                leading: app is ApplicationWithIcon
                                          ? CircleAvatar(
                                              backgroundImage: MemoryImage(app.icon),
                                              backgroundColor: Colors.white,
                                            )
                                          : null,
                //This shows the appp icon
                title: RichText(
                    text: TextSpan(
                        text: suggestionList[index]
                            .appName
                            .substring(0, query.length),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        children: [
                      TextSpan(
                          text: suggestionList[index]
                              .appName
                              .substring(query.length),
                          style: TextStyle(color: Colors.grey))
                    ])),
              );
            },
            itemCount: suggestionList.length,
          );
  }
}
