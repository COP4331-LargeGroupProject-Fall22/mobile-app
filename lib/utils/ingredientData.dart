class IngredientData {

  int ID;
  String name;
  String category;
  List<String> units;
  List<Nutrient> nutrients;
  int expirationDate;
  String imageUrl;

  IngredientData(this.ID, this.name, this.category, this.units, this.nutrients, this.expirationDate, this.imageUrl);

  factory IngredientData.create() {
    IngredientData origin = IngredientData(0, '', '', [], [], 0, '');
    return origin;
  }

  IngredientData toIngredient(Map<String, dynamic> json) {
    this.ID = json['id'];
    this.name = json['name'];
    this.category = json.containsKey('category') ? json['category'] : '';
    this.imageUrl = json.containsKey('image') ? (json['image'].containsKey('srcUrl') ? json['image']['srcUrl'] : '') : '';
    this.units = json.containsKey('quantityUnits') ? insertUnits(json) : [];
    this.nutrients = json.containsKey('nutrients') ? Nutrient.create().toNutrient(json) : [];
    this.expirationDate = json.containsKey('quantityUnits') ? json['expirationDate'] : 0;
    return this;
  }

  List<String> insertUnits(Map<String, dynamic> json) {
    List<String> units = [];
    for (var unit in json['quantityUnits']) {
      units.add(unit);
    }
    return units;
  }

  void addInformationToIngredient(Map<String, dynamic> json) {
    this.units = insertUnits(json);
    this.nutrients = Nutrient.create().toNutrient(json);
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

  @override
  String toString() {
    String toString = '';
    if (this.name.isNotEmpty) {
      toString += 'Name: ${this.name}';
    }
    if (this.ID != 0) {
      toString += '\nID: ${this.ID}';
    }
    if (this.category.isNotEmpty) {
      toString += '\nCategories: ${this.category}';
    }
    return toString;
  }
}

class Nutrient{

  String name;
  Unit unit;
  num percentOfDaily;

  Nutrient(this.name, this.unit, this.percentOfDaily);

  factory Nutrient.create() {
    Nutrient origin = Nutrient('', Unit.create(), 0);
    return origin;
  }

  List<Nutrient> toNutrient(Map<String, dynamic> json) {
    List<Nutrient> nutrient = [];
    for (var nutrients in json['nutrients']) {
      nutrient.add(Nutrient(nutrients['name'], Unit(nutrients['unit']['unit'], nutrients['unit']['value']), nutrients['percentOfDaily']));
    }
    return nutrient;
  }

  @override
  String toString() {
    return '${this.name}: ${this.unit.toString()}; Percent of daily value: ${this.percentOfDaily}\n';
  }
}

class Unit{
  String unit;
  num value;

  Unit(this.unit, this.value);

  factory Unit.create() {
    Unit origin = Unit('', 0);
    return origin;
  }

  String toString() {
    return '${this.value} ${this.unit}';
  }
}
