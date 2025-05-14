// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';
import 'package:teste_flutter/features/customers/entities/customer.entity.dart';

part 'customers.store.g.dart';

class CustomersStore = _CustomersStoreBase with _$CustomersStore;

abstract class _CustomersStoreBase with Store {
  @observable
  ObservableList<CustomerEntity> customers = ObservableList<CustomerEntity>();

  @action
  void addCustomer(CustomerEntity customer) {
    customers.add(customer);
  }

  @action
  void removeCustomer(CustomerEntity customer) {
    customers.remove(customer);
  }

  @action
  void updateCustomer(CustomerEntity customer) {
    final index = customers.indexWhere((element) => element.id == customer.id);
    customers[index] = customer;
  }
}
