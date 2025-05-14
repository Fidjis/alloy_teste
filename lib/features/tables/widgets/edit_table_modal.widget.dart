import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:teste_flutter/features/tables/stores/table.store.dart';
import 'package:teste_flutter/features/tables/stores/tables.store.dart';
import 'package:teste_flutter/shared/widgets/modal.widget.dart';
import 'package:teste_flutter/shared/widgets/primary_button.widget.dart';
import 'package:teste_flutter/shared/widgets/secondary_button.widget.dart';
import 'package:teste_flutter/features/customers/entities/customer.entity.dart';
import 'package:teste_flutter/features/customers/widgets/edit_customer_modal.widget.dart';

class EditTableModal extends StatefulWidget {
  final TableStore? tableStore;
  final int? tableIndex;
  const EditTableModal({super.key, this.tableStore, this.tableIndex});

  @override
  State<EditTableModal> createState() => _EditTableModalState();
}

class _EditTableModalState extends State<EditTableModal> {
  late final TextEditingController identificationController;
  late int customersCount;
  final TablesStore tablesStore = GetIt.I<TablesStore>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    identificationController = TextEditingController(text: widget.tableStore?.identification ?? '');
    customersCount = widget.tableStore?.customers.length ?? 0;
  }

  void handleSave() {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }
    final newTable = TableStore(
      identification: identificationController.text,
      customers: List.of(widget.tableStore?.customers ?? []),
    );
    if (widget.tableStore == null || widget.tableIndex == null) {
      tablesStore.addTable(newTable);
    } else {
      tablesStore.updateTable(widget.tableIndex!, newTable);
    }
    Navigator.of(context).pop();
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
          Row(
            children: [
              const Text('Clientes da mesa:'),
            ],
          ),
          const SizedBox(height: 8),
          Column(
            children: List.generate(customersCount, (index) {
              final customer = widget.tableStore?.customers.length != null && index < widget.tableStore!.customers.length
                  ? widget.tableStore!.customers[index]
                  : null;
              return ListTile(
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
                      ),
                    ).then((result) {
                      if (result is CustomerEntity) {
                        setState(() {
                          if (widget.tableStore != null) {
                            if (index < widget.tableStore!.customers.length) {
                              widget.tableStore!.customers[index] = result;
                            } else {
                              widget.tableStore!.customers.add(result);
                            }
                          }
                        });
                      }
                    });
                  },
                ),
              );
            }),
          ),
        ],
        actions: [
          SecondaryButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(),
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
