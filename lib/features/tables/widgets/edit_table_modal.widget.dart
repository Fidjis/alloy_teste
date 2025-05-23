import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:teste_flutter/features/tables/stores/table.store.dart';
import 'package:teste_flutter/features/tables/stores/tables.store.dart';
import 'package:teste_flutter/shared/widgets/modal.widget.dart';
import 'package:teste_flutter/shared/widgets/primary_button.widget.dart';
import 'package:teste_flutter/shared/widgets/secondary_button.widget.dart';
import 'package:teste_flutter/features/customers/entities/customer.entity.dart';
import 'package:teste_flutter/features/customers/widgets/edit_customer_modal.widget.dart';
import 'package:teste_flutter/features/customers/stores/customers.store.dart';
import 'package:collection/collection.dart';

class EditTableModal extends StatefulWidget {
  final TableStore? tableStore;
  const EditTableModal({super.key, this.tableStore});

  @override
  State<EditTableModal> createState() => _EditTableModalState();
}

class _EditTableModalState extends State<EditTableModal> {
  late final TextEditingController identificationController;
  late int customersCount;
  late List<CustomerEntity> localCustomers;
  late List<int> addedCustomerIds;
  final TablesStore tablesStore = GetIt.I<TablesStore>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String searchTerm = '';

  @override
  void initState() {
    super.initState();
    identificationController = TextEditingController(text: widget.tableStore?.identification ?? '');
    customersCount = widget.tableStore?.customers.length ?? 0;
    localCustomers = List<CustomerEntity>.from(widget.tableStore?.customers ?? []);
    addedCustomerIds = [];
  }

  void handleSave() {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }
    final customers = <CustomerEntity>[];
    for (int i = 0; i < customersCount; i++) {
      if (i < localCustomers.length) {
        customers.add(localCustomers[i]);
      } else {
        customers.add(CustomerEntity(
          id: DateTime.now().millisecondsSinceEpoch + i,
          name: 'Cliente ${i + 1}',
          phone: 'Não informado',
        ));
      }
    }
    final newTable = TableStore(
      id: widget.tableStore?.id ?? DateTime.now().millisecondsSinceEpoch,
      identification: identificationController.text,
      customers: customers,
    );
    if (widget.tableStore == null) {
      tablesStore.addTable(newTable);
    } else {
      tablesStore.updateTable(newTable);
    }
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Modal(
        title: widget.tableStore == null ? 'Nova Mesa' : 'Editar Mesa',
        content: [
          TextFormField(
            controller: identificationController,
            decoration: const InputDecoration(labelText: 'Identificação da mesa'),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'A identificação não pode ser vazia';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Quantidade de pessoas:'),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    if (customersCount > 0) customersCount--;
                  });
                },
              ),
              Text('$customersCount'),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    customersCount++;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Text('Clientes da mesa:'),
            ],
          ),
          const SizedBox(height: 8),
          Column(
            children: List.generate(customersCount, (index) {
              final customer = (index < localCustomers.length) ? localCustomers[index] : null;
              return StatefulBuilder(
                builder: (context, setInnerState) => ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(customer?.name ?? 'Cliente ${index + 1}'),
                  subtitle: Text(customer?.phone ?? 'Não informado'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => EditCustomerModal(
                          customer: customer,
                          onSave: (editedCustomer) {
                            setState(() {
                              if (index < localCustomers.length) {
                                localCustomers[index] = editedCustomer;
                              } else if (index == localCustomers.length) {
                                localCustomers.add(editedCustomer);
                              }
                            });
                            setInnerState(() {});
                          },
                        ),
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ],
        actions: [
          SecondaryButton(
            child: const Text('Cancelar'),
            onPressed: () {
              final customersStore = GetIt.I<CustomersStore>();
              for (final id in addedCustomerIds) {
                final toRemove = customersStore.customers.firstWhereOrNull((c) => c.id == id);
                if (toRemove != null) {
                  customersStore.removeCustomer(toRemove);
                }
              }
              Navigator.of(context).pop();
            },
          ),
          PrimaryButton(
            onPressed: handleSave,
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
