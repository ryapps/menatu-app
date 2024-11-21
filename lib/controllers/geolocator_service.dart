import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';
class GeolocatorService {
  Future<Position> getCurrentLocation() async {
    // Cek apakah layanan lokasi aktif
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Cek izin akses lokasi
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    // Mendapatkan lokasi saat ini
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
   // Mengonversi koordinat menjadi alamat
  Future<String> getAddressFromCoordinates() async {
    try {
      Position position = await getCurrentLocation();
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // Mengambil alamat dari objek Placemark
      Placemark place = placemarks[0];
      String address =
          "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      return address;
    } catch (e) {
      return "Tidak dapat mengambil alamat: $e";
    }
  }
}

