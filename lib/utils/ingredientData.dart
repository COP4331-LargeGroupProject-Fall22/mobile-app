class IngredientData {

  int ID;
  String name;
  String category;
  List<String> units;
  List<Nutrient> nutrients;
  int expirationDate;

  IngredientData(this.ID, this.name, this.category, this.units, this.nutrients, this.expirationDate);

  static final IngredientData origin = IngredientData(0, '', '', [], [], 0);

  factory IngredientData.create() {
    return origin;
  }

  void baseIngredient(Map<String, dynamic> json) {
    this.ID = json['id'];
    this.name = json['name'];
    this.category = json['category'];
  }

  void completeIngredient(Map<String, dynamic> json) {
    this.ID = json['id'];
    this.name = json['name'];
    this.category = json['category'];
    this.units = json['quantityUnits'];
    this.nutrients = json['nutrients'];
  }

  void inventoryIngredient(Map<String, dynamic> json) {
    this.ID = json['id'];
    this.name = json['name'];
    this.category = json['category'];
    this.expirationDate = json['expirationDate'];

  }

  Map<String,dynamic> toJson() => {
    'id': this.ID,
    'name': this.name,
    'category': this.category,
    'nutrients': this.nutrients,
    'quantityUnits': this.units,
  };

  void clear() {
    this.ID = 0;
    this.name = '';
    this.category = '';
    this.nutrients = [];
    this.units = [];
    this.expirationDate = 0;
  }
}

class Nutrient{

  String name;
  Unit unit;
  double percentOfDaily;

  Nutrient(this.name, this.unit, this.percentOfDaily);

  static final Nutrient origin = Nutrient('', Unit.origin, 0);
}

class Unit{
  String unit;
  double value;

  Unit(this.unit, this.value);

  static final Unit origin = Unit('', 0);
}
