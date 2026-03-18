import 'package:flutter/material.dart';

import '../../services/api_service.dart';

typedef LoadUserStatuses = Future<Map<String, dynamic>> Function();
typedef CreateUserStatus = Future<Map<String, dynamic>> Function(
  String name,
  String description,
);

class UserStatusPage extends StatefulWidget {
  const UserStatusPage({
    super.key,
    this.loadStatuses,
    this.createStatus,
    this.onLogout,
  });

  final LoadUserStatuses? loadStatuses;
  final CreateUserStatus? createStatus;
  final VoidCallback? onLogout;

  @override
  State<UserStatusPage> createState() => _UserStatusPageState();
}

class _UserStatusPageState extends State<UserStatusPage> {
  final List<Map<String, dynamic>> _statuses = <Map<String, dynamic>>[];
  bool _isLoading = true;
  String? _errorMessage;

  LoadUserStatuses get _loadStatusesCallback =>
      widget.loadStatuses ?? (() => ApiService.fetchUserStatuses());

  CreateUserStatus get _createStatusCallback =>
      widget.createStatus ??
      ((String name, String description) =>
          ApiService.createUserStatus(name, description));

  @override
  void initState() {
    super.initState();
    _loadStatuses();
  }

  Future<void> _loadStatuses({bool showLoader = true}) async {
    if (showLoader) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    final Map<String, dynamic> response = await _loadStatusesCallback();

    if (!mounted) {
      return;
    }

    if (response['success'] == true) {
      final List<Map<String, dynamic>> items =
          (response['data'] as List<dynamic>? ?? <dynamic>[])
              .whereType<Map<String, dynamic>>()
              .toList();

      setState(() {
        _statuses
          ..clear()
          ..addAll(items);
        _isLoading = false;
        _errorMessage = null;
      });
      return;
    }

    setState(() {
      _isLoading = false;
      _errorMessage =
          response['message'] as String? ??
          'No fue posible consultar los estados';
    });
  }

  Future<void> _openCreateDialog() async {
    final Map<String, String>? newStatus = await showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) => const _CreateUserStatusDialog(),
    );

    if (newStatus == null) {
      return;
    }

    final Map<String, dynamic> response = await _createStatusCallback(
      newStatus['name'] ?? '',
      newStatus['description'] ?? '',
    );

    if (!mounted) {
      return;
    }

    final bool isSuccess = response['success'] == true;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          response['message'] as String? ??
              (isSuccess
                  ? 'Nuevo estado de usuario registrado'
                  : 'No fue posible registrar el estado'),
        ),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );

    if (isSuccess) {
      await _loadStatuses(showLoader: false);
    }
  }

  void _logout() {
    ApiService.clearSession();

    if (widget.onLogout != null) {
      widget.onLogout!();
      return;
    }

    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estados de Usuario'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Actualizar',
            onPressed: () => _loadStatuses(),
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Crear nuevo estado',
            onPressed: _openCreateDialog,
            icon: const Icon(Icons.add),
          ),
          IconButton(
            tooltip: 'Cerrar sesion',
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _loadStatuses(),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadStatuses(showLoader: false),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          const _StatusHeaderCard(),
          const SizedBox(height: 16),
          if (_statuses.isEmpty)
            const _EmptyStatusCard()
          else
            ..._statuses.map(_buildStatusCard),
        ],
      ),
    );
  }

  Widget _buildStatusCard(Map<String, dynamic> status) {
    final String name = _readString(
      status,
      'User_status_name',
      fallback: 'Sin nombre',
    );
    final String description = _readString(
      status,
      'User_status_description',
      fallback: 'Sin descripcion',
    );
    final String statusId = _readString(
      status,
      'User_status_id',
      fallback: '-',
    );
    final String createdAt = _readString(status, 'create_at', fallback: '-');
    final String updatedAt = _readString(status, 'update_at', fallback: '-');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Text(statusId),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(description),
              const SizedBox(height: 8),
              Text('Creado: $createdAt'),
              Text('Actualizado: $updatedAt'),
            ],
          ),
        ),
      ),
    );
  }

  String _readString(
    Map<String, dynamic> source,
    String key, {
    required String fallback,
  }) {
    final dynamic value = source[key];
    if (value == null) {
      return fallback;
    }

    final String text = value.toString().trim();
    return text.isEmpty ? fallback : text;
  }
}

class _StatusHeaderCard extends StatelessWidget {
  const _StatusHeaderCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            Text(
              'Panel de estados de usuario',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Consulta los estados registrados y usa el boton superior derecho para crear uno nuevo.',
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyStatusCard extends StatelessWidget {
  const _EmptyStatusCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: const <Widget>[
            Icon(Icons.playlist_add_check_circle_outlined, size: 48),
            SizedBox(height: 12),
            Text(
              'No hay estados registrados todavia.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateUserStatusDialog extends StatefulWidget {
  const _CreateUserStatusDialog();

  @override
  State<_CreateUserStatusDialog> createState() => _CreateUserStatusDialogState();
}

class _CreateUserStatusDialogState extends State<_CreateUserStatusDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    Navigator.of(context).pop(<String, String>{
      'name': _nameController.text.trim(),
      'description': _descriptionController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Crear nuevo estado'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre del estado *',
                hintText: 'Ejemplo: Active',
              ),
              validator: (String? value) {
                final String text = value?.trim() ?? '';
                if (text.isEmpty) {
                  return 'El nombre es obligatorio';
                }

                if (text.length < 3) {
                  return 'El nombre debe tener al menos 3 caracteres';
                }

                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Descripcion *',
                hintText: 'Describe el nuevo estado',
              ),
              validator: (String? value) {
                final String text = value?.trim() ?? '';
                if (text.isEmpty) {
                  return 'La descripcion es obligatoria';
                }

                if (text.length < 3) {
                  return 'La descripcion debe tener al menos 3 caracteres';
                }

                return null;
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
