import 'package:flutter/material.dart';

class Category {
  final int id;
  final String name;
  final Color color;
  final Icon icon;

  Category({
    @required this.id,
    @required this.name,
    @required this.color,
    @required this.icon,
  });
}

class Categories {
  List<Category> _categories;

  List<Category> get categories {
    _categories = [
      Category(
        id: 1,
        name: 'Groceries',
        color: Colors.green,
        icon: Icon(Icons.shopping_cart),
      ),
      Category(
        id: 2,
        name: 'Restaurants',
        color: Colors.red,
        icon: Icon(Icons.fastfood),
      ),
      Category(
        id: 3,
        name: 'Pets',
        color: Colors.brown,
        icon: Icon(Icons.pets),
      ),
      Category(
        id: 4,
        name: 'Bills',
        color: Colors.blue,
        icon: Icon(Icons.attach_money),
      ),
      Category(
        id: 5,
        name: 'Gifts',
        color: Colors.yellow,
        icon: Icon(Icons.card_giftcard),
      ),
      Category(
        id: 6,
        name: 'Transportation',
        color: Colors.grey,
        icon: Icon(Icons.directions_car_rounded),
      ),
      Category(
        id: 7,
        name: 'Self-development',
        color: Colors.deepPurpleAccent,
        icon: Icon(Icons.fitness_center),
      ),
      Category(
        id: 8,
        name: 'Health',
        color: Colors.purple,
        icon: Icon(Icons.medical_services_outlined),
      ),
      Category(
        id: 9,
        name: 'Others',
        color: Colors.black26,
        icon: Icon(Icons.featured_play_list_outlined),
      ),
    ];

    return [..._categories];
  }

  Category getCategoryById(int id) {
    return _categories.firstWhere((el) => id == el.id);
  }
}
