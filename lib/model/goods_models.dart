class GoodsItem {
  final String name;
  final double price;
  final int quantity;
  final String icon;

  GoodsItem(
      {required this.name,
      required this.price,
      required this.quantity,
      required this.icon});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
      'icon': icon,
    };
  }
}

List<GoodsItem> binarySearchByName(
    List<GoodsItem> searchResults, String query) {
  int left = 0;
  int right = searchResults.length - 1;
  List<GoodsItem> results = [];

  while (left <= right) {
    int mid = left + (right - left) ~/ 2;
    int comparisonResult = searchResults[mid].name.compareTo(query);

    if (comparisonResult == 0) {
      results.add(searchResults[mid]); // Target found, add to results
    }

    if (comparisonResult < 0) {
      left = mid + 1;
    } else {
      right = mid - 1;
    }
  }

  return results;
}

// List<GoodsItem> goodsList = [
//   GoodsItem(name: 'Petrol', price: '160', quantity: "1L",),
//   GoodsItem(name: 'Milk', price: '120', quantity: "1L",),
//   GoodsItem(name: 'Diseals', price: '112', quantity: "1L"),
//   GoodsItem(name: 'Gas', price: '1950', quantity: "1Cylinder"),
//   GoodsItem(name: 'Gold', price: '10000', quantity: "1tola"),
//   GoodsItem(name: 'Diseals', price: '112', quantity: "1L"),

//   // Add more countries
// ];
