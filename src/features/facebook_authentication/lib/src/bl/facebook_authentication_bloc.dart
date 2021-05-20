import 'dart:async';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:logger/logger.dart';

import 'package:facebook_authentication/src/bl/models/facebook_user.dart';

class FacebookAuthenticationBloc {
  final StreamSink<String> errorSink;

  FacebookAuthenticationBloc({
    required this.errorSink,
  });

  var _logger = Logger(
    printer: PrettyPrinter(),
  );

  final BehaviorSubject<FacebookUser?> _userController = BehaviorSubject();

  Stream<FacebookUser?> get user => _userController.stream;

  String get providerId => "facebook.com";

  void loadUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.providerData.last.providerId == providerId) {
        _userController.add(FacebookUser.fromLogin(user));
      }
    } catch (err) {
      errorSink.add(err.toString());
    }
  }

  Future<void> login() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.cancelled ||
          result.status == LoginStatus.failed) {
        return;
      }

      _userController.add(null);

      final facebookAuthCredential =
          FacebookAuthProvider.credential(result.accessToken!.token);

      User? user = (await FirebaseAuth.instance
              .signInWithCredential(facebookAuthCredential))
          .user;

      _logger.d('Signed in Facebook user');
      _logger.d(user);

      _userController.add(FacebookUser.fromLogin(user!));
    } catch (err) {
      errorSink.add(err.toString());
      _userController.add(FacebookUser.empty());
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await FacebookAuth.instance.logOut();

    _userController.add(FacebookUser.empty());
  }

  void dispose() {
    _userController.close();
  }
}
