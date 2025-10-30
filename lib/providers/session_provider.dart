import 'package:flutter/foundation.dart';

/// Provider to track session state, including whether splash screen has been shown
class SessionProvider with ChangeNotifier {
  bool _hasShownSplash = false;

  bool get hasShownSplash => _hasShownSplash;

  void markSplashAsShown() {
    _hasShownSplash = true;
    notifyListeners();
  }
}
