abstract final class AnalyticsEvents {
  static const String eventPredict = 'app_event_predict';
  static const String eventswipePredict = 'app_event_swipe_predict';
  static const String eventchooseCraving = 'app_event_choose_craving';
  static const String eventIgnoreCraving = 'app_event_ignore_craving';
  static const String eventOpenAddCraving = 'app_event_open_add_craving';
  static const String eventAddCravingFail = 'app_event_add_craving_fail';
  static const String eventAddCravingSuccess = 'app_event_add_craving_success';
  static const String eventOpenUpdateCraving = 'app_event_open_update_craving';
  static const String eventUpdateCravingFail = 'app_event_update_craving_fail';
  static const String eventUpdateCravingSuccess = 'app_event_update_craving_success';
  static const String eventDeleteCraving = 'app_event_delete_craving';
  static const String eventToggleCategory = 'app_event_toggle_category';
  static const String eventOpenAddCategory = 'app_event_open_add_category';
  static const String eventRemoveCategory = 'app_event_remove_category';
  static const String eventAddCategoryFail = 'app_event_add_category_fail';
  static const String eventAddCategorySuccess = 'app_event_add_category_success';
  static const String eventAddCravingHistory = 'app_event_add_craving_history';

  static const String paramCraving = 'craving';
  static const String paramCategory = 'category';
  static const String paramError = 'error';
  static const String paramToggle = 'toggle';
}
