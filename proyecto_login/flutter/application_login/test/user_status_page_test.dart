import 'package:application_login/pages/user_status/user_status_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'user status page lists statuses and validates required fields in dialog',
    (WidgetTester tester) async {
      String? createdName;
      String? createdDescription;

      Future<Map<String, dynamic>> loadStatuses() async {
        return <String, dynamic>{
          'success': true,
          'data': <Map<String, dynamic>>[
            <String, dynamic>{
              'User_status_id': 1,
              'User_status_name': 'Active',
              'User_status_description': 'Active',
              'create_at': '2024-05-18 00:44:01',
              'update_at': null,
            },
          ],
        };
      }

      Future<Map<String, dynamic>> createStatus(
        String name,
        String description,
      ) async {
        createdName = name;
        createdDescription = description;

        return <String, dynamic>{
          'success': true,
          'message': 'Nuevo estado de usuario registrado',
        };
      }

      await tester.pumpWidget(
        MaterialApp(
          home: UserStatusPage(
            loadStatuses: loadStatuses,
            createStatus: createStatus,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Estados de Usuario'), findsOneWidget);
      expect(find.text('Active'), findsWidgets);
      expect(find.byTooltip('Crear nuevo estado'), findsOneWidget);

      await tester.tap(find.byTooltip('Crear nuevo estado'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();

      expect(find.text('El nombre es obligatorio'), findsOneWidget);
      expect(find.text('La descripcion es obligatoria'), findsOneWidget);

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nombre del estado *'),
        'Blocked',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Descripcion *'),
        'This is Blocked',
      );

      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();

      expect(createdName, 'Blocked');
      expect(createdDescription, 'This is Blocked');
      expect(find.text('Nuevo estado de usuario registrado'), findsOneWidget);
    },
  );
}
