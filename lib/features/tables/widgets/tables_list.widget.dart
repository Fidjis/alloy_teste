import 'package:flutter/material.dart';
import 'package:teste_flutter/features/tables/widgets/table_card.widget.dart';

class TablesList extends StatelessWidget {
  TablesList({super.key});

  final tables = List.generate(10, (index) => index).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: tables
                  .map(
                    (e) => const TableCard(),
                  )
                  .toList(),
            ),
          ],
        ));
  }
}
