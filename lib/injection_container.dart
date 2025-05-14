// coverage:ignore-start

// service locator
import 'package:get_it/get_it.dart';
import 'package:teste_flutter/features/customers/stores/customers.store.dart';

final sl = GetIt.I;

void slStores() {
  sl.registerLazySingleton<CustomersStore>(() => CustomersStore());
}

void init() {
  slStores();
}
