import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/services/auth_service.dart';
import '../models/profile.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();
  Profile? profile;
  bool isLoading = false;
  String? error;
  List<Profile> users = [];

  bool get isLoggedIn => _service.currentUser != null;
  String? get role => profile?.role;

  Stream<AuthState> get authChanges => _service.onAuthStateChange;

  Future<void> login(String email, String password) async {
    _setLoading(true);
    error = null;
    try {
      await _service.signIn(email: email, password: password);
      await loadProfile();
    } catch (e) {
      error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadProfile() async {
    final user = _service.currentUser;
    if (user == null) return;
    error = null;
    try {
      profile =
          await _service.fetchOrCreateProfile(user.id, user.email ?? '');
    } catch (e) {
      error = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> loadUsers() async {
    _setLoading(true);
    error = null;
    try {
      users = await _service.fetchProfiles();
    } catch (e) {
      error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> createUser({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session == null) {
        return 'Sesi tidak ditemukan, silakan login ulang';
      }

      final response = await Supabase.instance.client.functions.invoke(
        'create-user',
        body: {'email': email, 'password': password, 'role': role},
        headers: {'Authorization': 'Bearer ${session.accessToken}'},
      );

      final data = response.data as Map<String, dynamic>?;
      if (data != null && data.containsKey('error')) {
        return data['error'].toString();
      }

      await loadUsers();
      return null;
    } on FunctionException catch (e) {
      final body = e.details;
      if (body is Map && body.containsKey('error')) {
        return body['error'].toString();
      }
      return e.toString();
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> updateRole(String userId, String role) async {
    _setLoading(true);
    error = null;
    try {
      await _service.updateRole(userId, role);
      await loadUsers();
    } catch (e) {
      error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> deleteUser(String userId) async {
    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session == null) return 'Sesi tidak ditemukan';

      final response = await Supabase.instance.client.functions.invoke(
        'create-user',
        method: HttpMethod.delete,
        body: {'userId': userId},
        headers: {'Authorization': 'Bearer ${session.accessToken}'},
      );

      final data = response.data as Map<String, dynamic>?;
      if (data != null && data.containsKey('error')) {
        return data['error'].toString();
      }

      await loadUsers();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> logout() async {
    await _service.signOut();
    profile = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
