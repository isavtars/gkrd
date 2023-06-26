class Entry {
  const Entry(this.title, [this.children = const <Entry>[]]);
  final String title;
  final List<Entry> children;
}

// Data to display.
const List<Entry> dataforcash= <Entry>[
  Entry(
    'Amount',
    <Entry>[
      Entry('Cash in hand'),
      Entry('Cash in bank'),
    ],
  ),
];
