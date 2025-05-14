import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:teste_flutter/features/tables/stores/tables.store.dart';
import 'package:teste_flutter/features/tables/widgets/table_card.widget.dart';
import 'package:teste_flutter/features/tables/widgets/edit_table_modal.widget.dart';

class TablesList extends StatelessWidget {
  TablesList({super.key});

  final TablesStore tablesStore = GetIt.I<TablesStore>();

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: tablesStore.tables
                  .map(
                    (tableStore) => GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => EditTableModal(tableStore: tableStore),
                        );
                      },
                      child: TableCard(tableStore: tableStore),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
