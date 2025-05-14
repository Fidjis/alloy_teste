import 'package:mobx/mobx.dart';
import 'table.store.dart';

part 'tables.store.g.dart';

class TablesStore = _TablesStoreBase with _$TablesStore;

abstract class _TablesStoreBase with Store {
  @observable
  ObservableList<TableStore> tables = ObservableList<TableStore>();

  @observable
  String searchTerm = '';

  @computed
  int get tablesCount => tables.length;

  @computed
  List<TableStore> get filteredTables {
    if (searchTerm.isEmpty) return tables;
    final lower = searchTerm.toLowerCase();
    return tables.where((table) {
      if (table.identification.toLowerCase().contains(lower)) return true;
      for (final customer in table.customers) {
        if (customer.name.toLowerCase().contains(lower) || (customer.phone.toLowerCase().contains(lower))) {
          return true;
        }
      }
      return false;
    }).toList();
  }

  @action
  void addTable(TableStore table) {
    tables.add(table);
  }

  @action
  void removeTable(TableStore table) {
    tables.remove(table);
  }

  @action
  void updateTable(TableStore updatedTable) {
    final index = tables.indexWhere((table) => table.id == updatedTable.id);
    if (index != -1) {
      tables[index] = updatedTable;
    }
  }

  @action
  void setSearchTerm(String value) {
    searchTerm = value;
  }
}
