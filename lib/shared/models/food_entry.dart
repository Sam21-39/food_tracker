import 'package:objectbox/objectbox.dart';
import 'package:uuid/uuid.dart';

@Entity()
class FoodEntry {
  @Id()
  int id;

  @Unique()
  final String uuid;

  String name;
  String category;
  bool isVegetarian;
  String? imageUrl;
  DateTime timestamp;
  bool isSynced;

  FoodEntry({
    this.id = 0,
    String? uuid,
    required this.name,
    required this.category,
    required this.isVegetarian,
    this.imageUrl,
    DateTime? timestamp,
    this.isSynced = false,
  })  : this.uuid = uuid ?? const Uuid().v4(),
        this.timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'name': name,
        'category': category,
        'isVegetarian': isVegetarian,
        'imageUrl': imageUrl,
        'timestamp': timestamp.toIso8601String(),
        'isSynced': isSynced,
      };

  factory FoodEntry.fromJson(Map<String, dynamic> json) => FoodEntry(
        uuid: json['uuid'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
        isVegetarian: json['isVegetarian'] as bool,
        imageUrl: json['imageUrl'] as String?,
        timestamp: DateTime.parse(json['timestamp'] as String),
        isSynced: json['isSynced'] as bool? ?? false,
      );
}
