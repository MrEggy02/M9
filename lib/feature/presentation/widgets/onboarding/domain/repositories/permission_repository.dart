// domain/repositories/permission_repository.dart
abstract class PermissionRepository {
  // ການຂໍການອະນຸຍາດເຂົ້າເຖິງຕຳແໜ່ງ
  Future<bool> requestLocationPermission();
}
