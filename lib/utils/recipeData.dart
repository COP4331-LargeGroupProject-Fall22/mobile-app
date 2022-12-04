import 'package:smart_chef/utils/ingredientData.dart';

class RecipeData {

  int ID;
  String name;
  List<IngredientData> ingredients;
  String imageUrl;
  List<String> cuisines;
  List<String> diets;
  List<String> types;
  List<Instruction> instructions;
  int servings;
  int timeToCook;
  int timeToPrepare;

  

  RecipeData(this.ID, this.name, this.ingredients, this.imageUrl, this.cuisines, this.diets, this.instructions, this.servings, this.timeToCook, this.timeToPrepare, this.types);

  factory RecipeData.create() {
    RecipeData origin = RecipeData(0, '', [], '', [], [], [], 0, 0, 0, []);
    return origin;
  }

  RecipeData putRecipe(Map<String, dynamic> json) {
    this.ID = json['id'];
    this.name = json['name'];
    for (var ingred in json['ingredients']) {
      this.ingredients.add(IngredientData.create().toRecipeIngredient(ingred));
    }
    // print(ingredients);
    // this.ingredients = toIngredients(json);
    this.imageUrl = json.containsKey('image') ? (json['image'].containsKey('srcUrl') ? json['image']['srcUrl'] : '') : '';
    this.cuisines = json.containsKey('cuisines') ? createCuisineList(json) : [];
    this.diets = json.containsKey('diets') ? createDietsList(json) : [];
    this.instructions = json.containsKey('instructionSteps') ? Instruction.create().toInstruction(json['instructionSteps']) : [];
    this.servings = json.containsKey('servings') ? json['servings'] : 0;
    this.timeToCook = json.containsKey('cookingTimeInMinutes') ? json['cookingTimeInMinutes'] : 0;
    this.timeToPrepare = json.containsKey('preparationTimeInMinutes') ? json['preparationTimeInMinutes'] : 0;
    this.types = json.containsKey('mealTypes') ? createMealTypesList(json) : [];
    return this;
  }


  List<IngredientData> toIngredients(Map<String, dynamic> json) {
    List<IngredientData> ingredients = [];
    for (var ingred in json['ingredients']) {
      ingredients.add(IngredientData.create().toRecipeIngredient(ingred));
    }
    return ingredients;
  }

  List<String> createCuisineList(Map<String, dynamic> json) {
    List<String> cuisines = [];
    for (var cuisine in json['cuisines']) {
      cuisines.add(cuisine);
    }
    return cuisines;
  }

  List<String> createMealTypesList(Map<String, dynamic> json) {
    List<String> types = [];
    for (var type in json['mealTypes']) {
      types.add(type);
    }
    return types;
  }

  List<String> createDietsList(Map<String, dynamic> json) {
    List<String> diets = [];
    for (var diet in json['diets']) {
      diets.add(diet);
    }
    return diets;
  }

  Map<String,dynamic> toJson() => {
    'id': this.ID,
    'name': this.name,
    'ingredients': this.ingredients,
    'image': {'srcUrl': this.imageUrl},
  };

  void clear() {
    this.ID = 0;
    this.name = '';
    this.ingredients = [];
    this.imageUrl = '';
    this.cuisines = [];
    this.diets = [];
    this.instructions = [];
    this.servings = 0;
    this.timeToCook = 0;
    this.timeToPrepare = 0;
    this.types = [];
  }
}

class Instruction{

  String instruction;
  List<IngredientData> ingredientsInStep;

  Instruction(this.instruction, this.ingredientsInStep);

  factory Instruction.create() {
    Instruction origin = Instruction('', []);
    return origin;
  }

  List<Instruction> toInstruction(List<dynamic> json) {
    List<Instruction> instruction = [];
    for (var index in json) {
      instruction.add(Instruction(index['instructions'], toIngredientList(index['ingredients'])));
    }
    return instruction;
  }

  List<IngredientData> toIngredientList(List<dynamic> list) {
    List<IngredientData> ingreds = [];
    for (var ingred in list) {
      ingreds.add(IngredientData.create().toIngredient(ingred));
    }
    return ingreds;
  }
}
