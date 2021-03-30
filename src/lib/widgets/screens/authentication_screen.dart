import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:faculty_list/faculty_list.dart' hide TextLocalizer;
import 'package:google_authentication/google_authentication.dart';
import 'package:zhytomyr_polytechnic/bl/firestore_faculty_repository.dart';
import 'package:zhytomyr_polytechnic/bl/services/text_localizer.dart';

class AuthenticationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: MediaQuery.of(context).size.width * 0.7,
                    ),
                    SizedBox(
                      height: 110,
                    ),
                    GoogleSignInButton(
                      authorizationCallback: (user) =>
                          Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => FacultyList(
                            facultyRepository: FirestoreFacultyRepository(),
                            sidebarAction: () {},
                            textLocalizer: TextLocalizer(),
                          ),
                        ),
                      ),
                      userBloc: context.read<AuthenticationBloc>(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
