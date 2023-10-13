class GoodsItem {
  final String name;
  final double price;
  final String quantity;
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

// Binary search function
int binarySearch(List<GoodsItem> items, String name) {
  int left = 0;
  int right = items.length - 1;
  while (left <= right) {
    int mid = left + (right - left) ~/ 2;
    int comparison = items[mid].name.compareTo(name);
    if (comparison == 0) {
      // Found the item with the matching name
      return mid;
    } else if (comparison < 0) {
      left = mid + 1;
    } else {
      right = mid - 1;
    }
  }
  // Item with the given name not found
  return -1;
}

void bubbleSortByName(List<GoodsItem> list, {bool ascending = true}) {
  int n = list.length;
  for (int i = 0; i < n - 1; i++) {
    for (int j = 0; j < n - i - 1; j++) {
      if (ascending) {
        if (list[j].name.compareTo(list[j + 1].name) > 0) {
          GoodsItem temp = list[j];
          list[j] = list[j + 1];
          list[j + 1] = temp;
        }
      } else {
        if (list[j].name.compareTo(list[j + 1].name) < 0) {
          GoodsItem temp = list[j];
          list[j] = list[j + 1];
          list[j + 1] = temp;
        }
      }
    }
  }
}

void bubbleSortByPrice(List<GoodsItem> list, {bool ascending = true}) {
  int n = list.length;
  for (int i = 0; i < n - 1; i++) {
    for (int j = 0; j < n - i - 1; j++) {
      if (ascending) {
        if (list[j].price > list[j + 1].price) {
          GoodsItem temp = list[j];
          list[j] = list[j + 1];
          list[j + 1] = temp;
        }
      } else {
        if (list[j].price < list[j + 1].price) {
          GoodsItem temp = list[j];
          list[j] = list[j + 1];
          list[j + 1] = temp;
        }
      }
    }
  }
}
