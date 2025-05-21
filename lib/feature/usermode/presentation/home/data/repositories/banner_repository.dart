import '../../domain/models/banner.dart';

abstract class BannerRepository {
  Future<List<BannerModel>> getBanners();
}

class BannerRepositoryImpl implements BannerRepository {
  // ສາມາດເພີ່ມ API client ຫຼື local storage ພາຍຫຼັງ
  
  @override
  Future<List<BannerModel>> getBanners() async {
    // ຈຳລອງຂໍ້ມູນແບນເນີ້ (Mock data)
    // ໃນອະນາຄົດຈະດຶງຂໍ້ມູນຈາກ API ຫຼື local storage
    return [
      BannerModel(
        id: '1',
        imageUrl: 'assets/banners/taxi_banner.png',
        title: 'MAUDO YOU',
        subtitle: 'MAKETING',
        companyName: 'THE SMI TAXI',
        companyLogoUrl: 'assets/logos/smi_logo.png',
      ),
      BannerModel(
        id: '2',
        imageUrl: 'assets/banners/service_banner.png',
        title: 'ບໍລິການ',
        subtitle: 'M9 SERVICE',
        companyName: 'THE SMI TAXI',
        companyLogoUrl: 'assets/logos/smi_logo.png',
      ),
    ];
  }
}