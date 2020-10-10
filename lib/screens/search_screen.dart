import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_skype_app/export_path.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  FirebaseRepository _repository = FirebaseRepository();
  List<SkypeUser> userList;
  String query = "";
  TextEditingController searchController = TextEditingController();
  bool initialLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _repository.getCurrentUser().then((User currentUser) {
      _repository.fetchAllUsers(currentUser).then((List<SkypeUser> list) {
        setState(() {
          userList = list;
          initialLoading = false;
        });
      });
    });
  }

  searchAppBar(BuildContext context) {
    return GradientAppBar(
      gradient: LinearGradient(colors: [
        UniversalVariables.gradientColorStart,
        UniversalVariables.gradientColorEnd
      ]),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20.0),
        child: Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: TextField(
            controller: searchController,
            onChanged: (val) {
              setState(() {
                query = val;
              });
            },
            cursorColor: UniversalVariables.blackColor,
            autofocus: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 35.0,
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  searchController.clear();
                },
              ),
              border: InputBorder.none,
              hintText: "Search",
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35.0,
                color: Color(0x88FFFFFF),
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildSuggestions(String query) {
    final List<SkypeUser> suggestionList = query.isEmpty
        ? []
        : userList.where((SkypeUser user) {
            String _getUsername = user.username.toLowerCase();
            String _query = query.toLowerCase();
            String _getName = user.name.toLowerCase();
            bool matchesUsername = _getUsername.contains(_query);
            bool matchesName = _getName.contains(_query);

            return (matchesName || matchesUsername);
          }).toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: ((context, index) {
        SkypeUser searchedUser = SkypeUser(
          uid: suggestionList[index].uid,
          profilePhoto: suggestionList[index].profilePhoto,
          name: suggestionList[index].name,
          username: suggestionList[index].username,
        );

        return CustomTile(
          mini: false,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(receiver: searchedUser)));
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(searchedUser.profilePhoto),
            backgroundColor: Colors.grey,
          ),
          title: Text(
            searchedUser.username,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            searchedUser.name,
            style: TextStyle(
              color: UniversalVariables.greyColor,
            ),
          ),
        );
      }),
    );
    // : userList.where((SkypeUser user) => (user.username.contains(query) ||
    //     user.name.toLowerCase().contains(query.toLowerCase())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: searchAppBar(context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: initialLoading
            ? Center(child: CircularProgressIndicator())
            : buildSuggestions(query),
      ),
    );
  }
}
