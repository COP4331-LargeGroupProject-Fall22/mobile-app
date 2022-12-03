import 'package:smart_chef/utils/ingredientData.dart';

class RecipeData {

  int ID;
  String name;
  List<IngredientData> ingredients;
  String imageUrl;
  List<String> cuisines;
  List<String> diets;
  List<Instruction> instructions;
  int servings;
  int timeToCook;
  int timeToPrepare;
  String type;
  

  RecipeData(this.ID, this.name, this.ingredients, this.imageUrl, this.cuisines, this.diets, this.instructions, this.servings, this.timeToCook, this.timeToPrepare, this.type);

  factory RecipeData.create() {
    RecipeData origin = RecipeData(0, '', [], '', [], [], [], 0, 0, 0, '');
    return origin;
  }

  RecipeData putRecipe(Map<String, dynamic> json) {
    this.ID = json['id'];
    this.name = json['name'];
    this.ingredients = json.containsKey('ingredients') ? toIngredients(json) : [];
    this.imageUrl = json.containsKey('image') ? (json['image'].containsKey('srcUrl') ? json['image']['srcUrl'] : '') : '';
    this.cuisines = json.containsKey('cuisines') ? createCuisineList(json) : [];
    this.diets = json.containsKey('diets') ? createDietsList(json) : [];
    this.instructions = json.containsKey('instructionSteps') ? Instruction.create().toInstruction(json['instructionSteps']) : [];
    this.servings = json['servings'];
    this.timeToCook = json['cookingTimeInMinutes'];
    this.timeToPrepare = json['preparationTimeInMinutes'];
    this.type = json.containsKey('type') ? json['type'] : '';
    return this;
  }


  List<IngredientData> toIngredients(Map<String, dynamic> json) {
    List<IngredientData> ingredients = [];
    for (var ingred in json['ingredients']) {
      ingredients.add(IngredientData.create().toIngredient(ingred));
    }
    return ingredients;
  }

  List<String> createCuisineList(Map<String, dynamic> json) {
    List<String> cuisines = [];
    for (var cuisine in json['ingredients']) {
      cuisines.add(cuisine);
    }
    return cuisines;
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
    this.type = '';
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

  List<Instruction> toInstruction(Map<String, dynamic> json) {
    List<Instruction> instruction = [];
    for (var instruction in json['instructionSteps']) {
      instruction.add(Instruction(instruction['instruction'], toIngredientList(instruction)));
    }
    return instruction;
  }

  List<IngredientData> toIngredientList(Map<String, dynamic> json) {
    List<IngredientData> ingreds = [];
    for (var ingred in json['ingredients']) {
      ingreds.add(IngredientData.create().toIngredient(ingred));
    }
    return ingreds;
  }
}
