import '../../domain/models/user.dart';

abstract class UserRepository {
  Future<User> getCurrentUser();
  Future<void> updateUser(User user);
}

class UserRepositoryImpl implements UserRepository {
  // ສາມາດເພີ່ມ API client ຫຼື local storage ພາຍຫຼັງ
  
  @override
  Future<User> getCurrentUser() async {
    // ຈຳລອງຂໍ້ມູນຜູ້ໃຊ້ (Mock data)
    // ໃນອະນາຄົດຈະດຶງຂໍ້ມູນຈາກ API ຫຼື local storage
    return User(
      id: '1',
      name: 'ທ້າວ ສຸດສະເຫຼີມ ສີສະຫວັດ',
      phoneNumber: '+855 20 98763987',
      stars: 142,
      profileImageUrl: 'assets/profile.png',
    );
  }

  @override
  Future<void> updateUser(User user) async {
    // ໃນອະນາຄົດຈະບັນທຶກຂໍ້ມູນໃຫມ່ຜ່ານ API ຫຼື local storage
    print('ອັບເດດຂໍ້ມູນຜູ້ໃຊ້: ${user.name}');
  }
}