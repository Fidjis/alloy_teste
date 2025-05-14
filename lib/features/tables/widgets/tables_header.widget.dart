import 'package:flutter/material.dart';
import 'package:teste_flutter/features/tables/stores/tables.store.dart';
import 'package:teste_flutter/features/tables/widgets/customers_counter.widget.dart';
import 'package:teste_flutter/shared/widgets/search_input.widget.dart';
import 'package:teste_flutter/utils/extension_methos/material_extensions_methods.dart';
import 'package:teste_flutter/features/tables/widgets/edit_table_modal.widget.dart';
import 'package:get_it/get_it.dart';

class TablesHeader extends StatelessWidget {
  const TablesHeader({super.key});

  void _openCreateTableModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const EditTableModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TablesStore tablesStore = GetIt.I<TablesStore>();
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            Text(
              'Mesas',
              style: context.textTheme.titleLarge,
            ),
            const SizedBox(width: 20),
            SearchInput(
              onChanged: (value) {
                tablesStore.setSearchTerm(value ?? '');
              },
            ),
            const SizedBox(width: 20),
            CustomersCounter(label: tablesStore.tables.fold<int>(0, (sum, t) => sum + t.customers.length).toString()),
            const SizedBox(width: 20),
            FloatingActionButton(
              onPressed: () => _openCreateTableModal(context),
              tooltip: 'Criar nova mesa',
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
