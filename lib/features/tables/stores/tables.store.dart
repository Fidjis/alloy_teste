import 'package:mobx/mobx.dart';
import 'table.store.dart';

part 'tables.store.g.dart';

class TablesStore = _TablesStoreBase with _$TablesStore;

abstract class _TablesStoreBase with Store {
  @observable
  ObservableList<TableStore> tables = ObservableList<TableStore>();

  @computed
  int get tablesCount => tables.length;

  @action
  void addTable(TableStore table) {
    tables.add(table);
  }

  @action
  void removeTable(TableStore table) {
    tables.remove(table);
  }
}
