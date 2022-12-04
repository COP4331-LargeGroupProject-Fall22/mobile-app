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

  Future<RecipeData> putRecipe(Map<String, dynamic> json) async {
    this.ID = json['id'];
    this.name = json['name'];
    this.ingredients = await toIngredients(json);
    this.imageUrl = json.containsKey('image') ? (json['image'].containsKey('srcUrl') ? json['image']['srcUrl'] : '') : '';
    this.cuisines = json.containsKey('cuisines') ? await createCuisineList(json) : [];
    this.diets = json.containsKey('diets') ? await createDietsList(json) : [];
    this.instructions = json.containsKey('instructionSteps') ? await Instruction.create().toInstruction(json['instructionSteps']) : [];
    this.servings = json.containsKey('servings') ? json['servings'] : 0;
    this.timeToCook = json.containsKey('cookingTimeInMinutes') ? json['cookingTimeInMinutes'] : 0;
    this.timeToPrepare = json.containsKey('preparationTimeInMinutes') ? json['preparationTimeInMinutes'] : 0;
    this.type = json.containsKey('type') ? json['type'] : '';
    return this;
  }


  Future<List<IngredientData>> toIngredients(Map<String, dynamic> json) async {
    List<IngredientData> ingredients = [];
    for (var ingred in json['ingredients']) {
      ingredients.add(await IngredientData.create().toIngredient(ingred));
    }
    return ingredients;
  }

  Future<List<String>> createCuisineList(Map<String, dynamic> json) async {
    List<String> cuisines = [];
    for (var cuisine in json['cuisines']) {
      cuisines.add(cuisine);
    }
    return cuisines;
  }

  Future<List<String>> createDietsList(Map<String, dynamic> json) async {
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

  Future<List<Instruction>> toInstruction(List<dynamic> json) async {
    List<Instruction> instruction = [];
    for (var index in json) {
      //instruction.add(Instruction(json[index]['instruction'], toIngredientList(instruction['ingredients'])));
    }
    return instruction;
  }

  Future<List<IngredientData>> toIngredientList(Map<String, dynamic> json) async {
    List<IngredientData> ingreds = [];
    for (var ingred in json['ingredients']) {
      ingreds.add(await IngredientData.create().toIngredient(ingred));
    }
    return ingreds;
  }
}
