class Meal {
  final String idMeal;
  final String strMeal;
  final String? strDrinkAlternate;
  final String strCategory;
  final String strArea;
  final String strInstructions;
  final String strMealThumb;
  final String? strTags;
  final String? strYoutube;
  final List<String?> strIngredients;
  final List<String?> strMeasures;

  Meal({
    required this.idMeal,
    required this.strMeal,
    this.strDrinkAlternate,
    required this.strCategory,
    required this.strArea,
    required this.strInstructions,
    required this.strMealThumb,
    this.strTags,
    this.strYoutube,
    required this.strIngredients,
    required this.strMeasures,
  });

  // Phương thức fromJson truyền thống
  factory Meal.fromJson(Map<String, dynamic> json) {
    try {
      List<String?> ingredients = [];
      List<String?> measures = [];

      // Trích xuất các ingredient và measure từ JSON
      for (int i = 1; i <= 20; i++) {
        ingredients.add(json['strIngredient$i']);
        measures.add(json['strMeasure$i']);
      }

      // Trả về đối tượng Meal
      return Meal(
        idMeal: json['idMeal'] ?? '',
        strMeal: json['strMeal'] ?? '',
        strDrinkAlternate: json['strDrinkAlternate'],
        strCategory: json['strCategory'] ?? '',
        strArea: json['strArea'] ?? '',
        strInstructions: json['strInstructions'] ?? '',
        strMealThumb: json['strMealThumb'] ?? '',
        strTags: json['strTags'],
        strYoutube: json['strYoutube'],
        strIngredients: ingredients,
        strMeasures: measures,
      );
    } catch (e) {
      print("Lỗi khi phân tích JSON: $e");
      throw FormatException('Invalid JSON format for Meal object.');
    }
  }
}
