part of 'feature_bloc.dart';

abstract class FeatureState extends Equatable {
  const FeatureState();

  @override
  List<Object> get props => [];
}

class FeatureInitial extends FeatureState {}

class RecommendationsLoading extends FeatureState {}

class RecommendationsLoaded extends FeatureState {
  final List<Place> places;

  const RecommendationsLoaded(this.places);
}

class RecommendationsFailed extends FeatureState {
  final String message;

  const RecommendationsFailed(this.message);
}
