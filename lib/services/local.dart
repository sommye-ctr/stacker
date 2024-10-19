import 'package:supabase_flutter/supabase_flutter.dart';

class LocalService {
  static bool isUserSignedIn() {
    return Supabase.instance.client.auth.currentUser != null;
  }

  static String getUsername() {
    return Supabase.instance.client.auth.currentUser?.userMetadata?['name'] ??
        "";
  }

  static String getUserId() {
    return Supabase.instance.client.auth.currentUser?.id ?? "";
  }

  static String getUserEmail() {
    return Supabase.instance.client.auth.currentUser?.email ?? "";
  }
}
