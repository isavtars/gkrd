class Goods {
  final String name;
  final String prices;
  final String quantity;

  Goods( {required this.name, required this.prices, required this.quantity,});

  @override
  String toString() => name;
}



List<Goods> goodsList = [
      Goods(name: 'Petrol', prices: '160',quantity:"1L"),
      Goods(name: 'Milk', prices: '120',quantity:"1L"),
      Goods(name: 'Diseals', prices: '112',quantity:"1L"),
      Goods(name: 'Gas', prices: '1950',quantity:"1Cylinder"),
      Goods(name: 'Gold', prices: '10000',quantity:"1tola"),
      Goods(name: 'Diseals', prices: '112',quantity:"1L"),


  // Add more countries
];
