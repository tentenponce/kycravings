import 'dart:ui';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kycravings/data/db/repositories/categories_repository.dart';
import 'package:kycravings/data/db/repositories/cravings_repository.dart';
import 'package:kycravings/domain/models/category_model.dart';
import 'package:kycravings/domain/models/craving_model.dart';
import 'package:kycravings/presentation/add_cravings/cubits/add_cravings_cubit.dart';
import 'package:kycravings/presentation/add_cravings/states/add_cravings_state.dart';
import 'package:kycravings/presentation/shared/utils/debouncer_utils.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_cravings_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<CravingsRepository>(),
  MockSpec<CategoriesRepository>(),
  MockSpec<DebouncerUtils>(),
])
void main() {
  group(AddCravingsCubit, () {
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

    AddCravingsCubit createUnitToTest() {
      return AddCravingsCubit(
        mockCravingsRepository,
        mockCategoriesRepository,
        mockDebouncerUtils,
      );
    }

    test('init should should get categories successfully', () async {
      final mockCategories = [
        CategoryModel.empty,
        CategoryModel.empty,
      ];
      when(mockCategoriesRepository.selectAll()).thenAnswer((_) async => mockCategories);

      final unit = createUnitToTest();
      await unit.init();

      verify(mockCategoriesRepository.selectAll()).called(2);
      expect(unit.state.categories, mockCategories);
    });

    test('addCraving should emit CravingError.empty if craving is empty string', () async {
      final unit = createUnitToTest();

      final addCravingResult = await unit.addCraving('');

      expect(addCravingResult, false);
      expect(unit.state.cravingError, CravingError.empty);
    });

    test('addCraving should emit CravingError.duplicate if craving already exists', () async {
      when(mockCravingsRepository.getCravingByName('sample craving name')).thenAnswer((_) async => CravingModel.test);

      final unit = createUnitToTest();

      final addCravingResult = await unit.addCraving('sample craving name');

      expect(addCravingResult, false);
      expect(unit.state.cravingError, CravingError.duplicate);
    });

    test('addCraving should insert craving if all validations passed', () async {
      final mockCategories = [
        CategoryModel.empty,
        CategoryModel.empty,
      ];
      when(mockCategoriesRepository.selectAll()).thenAnswer((_) async => mockCategories);
      when(mockCravingsRepository.getCravingByName('sample craving name')).thenAnswer((_) async => null);

      final unit = createUnitToTest();

      final addCravingResult = await unit.addCraving('sample craving name');

      expect(addCravingResult, true);
      verify(mockCravingsRepository.insert('sample craving name', unit.state.categories)).called(1);
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

    test('onCravingChanged should st CravingError.none if all validations passed', () async {
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

    test('onCategoryClick should toggle category to true if it is null', () async {
      final mockCategories = [
        CategoryModel.empty.copyWith(id: 1),
        CategoryModel.empty.copyWith(id: 2, isSelected: false),
      ];
      when(mockCategoriesRepository.selectAll()).thenAnswer((_) async => mockCategories);

      final unit = createUnitToTest();
      await unit.init();
      unit.onCategoryClick(1);

      expect(unit.state.categories.elementAt(0).isSelected, true);
      expect(unit.state.categories.elementAt(1).isSelected, false);
    });

    test('onCategoryClick should toggle category to true if it is false', () async {
      final mockCategories = [
        CategoryModel.empty.copyWith(id: 1, isSelected: false),
        CategoryModel.empty.copyWith(id: 2, isSelected: false),
      ];
      when(mockCategoriesRepository.selectAll()).thenAnswer((_) async => mockCategories);

      final unit = createUnitToTest();
      await unit.init();
      unit.onCategoryClick(1);

      expect(unit.state.categories.elementAt(0).isSelected, true);
      expect(unit.state.categories.elementAt(1).isSelected, false);
    });

    test('onCategoryClick should toggle category to false if it is true', () async {
      final mockCategories = [
        CategoryModel.empty.copyWith(id: 1, isSelected: true),
        CategoryModel.empty.copyWith(id: 2, isSelected: true),
      ];
      when(mockCategoriesRepository.selectAll()).thenAnswer((_) async => mockCategories);

      final unit = createUnitToTest();
      await unit.init();
      unit.onCategoryClick(1);

      expect(unit.state.categories.elementAt(0).isSelected, false);
      expect(unit.state.categories.elementAt(1).isSelected, true);
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
      await unit.init();

      final addCategoryResult = await unit.addCategory('sample category name');

      expect(addCategoryResult, false);
      expect(unit.state.categoryError, CategoryError.duplicate);
    });

    test('addCategory should add category in list and selected as default', () async {
      final mockCategories = [
        CategoryModel.empty,
        CategoryModel.empty,
      ];
      when(mockCategoriesRepository.selectAll()).thenAnswer((_) async => mockCategories);
      when(mockCategoriesRepository.insert('sample category name')).thenAnswer((_) async => CategoryModel.empty);

      final unit = createUnitToTest();
      await unit.init();

      final addCategoryResult = await unit.addCategory('sample category name');

      expect(addCategoryResult, true);
      expect(unit.state.categories.length, 3);
      expect(unit.state.categories.elementAt(2).isSelected, true);
    });

    test('onAddCategory should set CategoryError.none', () async {
      final unit = createUnitToTest();

      unit.onAddCategory();

      expect(unit.state.categoryError, CategoryError.none);
    });

    test('onCategoryChanged should set CategoryError.empty if category is empty string', () async {
      final unit = createUnitToTest();

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
      await unit.init();

      unit.onCategoryChanged('sample category name');

      expect(unit.state.categoryError, CategoryError.duplicate);
    });

    test('onCategoryChanged should set CategoryError.none if validations passed', () async {
      final mockCategories = [
        CategoryModel.empty,
        CategoryModel.empty,
      ];
      when(mockCategoriesRepository.selectAll()).thenAnswer((_) async => mockCategories);

      final unit = createUnitToTest();
      await unit.init();

      unit.onCategoryChanged('sample category name');

      expect(unit.state.categoryError, CategoryError.none);
    });

    test('onLongPressCategory should remove category from list', () async {
      final mockCategories = [
        CategoryModel.empty.copyWith(id: 1),
        CategoryModel.empty.copyWith(id: 2),
      ];
      when(mockCategoriesRepository.selectAll()).thenAnswer((_) async => mockCategories);
      when(mockCategoriesRepository.remove(1)).thenAnswer((_) async => 1);

      final unit = createUnitToTest();
      await unit.init();

      unit.onLongPressCategory(1);

      expect(unit.state.categories.length, 1);
      expect(unit.state.categories.elementAt(0).id, 2);
    });
  });
}
