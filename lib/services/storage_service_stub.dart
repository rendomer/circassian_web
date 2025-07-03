import 'storage_service_base.dart';
//import 'package:cherkess_net/services/storage_service.dart';

class StorageServiceStub implements StorageService {
  @override
  Future<void> saveEmail(String email) async {
    print('Stub: saveEmail $email');
  }

  @override
  Future<String?> getEmail() async {
    print('Stub: getEmail');
    return null;
  }

  @override
  Future<void> saveUserId(String userId) async {
    print('Stub: saveUserId $userId');
  }

  @override
  Future<String?> getUserId() async {
    print('Stub: getUserId');
    return null;
  }

  @override
  Future<void> savePassword(String password) async {
    print('Stub: savePassword');
  }

  @override
  Future<String?> getPassword() async {
    print('Stub: getPassword');
    return null;
  }

  @override
  Future<void> clear() async {
    print('Stub: clear');
  }
}

// Вот это важно:
StorageService getServiceImpl() => StorageServiceStub();
