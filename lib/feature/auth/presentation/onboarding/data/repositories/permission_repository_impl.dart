// data/repositories/permission_repository_impl.dart
import 'package:permission_handler/permission_handler.dart';
import '../../domain/repositories/permission_repository.dart';

class PermissionRepositoryImpl implements PermissionRepository {
  // ການຂໍອະນຸຍາດເຂົ້າເຖິງຕຳແໜ່ງ
  @override
  Future<bool> requestLocationPermission() async {
    try {
      // ขอสิทธิ์การเข้าถึงตำแหน่ง
      final status = await Permission.location.request();

      // ตรวจสอบว่าได้รับสิทธิ์หรือไม่
      return status.isGranted;
    } catch (e) {
      // เกิดข้อผิดพลาดในการขอสิทธิ์
      return false;
    }
  }
}
