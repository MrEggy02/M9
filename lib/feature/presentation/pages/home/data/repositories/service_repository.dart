import '../../domain/models/service.dart';

abstract class ServiceRepository {
  Future<List<Service>> getServices();
}

class ServiceRepositoryImpl implements ServiceRepository {
  // ສາມາດເພີ່ມ API client ຫຼື local storage ພາຍຫຼັງ
  
  @override
  Future<List<Service>> getServices() async {
    // ຈຳລອງຂໍ້ມູນບໍລິການ (Mock data)
    // ໃນອະນາຄົດຈະດຶງຂໍ້ມູນຈາກ API ຫຼື local storage
    return [
      Service(
        id: '1',
        name: 'ເຂົ້າຮ່ວມ',
        iconUrl: 'assets/icons/taxi.png',
        description: 'ເຂົ້າຮ່ວມເປັນຄົນຂັບລົດແທັກຊີ່',
      ),
      Service(
        id: '2',
        name: 'ຈອງຕຳແຫນ່ງ',
        iconUrl: 'assets/icons/location.png',
        description: 'ຈອງຕຳແຫນ່ງສຳລັບການເດີນທາງ',
      ),
      Service(
        id: '3',
        name: 'ຈັດສົ່ງສິນຄ້າ',
        iconUrl: 'assets/icons/delivery.png',
        description: 'ບໍລິການຂົນສົ່ງສິນຄ້າ',
      ),
    ];
  }
}