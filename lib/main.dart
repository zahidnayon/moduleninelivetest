import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Recipe {
  final String title;
  final String description;
  final List<String> ingredients;

  Recipe({
    required this.title,
    required this.description,
    required this.ingredients,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      title: json['title'],
      description: json['description'],
      ingredients: List<String>.from(json['ingredients']),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RecipeListScreen(),
    );
  }
}

class RecipeListScreen extends StatefulWidget {
  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  late List<Recipe> recipes;

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    final response = await http.get(Uri.parse('https://api.jsonbin.io/v3/b/64ac3e538e4aa6225ebc1fbf'));
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final List<dynamic> jsonRecipes = jsonBody['record']['recipes'];
      recipes = jsonRecipes.map((json) => Recipe.fromJson(json)).toList();
      setState(() {});
    } else {
      throw Exception('Failed to fetch recipes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return ListTile(
            title: Text(recipe.title),
            subtitle: Text(recipe.description),
            onTap: () {
              // Handle recipe selection
            },
          );
        },
      ),
    );
  }
}
