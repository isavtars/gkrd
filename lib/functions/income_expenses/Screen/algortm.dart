void bubbleSortByIncome(List<dynamic> dataList) {
  int n = dataList.length;
  for (int i = 0; i < n - 1; i++) {
    for (int j = 0; j < n - i - 1; j++) {
      if (dataList[j]['transtype'] == 'income' &&
          dataList[j]['amount'] > dataList[j + 1]['amount']) {
        var temp = dataList[j];
        dataList[j] = dataList[j + 1];
        dataList[j + 1] = temp;
      }
    }
  }
}
