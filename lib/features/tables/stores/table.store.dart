import 'package:mobx/mobx.dart';
import '../../customers/entities/customer.entity.dart';

part 'table.store.g.dart';

class TableStore = _TableStoreBase with _$TableStore;

abstract class _TableStoreBase with Store {
  @observable
  String identification;

  @observable
  ObservableList<CustomerEntity> customers = ObservableList<CustomerEntity>();

  _TableStoreBase({required this.identification, List<CustomerEntity>? customers}) {
    if (customers != null) {
      this.customers.addAll(customers);
    }
  }
}
