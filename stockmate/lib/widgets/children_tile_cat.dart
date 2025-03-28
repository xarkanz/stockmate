import 'package:stockmate/theme.dart';
import 'package:stockmate/widgets/categories_tile.dart';

class TileFoodAndBeverages extends CategoriesTile {
  TileFoodAndBeverages({super.key})
    : super(color_cat: food_and_baverages, text_cat: "Food and Beverages");
}

class TileMedicine extends CategoriesTile {
  TileMedicine({super.key}) : super(color_cat: medicine, text_cat: "Medicine");
}

class TileHealth extends CategoriesTile {
  TileHealth({super.key}) : super(color_cat: health, text_cat: "Health");
}

class TileStationary extends CategoriesTile {
  TileStationary({super.key})
    : super(color_cat: stationary, text_cat: "Stationary");
}

class TileElectronics extends CategoriesTile {
  TileElectronics({super.key})
    : super(color_cat: electronics, text_cat: "Electronics");
}

class TileOthers extends CategoriesTile {
  TileOthers({super.key}) : super(color_cat: others, text_cat: "Others");
}
