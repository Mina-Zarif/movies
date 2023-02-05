abstract class MovieDetailsState {}

class InitialState extends MovieDetailsState {}

class LoadingState extends MovieDetailsState {}

class GetDataSuccess extends MovieDetailsState {}

class GetDataError extends MovieDetailsState {}

class TrailerSuccessState extends MovieDetailsState {}

class TrailerLoadingState extends MovieDetailsState {}

class TrailerErrorState extends MovieDetailsState {}
