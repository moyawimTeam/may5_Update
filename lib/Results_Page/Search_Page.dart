import 'package:flutter/material.dart';
import 'package:moyawim2/Constants_Data/Data.dart';
import 'package:moyawim2/Results_Page/Results_Page.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class Data extends SearchDelegate<String> {
  final jobList = jobsList;
  var searchHistory = recentSearchHistory;
  String city = 'غير محدد';
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      DropdownButton(
        icon: Icon(Icons.filter_list),
        items: cities.map((var dropItems) {
          return DropdownMenuItem(value: dropItems, child: Text(dropItems));
        }).toList(),
        onChanged: (var item) {
          city = item;
          var newQuery = query;
          query = '';
          query = newQuery;
        },
        value: city,
      ),
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return ResultsPage(
      job: query,
      city: city,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestion = query.isEmpty
        ? searchHistory
        : jobList.where((s) => s.startsWith(query)).toList();
    return ListView.builder(
      addAutomaticKeepAlives: false,
      itemBuilder: (context, index) => ListTile(
          onTap: () {
            showResults(context);
            query = suggestion[index];
          },
          leading: Icon(Icons.person),
          title: RichText(
            text: TextSpan(
                text: suggestion[index].substring(0, query.length),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: [
                  TextSpan(
                      text: suggestion[index].substring(query.length),
                      style: TextStyle(color: Colors.grey, fontSize: 18))
                ]),
          )),
      itemCount: suggestion.length,
    );
  }
}
