class FavoriteCity {
  final int? id;
  final String cityName;
  final String country;
  final double lat;
  final double lon;
  final DateTime savedAt;

  FavoriteCity({
    this.id,
    required this.cityName,
    required this.country,
    required this.lat,
    required this.lon,
    required this.savedAt,
  });

  /// Convert DB row → Model
  factory FavoriteCity.fromMap(Map<String, dynamic> map) {
    return FavoriteCity(
      id: map['id'],
      cityName: map['cityName'],
      country: map['country'],
      lat: map['lat'],
      lon: map['lon'],
      savedAt: DateTime.fromMillisecondsSinceEpoch(map['savedAt']),
    );
  }

  /// Convert Model → DB row
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cityName': cityName,
      'country': country,
      'lat': lat,
      'lon': lon,
      'savedAt': savedAt.millisecondsSinceEpoch,
    };
  }
}
