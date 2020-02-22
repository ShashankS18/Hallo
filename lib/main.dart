import 'package:flutter/material.dart';
import 'package:hallo/models/user.dart';
import 'package:hallo/screens/wrapper.dart';
import 'package:hallo/services/auth.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Color(0xFFdf7861),
          accentColor: Color(0xFFecb390),
          cardColor: Color(0xFFFAFAFA),
          backgroundColor: Color(0xFFe9e1cc),
          canvasColor: Color(0xFFe9e1cc),
          buttonColor: Color(0xFFd45079),
          splashColor: Color(0xFFED553B),
          focusColor: Color(0xFF3CAEA3),
          highlightColor: Color(0xFFF6D55C),
          hintColor: Color(0xFF3CAEA3),
          cursorColor: Color(0xFFFAFAFA),
          errorColor: Color(0xFFB71C1C),
          primaryColorDark: Color(0xFFFAFAFA),
          primaryColorLight: Color(0xFFFAFAFA),
          /*
          subhead - profile headings- subhead
          subtitle - profile data, nav menu items, chat names
          body1 - textfields,chats
          body2-hints
           */
          textTheme: TextTheme(
            headline: TextStyle(
              color: Theme
                  .of(context)
                  .primaryColor,
            ),
            title: TextStyle(color: Theme
                .of(context)
                .highlightColor),
            subhead: TextStyle(
              color: Theme
                  .of(context)
                  .accentColor,
            ),
            body1: TextStyle(
              color: Theme
                  .of(context)
                  .primaryColor,
            ),
            body2: TextStyle(
              color: Theme
                  .of(context)
                  .hintColor,
            ),
            button: TextStyle(color: Theme
                .of(context)
                .highlightColor),
            subtitle: TextStyle(
              color: Theme
                  .of(context)
                  .primaryColor,
            ),
          ),
        ),
        home: Wrapper(),
      ),
    );
  }
}
