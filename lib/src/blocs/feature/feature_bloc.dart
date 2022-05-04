import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:roamium_app/src/models/category.dart';
import 'package:roamium_app/src/models/place.dart';
import 'package:roamium_app/src/repositories/place/place_repository.dart';

part 'feature_event.dart';
part 'feature_state.dart';

class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  final PlaceRepository placeRepository;

  FeatureBloc(this.placeRepository) : super(FeatureInitial()) {
    on<SubmitFeatures>((event, emit) async {
      emit(RecommendationsLoading());
      try {
        List<Place> places = await placeRepository.recommendPlaces(
          longitude: event.longitude,
          latitude: event.latitude,
          categories: event.categories,
          wheelchair: event.wheelchair,
        );

        emit(RecommendationsLoaded(places));
      } on DioError catch (e) {
        emit(RecommendationsFailed(e.message));
      }
    });

    on<SkipFeatures>(((event, emit) {
      // TODO Fetch nearby places
      emit(FeatureInitial());
    }));

    on<ResetFeatures>((event, emit) => emit(FeatureInitial()));

    on<ReloadRecommendations>(((event, emit) async {
      if (state is RecommendationsLoaded) {
        List<Place> places = (state as RecommendationsLoaded).places;
        emit(RecommendationsLoading());
        await Future.delayed(const Duration(milliseconds: 500));
        emit(RecommendationsLoaded(places));
      }
    }));
  }
}
