abstract class StorageService {
  Future<void> saveEmail(String email);
  Future<String?> getEmail();

  Future<void> saveUserId(String userId);
  Future<String?> getUserId();

  Future<void> savePassword(String password);
  Future<String?> getPassword();

  Future<void> clear();
}