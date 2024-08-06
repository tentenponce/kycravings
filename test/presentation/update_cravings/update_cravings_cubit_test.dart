import 'dart:ui';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kycravings/data/db/repositories/categories_repository.dart';
import 'package:kycravings/data/db/repositories/cravings_repository.dart';
import 'package:kycravings/domain/models/category_model.dart';
import 'package:kycravings/domain/models/craving_model.dart';
import 'package:kycravings/presentation/shared/utils/debouncer_utils.dart';
import 'package:kycravings/presentation/update_cravings/cubits/update_cravings_cubit.dart';
import 'package:kycravings/presentation/update_cravings/states/update_cravings_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'update_cravings_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<CravingsRepository>(),
  MockSpec<CategoriesRepository>(),
  MockSpec<DebouncerUtils>(),
])
void main() {
  group(UpdateCravingsCubit, () {
    late MockCravingsRepository mockCravingsRepository;
    late MockCategoriesRepository mockCategoriesRepository;
    late MockDebouncerUtils mockDebouncerUtils;
    setUp(() {
      mockCravingsRepository = MockCravingsRepository();
      mockCategoriesRepository = MockCategoriesRepository();
      mockDebouncerUtils = MockDebouncerUtils();

      when(mockDebouncerUtils.run(any)).thenAnswer((invocation) {
        final action = invocation.positionalArguments[0] as VoidCallback;
        action();
      });
    });

    UpdateCravingsCubit createUnitToTest() {
      return UpdateCravingsCubit(
        mockCravingsRepository,
        mockCategoriesRepository,
        mockDebouncerUtils,
      );
    }

    test('init should set categories enabled based on craving categories properly', () async {
      final mockCategories = [
        CategoryModel.empty.copyWith(id: 1),
        CategoryModel.empty.copyWith(id: 2),
        CategoryModel.empty.copyWith(id: 3),
      ];

      final mockCravingCategories = [
        CategoryModel.empty.copyWith(id: 1),
        CategoryModel.empty.copyWith(id: 2),
      ];
      when(mockCategoriesRepository.selectAll()).thenAnswer((_) async => mockCategories);

      final unit = createUnitToTest();

      fakeAsync((async) {
        unit.arguments = CravingModel.test.copyWith(categories: mockCravingCategories);

        async.elapse(const Duration(seconds: 1));

        verify(mockCategoriesRepository.selectAll()).called(1);
        expect(unit.state.categories, mockCategories.map((category) {
          if (category.id == 1 || category.id == 2) {
            return category.copyWith(isSelected: true);
          } else {
            return category.copyWith(isSelected: false);
          }
        }));
      });
    });

    test('updateCraving should emit CravingError.empty if craving is empty string', () async {
      final unit = createUnitToTest();

      final updateCravingResult = await unit.updateCraving('');

      expect(updateCravingResult, false);
      expect(unit.state.cravingError, CravingError.empty);
    });

    test('updateCraving should emit CravingError.duplicate if craving already exists', () async {
      when(mockCravingsRepository.getCravingByName('sample craving name'))
          .thenAnswer((_) async => CravingModel.test.copyWith(id: 2));

      final unit = createUnitToTest();
      unit.arguments = CravingModel.test.copyWith(id: 1);

      final updateCravingResult = await unit.updateCraving('sample craving name');

      expect(updateCravingResult, false);
      expect(unit.state.cravingError, CravingError.duplicate);
    });

    test('updateCraving should update craving name and categories if all validations passed', () async {
      final mockCategories = [
        CategoryModel.empty.copyWith(id: 1),
        CategoryModel.empty.copyWith(id: 2),
        CategoryModel.empty.copyWith(id: 3),
      ];

      final mockCravingCategories = [
        CategoryModel.empty.copyWith(id: 1),
        CategoryModel.empty.copyWith(id: 2),
      ];
      when(mockCategoriesRepository.selectAll()).thenAnswer((_) => Future.value(mockCategories));
      when(mockCravingsRepository.getCravingByName('sample craving name')).thenAnswer((_) => Future.value(null));

      final unit = createUnitToTest();

      fakeAsync((async) {
        unit.arguments = CravingModel.test.copyWith(categories: mockCravingCategories);

        async.elapse(const Duration(seconds: 1));

        unit.onCategoryClick(3);

        async.elapse(const Duration(seconds: 1));

        unit.updateCraving('updated craving name');

        async.elapse(const Duration(seconds: 1));

        final verification = verify(mockCravingsRepository.replace(captureAny));

        expect((verification.captured.firstOrNull as CravingModel).name, 'updated craving name');
        expect((verification.captured.firstOrNull as CravingModel).categories,
            unit.state.categories.where((category) => category.isSelected ?? false));
      });
    });

    test('deleteCraving should call delete craving successfully', () {
      final mockCraving = CravingModel.test;
      final unit = createUnitToTest();

      fakeAsync((async) {
        unit.arguments = mockCraving;

        async.elapse(const Duration(seconds: 1));

        unit.deleteCraving();

        verify(mockCravingsRepository.remove(mockCraving.id)).called(1);
      });
    });

    test('onCravingChanged should emit CravingError.empty if craving is empty string', () async {
      final unit = createUnitToTest();

      fakeAsync((async) {
        unit.onCravingChanged('');

        async.elapse(const Duration(seconds: 1));

        expect(unit.state.cravingError, CravingError.empty);
      });
    });

    test('onCravingChanged should emit CravingError.duplicate if craving already exists', () async {
      when(mockCravingsRepository.getCravingByName('sample craving name')).thenAnswer((_) async => CravingModel.test);

      final unit = createUnitToTest();

      fakeAsync((async) {
        unit.onCravingChanged('sample craving name');

        async.elapse(const Duration(seconds: 1));

        expect(unit.state.cravingError, CravingError.duplicate);
      });
    });

    test('onCravingChanged should emit CravingError.none if all validations passed', () async {
      final mockCategories = [
        CategoryModel.empty,
        CategoryModel.empty,
      ];
      when(mockCategoriesRepository.selectAll()).thenAnswer((_) async => mockCategories);
      when(mockCravingsRepository.getCravingByName('sample craving name')).thenAnswer((_) async => null);

      final unit = createUnitToTest();

      fakeAsync((async) {
        unit.onCravingChanged('sample craving name');

        async.elapse(const Duration(seconds: 1));

        expect(unit.state.cravingError, CravingError.none);
      });
    });

    test('onCategoryClick should toggle category to true if it is false', () async {
      final mockCategories = [
        CategoryModel.empty.copyWith(id: 1),
        CategoryModel.empty.copyWith(id: 2, isSelected: false),
      ];
      when(mockCategoriesRepository.selectAll()).thenAnswer((_) async => mockCategories);

      final unit = createUnitToTest();

      fakeAsync((async) {
        unit.arguments = CravingModel.test.copyWith(categories: []);

        async.elapse(const Duration(seconds: 1));

        unit.onCategoryClick(1);

        async.elapse(const Duration(seconds: 1));

        expect(unit.state.categories.elementAt(0).isSelected, true);
        expect(unit.state.categories.elementAt(1).isSelected, false);
      });
    });

    test('onCategoryClick should toggle category to false if it is true', () async {
      final mockCategories = [
        CategoryModel.empty.copyWith(id: 1),
        CategoryModel.empty.copyWith(id: 2),
      ];
      when(mockCategoriesRepository.selectAll()).thenAnswer((_) async => mockCategories);

      final unit = createUnitToTest();

      fakeAsync((async) {
        unit.arguments = CravingModel.test.copyWith(categories: mockCategories);

        async.elapse(const Duration(seconds: 1));

        unit.onCategoryClick(1);

        async.elapse(const Duration(seconds: 1));

        expect(unit.state.categories.elementAt(0).isSelected, false);
        expect(unit.state.categories.elementAt(1).isSelected, true);
      });
    });

    test('addCategory should emit CategoryError.empty if category is empty string', () async {
      final unit = createUnitToTest();

      final addCategoryResult = await unit.addCategory('');

      expect(addCategoryResult, false);
      expect(unit.state.categoryError, CategoryError.empty);
    });

    test('addCategory should emit CategoryError.duplicate if category already exists', () async {
      final mockCategories = [
        CategoryModel.empty.copyWith(name: 'sample category name'),
        CategoryModel.empty,
      ];
      when(mockCategoriesRepository.selectAll()).thenAnswer((_) async => mockCategories);

      final unit = createUnitToTest();

      fakeAsync((async) {
        unit.arguments = CravingModel.test.copyWith(categories: mockCategories);

        async.elapse(const Duration(seconds: 1));

        unit.addCategory('sample category name');

        async.elapse(const Duration(seconds: 1));

        expect(unit.state.categoryError, CategoryError.duplicate);
      });
    });

    test('addCategory should add category in list and selected as default', () async {
      final mockCategories = [
        CategoryModel.empty,
        CategoryModel.empty,
      ];
      when(mockCategoriesRepository.selectAll()).thenAnswer((_) async => mockCategories);
      when(mockCategoriesRepository.insert('sample category name')).thenAnswer((_) async => CategoryModel.empty);

      final unit = createUnitToTest();

      fakeAsync((async) {
        unit.arguments = CravingModel.test.copyWith(categories: mockCategories);

        async.elapse(const Duration(seconds: 1));

        unit.addCategory('sample category name');

        async.elapse(const Duration(seconds: 1));

        expect(unit.state.categories.length, 3);
        expect(unit.state.categories.elementAt(2).isSelected, true);
      });
    });

    test('onAddCategory should set CategoryError.none', () async {
      final unit = createUnitToTest();

      unit.onAddCategory();

      expect(unit.state.categoryError, CategoryError.none);
    });

    test('onCategoryChanged should set CategoryError.empty if category is empty string', () async {
      final unit = createUnitToTest();
      unit.emit(unit.state.copyWith(categoryError: CategoryError.duplicate));

      unit.onCategoryChanged('');

      expect(unit.state.categoryError, CategoryError.empty);
    });

    test('onCategoryChanged should set CategoryError.duplicate if category already exists', () async {
      final mockCategories = [
        CategoryModel.empty.copyWith(name: 'sample category name'),
        CategoryModel.empty,
      ];
      when(mockCategoriesRepository.selectAll()).thenAnswer((_) async => mockCategories);

      final unit = createUnitToTest();

      fakeAsync((async) {
        unit.arguments = CravingModel.test.copyWith(categories: mockCategories);

        async.elapse(const Duration(seconds: 1));

        unit.onCategoryChanged('sample category name');

        expect(unit.state.categoryError, CategoryError.duplicate);
      });
    });

    test('onCategoryChanged should set CategoryError.none if validations passed', () async {
      final mockCategories = [
        CategoryModel.empty,
        CategoryModel.empty,
      ];
      when(mockCategoriesRepository.selectAll()).thenAnswer((_) async => mockCategories);

      final unit = createUnitToTest();

      fakeAsync((async) {
        unit.arguments = CravingModel.test.copyWith(categories: mockCategories);

        async.elapse(const Duration(seconds: 1));

        unit.onCategoryChanged('sample category name');

        expect(unit.state.categoryError, CategoryError.none);
      });
    });

    test('onLongPressCategory should remove category from list', () async {
      final mockCategories = [
        CategoryModel.empty.copyWith(id: 1),
        CategoryModel.empty.copyWith(id: 2),
      ];
      when(mockCategoriesRepository.selectAll()).thenAnswer((_) async => mockCategories);
      when(mockCategoriesRepository.remove(1)).thenAnswer((_) async => 1);

      final unit = createUnitToTest();

      fakeAsync((async) {
        unit.arguments = CravingModel.test.copyWith(categories: mockCategories);

        async.elapse(const Duration(seconds: 1));

        unit.onLongPressCategory(1);

        expect(unit.state.categories.length, 1);
        expect(unit.state.categories.elementAt(0).id, 2);
      });
    });
  });
}
