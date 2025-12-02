enum ReservationStatus {
  pending,
  confirmed,
  cancelled;

  // Extension to convert enum to String and vice versa
  String toShortString() {
    return toString().split('.').last;
  }

  static ReservationStatus fromString(String status) {
    switch (status) {
      case 'pending':
        return ReservationStatus.pending;
      case 'confirmed':
        return ReservationStatus.confirmed;
      case 'cancelled':
        return ReservationStatus.cancelled;
      default:
        throw ArgumentError('Invalid ReservationStatus: $status');
    }
  }
}

class Restaurant {
  final String id;
  final String name;
  final String image;
  final String address;
  final double rating;
  final int reviews; // Corresponds to reviews_count in DB
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
    required this.reviews,
    required this.cuisine,
    required this.phone,
    required this.hours,
    required this.description,
    required this.lat,
    required this.lng,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      address: json['address'],
      rating: (json['rating'] as num).toDouble(),
      reviews: json['reviews_count'] ?? 0, // Map reviews_count from DB
      cuisine: json['cuisine'],
      phone: json['phone'],
      hours: json['hours'],
      description: json['description'],
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'address': address,
      'rating': rating,
      'reviews_count': reviews, // Map reviews_count to DB
      'cuisine': cuisine,
      'phone': phone,
      'hours': hours,
      'description': description,
      'lat': lat,
      'lng': lng,
    };
  }
}

class Reservation {
  final String id;
  final String restaurantId;
  final String restaurantName; // Denormalized, might come from join or be handled
  final String restaurantImage; // Denormalized
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

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      restaurantId: json['restaurant_id'],
      restaurantName: json['restaurant_name'] ?? 'Unknown Restaurant', // Will need to fetch or join
      restaurantImage: json['restaurant_image'] ?? '', // Will need to fetch or join
      date: json['reservation_date'], // Map to reservation_date from DB
      time: json['reservation_time'], // Map to reservation_time from DB
      guests: json['guests'],
      status: ReservationStatus.fromString(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'id': id, // Supabase handles id on insert
      'restaurant_id': restaurantId,
      // 'restaurant_name': restaurantName, // Denormalized, not sent directly on insert
      // 'restaurant_image': restaurantImage, // Denormalized, not sent directly on insert
      'reservation_date': date, // Map to reservation_date for DB
      'reservation_time': time, // Map to reservation_time for DB
      'guests': guests,
      'status': status.toShortString(),
    };
  }
}

class Review {
  final String id;
  final String restaurantId;
  final String userName;
  final String userAvatar;
  final double rating;
  final String comment;
  final String date; // Corresponds to review_date in DB

  Review({
    required this.id,
    required this.restaurantId,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.comment,
    required this.date,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      restaurantId: json['restaurant_id'],
      userName: json['user_name'],
      userAvatar: json['user_avatar'] ?? '',
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] ?? '',
      date: json['review_date'], // Map to review_date from DB
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'id': id, // Supabase handles id on insert
      'restaurant_id': restaurantId,
      'user_name': userName,
      'user_avatar': userAvatar,
      'rating': rating,
      'comment': comment,
      'review_date': date, // Map to review_date for DB
    };
  }
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
