class Laundry {
  final int id;
  final String map;
  final String namaLaundry;
  final double rating;
  final int review;
  final String alamat;
  final String status;
  final String? jadwal;
  final String? noTelepon;
  final double? latitude;
  final double? longitude;
  final double? distance;

  Laundry({
    required this.id,
    required this.map,
    required this.namaLaundry,
    required this.rating,
    required this.review,
    required this.alamat,
    required this.status,
    this.jadwal,
    this.noTelepon,
    this.latitude,
    this.longitude,
    required this.distance,
  });

  factory Laundry.fromJson(Map<String, dynamic> json) {
    return Laundry(
      id: json['id_laundry'],
      map: json['map'],
      namaLaundry: json['nama_laundry'],
      rating: double.parse(json['rating']),
      review: json['review'],
      alamat: json['alamat'],
      status: json['status'],
      jadwal: json['jadwal'],
      noTelepon: json['no_telepon'],
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      distance: json['distance'] ,
    );
  }
}
