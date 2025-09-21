/// Sample Item Model for testing purposes
/// Demonstrates data modeling and serialization
class SampleItem {
  final String id;
  final String title;
  final String description;
  final String category;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const SampleItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.isCompleted,
    DateTime? createdAt,
    this.updatedAt,
  }) : createdAt = createdAt ?? const SampleItem._defaultDate();

  static DateTime _defaultDate() => DateTime.now();

  /// Create a copy of this item with some fields updated
  SampleItem copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SampleItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Convert to JSON for serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Create from JSON for deserialization
  factory SampleItem.fromJson(Map<String, dynamic> json) {
    return SampleItem(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      isCompleted: json['isCompleted'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Get display status text
  String get statusText => isCompleted ? 'Completed' : 'Pending';

  /// Get category color for UI
  String get categoryColor {
    switch (category.toLowerCase()) {
      case 'testing':
        return '#FF5722'; // Deep Orange
      case 'development':
        return '#2196F3'; // Blue
      case 'qa':
        return '#4CAF50'; // Green
      case 'design':
        return '#9C27B0'; // Purple
      case 'documentation':
        return '#FF9800'; // Orange
      default:
        return '#607D8B'; // Blue Grey
    }
  }

  /// Check if item is overdue (for demo purposes)
  bool get isOverdue {
    if (isCompleted) return false;
    // Consider items older than 7 days as overdue
    return DateTime.now().difference(createdAt).inDays > 7;
  }

  /// Get priority level based on category and age
  int get priorityLevel {
    int priority = 1; // Default priority
    
    // Increase priority based on category
    switch (category.toLowerCase()) {
      case 'testing':
        priority += 2;
        break;
      case 'development':
        priority += 3;
        break;
      case 'qa':
        priority += 2;
        break;
      default:
        priority += 1;
    }
    
    // Increase priority if overdue
    if (isOverdue) {
      priority += 2;
    }
    
    return priority.clamp(1, 5); // Keep priority between 1-5
  }

  /// Get priority text
  String get priorityText {
    switch (priorityLevel) {
      case 1:
        return 'Low';
      case 2:
        return 'Normal';
      case 3:
        return 'Medium';
      case 4:
        return 'High';
      case 5:
        return 'Critical';
      default:
        return 'Unknown';
    }
  }

  @override
  String toString() {
    return 'SampleItem(id: $id, title: $title, category: $category, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SampleItem &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.category == category &&
        other.isCompleted == isCompleted;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      description,
      category,
      isCompleted,
    );
  }
}
