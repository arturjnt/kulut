import 'package:flutter/material.dart';

class Category {
  final int id;
  final String name;
  final Color color;
  final IconData icon;
  double total;

  Category({
    @required this.id,
    @required this.name,
    @required this.color,
    @required this.icon,
  });

  static Map toMap(Category c) {
    return {
      'id': c.id,
      'name': c.name,
      'color': c.color.toString(),
      'icon': c.icon.toString(),
    };
  }
}

class Categories {
  List<Category> _categories;

  List<Category> get categories {
    _categories = [
      Category(
        id: 1,
        name: 'Groceries',
        color: Colors.green,
        icon: Icons.shopping_cart,
      ),
      Category(
        id: 2,
        name: 'Restaurants',
        color: Colors.red,
        icon: Icons.fastfood,
      ),
      Category(
        id: 3,
        name: 'Pets',
        color: Colors.brown,
        icon: Icons.pets,
      ),
      Category(
        id: 4,
        name: 'Bills',
        color: Colors.blue,
        icon: Icons.attach_money,
      ),
      Category(
        id: 5,
        name: 'Gifts',
        color: Colors.yellow,
        icon: Icons.card_giftcard,
      ),
      Category(
        id: 6,
        name: 'Transportation',
        color: Colors.grey,
        icon: Icons.directions_car_rounded,
      ),
      Category(
        id: 7,
        name: 'Self-development',
        color: Colors.deepPurpleAccent,
        icon: Icons.fitness_center,
      ),
      Category(
        id: 8,
        name: 'Health',
        color: Colors.purple,
        icon: Icons.medical_services_outlined,
      ),
      Category(
        id: 9,
        name: 'Others',
        color: Colors.teal,
        icon: Icons.featured_play_list_outlined,
      ),
    ];

    return _categories;
  }

  Category getCategoryById(int id) {
    return categories.firstWhere((el) => id == el.id);
  }
}
