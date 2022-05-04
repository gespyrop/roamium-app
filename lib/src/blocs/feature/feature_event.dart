part of 'feature_bloc.dart';

abstract class FeatureEvent extends Equatable {
  const FeatureEvent();

  @override
  List<Object> get props => [];
}

class SubmitFeatures extends FeatureEvent {
  final double longitude, latitude;
  final List<Category> categories;
  final bool wheelchair;

  const SubmitFeatures(
    this.longitude,
    this.latitude, {
    this.categories = const [],
    this.wheelchair = false,
  });
}

class SkipFeatures extends FeatureEvent {}

class ResetFeatures extends FeatureEvent {}

class ReloadRecommendations extends FeatureEvent {}
