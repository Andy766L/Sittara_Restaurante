enum ReservationStatus {
  pending,
  confirmed,
  cancelled,
}

class Restaurant {
  final String id;
  final String name;
  final String image;
  final String address;
  final double rating;
  final String cuisine;
  final String phone;
  final String hours;
  final String description;
  final double lat;
  final double lng;

  Restaurant({
    required this.id,
    required this.name,
    required this.image,
    required this.address,
    required this.rating,
    required this.cuisine,
    required this.phone,
    required this.hours,
    required this.description,
    required this.lat,
    required this.lng,
  });
}

class Reservation {
  final String id;
  final String restaurantId;
  final String restaurantName;
  final String restaurantImage;
  final String date;
  final String time;
  final int guests;
  final ReservationStatus status;

  Reservation({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantImage,
    required this.date,
    required this.time,
    required this.guests,
    required this.status,
  });
}

class Review {
  final String id;
  final String restaurantId;
  final String userName;
  final String userAvatar;
  final double rating;
  final String comment;
  final String date;

  Review({
    required this.id,
    required this.restaurantId,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

class User {
  final String name;
  final String email;
  final String phone;
  final String avatar;

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
  });
}
