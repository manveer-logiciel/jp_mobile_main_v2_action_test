import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/templates/form_proposal/more_action.dart';
import 'package:jobprogress/common/models/templates/form_proposal/template.dart';

void main() {
  group('FormProposalParamsModel.getPageTypeAndId', () {
    late FormProposalParamsModel formProposalParams;

    setUp(() {
      formProposalParams = FormProposalParamsModel(
        jobId: 1,
        isEditForm: false,
      );
    });

    group('Edit Mode (forEdit = true)', () {
      group('Worksheet Templates (isForWorksheet = true)', () {
        test('should return worksheet_template_page type with original page id when editing worksheet templates', () {
          // Arrange
          final page = FormProposalTemplateModel(
            id: 123,
            tempSaveId: null,
            isProposalPage: false,
          );

          // Act
          final result = formProposalParams.getPageTypeAndId(page, true, true);

          // Assert
          expect(result.$1, equals('worksheet_template_page'));
          expect(result.$2, equals(123));
        });

        test('should prioritize worksheet_template_page type over temporary save when editing worksheets (ignores tempSaveId)', () {
          // Arrange
          final page = FormProposalTemplateModel(
            id: 123,
            tempSaveId: 456,
            isProposalPage: true,
          );

          // Act
          final result = formProposalParams.getPageTypeAndId(page, true, true);

          // Assert
          expect(result.$1, equals('worksheet_template_page'));
          expect(result.$2, equals(123));
        });

        test('should always use worksheet_template_page type for worksheet editing regardless of proposal page status', () {
          // Arrange
          final page = FormProposalTemplateModel(
            id: 789,
            tempSaveId: null,
            isProposalPage: true,
          );

          // Act
          final result = formProposalParams.getPageTypeAndId(page, true, true);

          // Assert
          expect(result.$1, equals('worksheet_template_page'));
          expect(result.$2, equals(789));
        });
      });

      group('Non-Worksheet Templates (isForWorksheet = false)', () {
        test('should return temp_proposal_page type with tempSaveId when editing unsaved draft content', () {
          // Arrange
          final page = FormProposalTemplateModel(
            id: 123,
            tempSaveId: 456,
            isProposalPage: false,
          );

          // Act
          final result = formProposalParams.getPageTypeAndId(page, true, false);

          // Assert
          expect(result.$1, equals('temp_proposal_page'));
          expect(result.$2, equals(456));
        });

        test('should prioritize temp_proposal_page type over proposal status when draft content exists (tempSaveId takes precedence)', () {
          // Arrange
          final page = FormProposalTemplateModel(
            id: 123,
            tempSaveId: 456,
            isProposalPage: true,
          );

          // Act
          final result = formProposalParams.getPageTypeAndId(page, true, false);

          // Assert
          expect(result.$1, equals('temp_proposal_page'));
          expect(result.$2, equals(456));
        });

        test('should return proposal_page type for visited/modified proposal pages in edit mode (SECURITY: requires backend company scoping)', () {
          // Arrange
          final page = FormProposalTemplateModel(
            id: 123,
            tempSaveId: null,
            isProposalPage: true,
          );

          // Act
          final result = formProposalParams.getPageTypeAndId(page, true, false);

          // Assert
          expect(result.$1, equals('proposal_page'));
          expect(result.$2, equals(123));
        });

        test('should return template_page type for unvisited pages in edit mode (SECURITY: safe with company scoping)', () {
          // Arrange
          final page = FormProposalTemplateModel(
            id: 123,
            tempSaveId: null,
            isProposalPage: false,
          );

          // Act
          final result = formProposalParams.getPageTypeAndId(page, true, false);

          // Assert
          expect(result.$1, equals('template_page'));
          expect(result.$2, equals(123));
        });

        test('should default to template_page type when proposal page status is undefined (safe fallback)', () {
          // Arrange
          final page = FormProposalTemplateModel(
            id: 123,
            tempSaveId: null,
            // isProposalPage defaults to false in constructor
          );

          // Act
          final result = formProposalParams.getPageTypeAndId(page, true, false);

          // Assert
          expect(result.$1, equals('template_page'));
          expect(result.$2, equals(123));
        });
      });
    });

    group('Create Mode (forEdit = false)', () {
      test('should return temp_proposal_page type with tempSaveId when creating proposals with unsaved draft content', () {
        // Arrange
        final page = FormProposalTemplateModel(
          id: 123,
          tempSaveId: 456,
          isProposalPage: false,
        );

        // Act
        final result = formProposalParams.getPageTypeAndId(page, false, false);

        // Assert
        expect(result.$1, equals('temp_proposal_page'));
        expect(result.$2, equals(456));
      });

      test('should prioritize temp_proposal_page type over proposal status in create mode (tempSaveId always wins)', () {
        // Arrange
        final page = FormProposalTemplateModel(
          id: 123,
          tempSaveId: 456,
          isProposalPage: true,
        );

        // Act
        final result = formProposalParams.getPageTypeAndId(page, false, false);

        // Assert
        expect(result.$1, equals('temp_proposal_page'));
        expect(result.$2, equals(456));
      });

      test('should return template_page type when creating proposals from regular templates (SECURITY: safe with company scoping)', () {
        // Arrange
        final page = FormProposalTemplateModel(
          id: 123,
          tempSaveId: null,
          isProposalPage: false,
        );

        // Act
        final result = formProposalParams.getPageTypeAndId(page, false, false);

        // Assert
        expect(result.$1, equals('template_page'));
        expect(result.$2, equals(123));
      });

      test('should always use template_page type in create mode regardless of proposal status (SECURITY: prevents cross-company access)', () {
        // Arrange
        final page = FormProposalTemplateModel(
          id: 123,
          tempSaveId: null,
          isProposalPage: true,
        );

        // Act
        final result = formProposalParams.getPageTypeAndId(page, false, false);

        // Assert
        expect(result.$1, equals('template_page'));
        expect(result.$2, equals(123));
      });

      test('should ignore worksheet parameter in create mode since all new content uses template_page type (consistent behavior)', () {
        // Arrange
        final page = FormProposalTemplateModel(
          id: 123,
          tempSaveId: null,
          isProposalPage: false,
        );

        // Act
        final resultWithWorksheet = formProposalParams.getPageTypeAndId(page, false, true);
        final resultWithoutWorksheet = formProposalParams.getPageTypeAndId(page, false, false);

        // Assert
        expect(resultWithWorksheet.$1, equals('template_page'));
        expect(resultWithWorksheet.$2, equals(123));
        expect(resultWithoutWorksheet.$1, equals('template_page'));
        expect(resultWithoutWorksheet.$2, equals(123));
      });
    });

    group('Edge Cases and Boundary Conditions', () {
      test('should treat tempSaveId value of 0 as valid temporary content (edge case: zero is truthy)', () {
        // Arrange
        final page = FormProposalTemplateModel(
          id: 123,
          tempSaveId: 0,
          isProposalPage: false,
        );

        // Act
        final result = formProposalParams.getPageTypeAndId(page, false, false);

        // Assert
        expect(result.$1, equals('temp_proposal_page'));
        expect(result.$2, equals(0));
      });

      test('should gracefully handle null page id and return null in tuple (defensive programming)', () {
        // Arrange
        final page = FormProposalTemplateModel(
          id: null,
          tempSaveId: null,
          isProposalPage: false,
        );

        // Act
        final result = formProposalParams.getPageTypeAndId(page, false, false);

        // Assert
        expect(result.$1, equals('template_page'));
        expect(result.$2, isNull);
      });

      test('should accept negative tempSaveId as valid temporary content identifier (edge case handling)', () {
        // Arrange
        final page = FormProposalTemplateModel(
          id: 123,
          tempSaveId: -1,
          isProposalPage: false,
        );

        // Act
        final result = formProposalParams.getPageTypeAndId(page, false, false);

        // Assert
        expect(result.$1, equals('temp_proposal_page'));
        expect(result.$2, equals(-1));
      });

      test('should accept negative page id as valid identifier (edge case: negative IDs)', () {
        // Arrange
        final page = FormProposalTemplateModel(
          id: -1,
          tempSaveId: null,
          isProposalPage: false,
        );

        // Act
        final result = formProposalParams.getPageTypeAndId(page, false, false);

        // Assert
        expect(result.$1, equals('template_page'));
        expect(result.$2, equals(-1));
      });
    });

    group('Security Test Cases (LEAP-6389 Related)', () {
      test('SECURITY: should prioritize temp_proposal_page over proposal_page to prevent cross-company contamination (LEAP-6389 fix)', () {
        // Arrange - This test ensures temp pages are handled correctly
        final page = FormProposalTemplateModel(
          id: 123,
          tempSaveId: 456,
          isProposalPage: true,
        );

        // Act
        final result = formProposalParams.getPageTypeAndId(page, true, false);

        // Assert
        expect(result.$1, equals('temp_proposal_page'));
        expect(result.$2, equals(456));
      });

      test('SECURITY: should only use proposal_page type for confirmed visited pages in edit mode (requires backend company scoping)', () {
        // Arrange - This ensures proposal_page type is only used for actual proposal pages
        final page = FormProposalTemplateModel(
          id: 123,
          tempSaveId: null,
          isProposalPage: true,
        );

        // Act
        final result = formProposalParams.getPageTypeAndId(page, true, false);

        // Assert
        expect(result.$1, equals('proposal_page'));
        expect(result.$2, equals(123));
      });

      test('SECURITY: should use safe template_page type for unvisited pages in edit mode (prevents cross-company data access)', () {
        // Arrange - This ensures unvisited pages use safe template_page type
        final page = FormProposalTemplateModel(
          id: 123,
          tempSaveId: null,
          isProposalPage: false,
        );

        // Act
        final result = formProposalParams.getPageTypeAndId(page, true, false);

        // Assert
        expect(result.$1, equals('template_page'));
        expect(result.$2, equals(123));
      });

      test('SECURITY: should enforce template_page type in create mode regardless of page status (maximum security)', () {
        // Arrange - This ensures create mode always uses safe template_page type
        final page = FormProposalTemplateModel(
          id: 123,
          tempSaveId: null,
          isProposalPage: true, // Even if marked as proposal page
        );

        // Act
        final result = formProposalParams.getPageTypeAndId(page, false, false);

        // Assert
        expect(result.$1, equals('template_page'));
        expect(result.$2, equals(123));
      });

      test('SECURITY: should consistently use worksheet_template_page type and original page id (not tempSaveId) for worksheets', () {
        // Arrange - This ensures worksheet templates are handled consistently
        final page = FormProposalTemplateModel(
          id: 123,
          tempSaveId: 456,
          isProposalPage: true,
        );

        // Act
        final result = formProposalParams.getPageTypeAndId(page, true, true);

        // Assert
        expect(result.$1, equals('worksheet_template_page'));
        expect(result.$2, equals(123)); // Should use page.id, not tempSaveId
      });
    });

    group('Type Safety and Return Value Tests', () {
      test('should return properly typed tuple (String, int?) for type safety and API contract compliance', () {
        // Arrange
        final page = FormProposalTemplateModel(
          id: 123,
          tempSaveId: null,
          isProposalPage: false,
        );

        // Act
        final result = formProposalParams.getPageTypeAndId(page, false, false);

        // Assert
        expect(result, isA<(String, int?)>());
        expect(result.$1, isA<String>());
        expect(result.$2, isA<int?>());
      });

      test('should always return valid non-empty page type string (API contract requirement)', () {
        // Arrange
        final page = FormProposalTemplateModel(
          id: 123,
          tempSaveId: null,
          isProposalPage: false,
        );

        // Act
        final result = formProposalParams.getPageTypeAndId(page, false, false);

        // Assert
        expect(result.$1, isNotEmpty);
        expect(result.$1.trim(), isNotEmpty);
      });
    });

    group('Comprehensive Scenario Matrix', () {
      // Test all possible combinations systematically
      final testCases = [
        // [forEdit, isForWorksheet, tempSaveId, isProposalPage, expectedType, expectedIdSource]
        [false, false, null, false, 'template_page', 'id'],
        [false, false, null, true, 'template_page', 'id'],
        [false, false, 123, false, 'temp_proposal_page', 'tempSaveId'],
        [false, false, 123, true, 'temp_proposal_page', 'tempSaveId'],
        [false, true, null, false, 'template_page', 'id'],
        [false, true, null, true, 'template_page', 'id'],
        [false, true, 123, false, 'temp_proposal_page', 'tempSaveId'],
        [false, true, 123, true, 'temp_proposal_page', 'tempSaveId'],
        [true, false, null, false, 'template_page', 'id'],
        [true, false, null, true, 'proposal_page', 'id'],
        [true, false, 123, false, 'temp_proposal_page', 'tempSaveId'],
        [true, false, 123, true, 'temp_proposal_page', 'tempSaveId'],
        [true, true, null, false, 'worksheet_template_page', 'id'],
        [true, true, null, true, 'worksheet_template_page', 'id'],
        [true, true, 123, false, 'worksheet_template_page', 'id'],
        [true, true, 123, true, 'worksheet_template_page', 'id'],
      ];

      for (int i = 0; i < testCases.length; i++) {
        final testCase = testCases[i];
        final forEdit = testCase[0] as bool;
        final isForWorksheet = testCase[1] as bool;
        final tempSaveId = testCase[2] as int?;
        final isProposalPage = testCase[3] as bool;
        final expectedType = testCase[4] as String;
        final expectedIdSource = testCase[5] as String;

        test('comprehensive scenario ${i + 1}: forEdit=$forEdit, worksheet=$isForWorksheet, tempId=$tempSaveId, isProposal=$isProposalPage → expects $expectedType', () {
          // Arrange
          final page = FormProposalTemplateModel(
            id: 456,
            tempSaveId: tempSaveId,
            isProposalPage: isProposalPage,
          );

          // Act
          final result = formProposalParams.getPageTypeAndId(page, forEdit, isForWorksheet);

          // Assert
          expect(result.$1, equals(expectedType));
          if (expectedIdSource == 'id') {
            expect(result.$2, equals(456));
          } else if (expectedIdSource == 'tempSaveId') {
            expect(result.$2, equals(tempSaveId));
          }
        });
      }
    });
  });
}
