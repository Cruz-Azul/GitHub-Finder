import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_search/modules/profiles/bloc/blocs.dart';
import 'package:github_search/modules/profiles/exceptions/custom_exceptions.dart';
import 'package:github_search/modules/profiles/repositories/profile_repository.dart';
import 'package:mockito/mockito.dart';

// ignore: must_be_immutable
class MockProfilesRepository extends Mock implements ProfilesRepository {}

void main() {
  ProfilesRepository profilesRepository;
  // ProfilesBloc profilesBloc;
  // SearchBloc searchBloc

  setUp(() {
    profilesRepository = MockProfilesRepository();
  });

  group('Profiles Bloc Tests', () {
    test('should test initial state', () {
      expect(
        ProfilesBloc(
          profilesRepository: profilesRepository,
        ).state,
        isA<ProfilesInitialeState>(),
      );
    });

    blocTest(
      'emit [] when nothing is called',
      build: () => ProfilesBloc(profilesRepository: profilesRepository),
      expect: () => [],
    );

    blocTest(
      'emit [ProfilesInitialeState] when FetchProfilesEvent is called without search',
      build: () => ProfilesBloc(profilesRepository: profilesRepository),
      act: (bloc) async =>
          bloc.add(FetchProfilesEvent(searchText: "", filterText: "Nothing")),
      expect: () => [ProfilesInitialeState()],
    );

    blocTest(
      'emit [ProfilesFetchInProgressState,ProfilesFetchSuccessState] when FetchProfilesEvent is called with a search',
      build: () => ProfilesBloc(profilesRepository: profilesRepository),
      act: (bloc) async => bloc
          .add(FetchProfilesEvent(searchText: "Cruz-A", filterText: "Nothing")),
      expect: () => const <ProfilesState>[
        ProfilesFetchInProgressState(),
        ProfilesFetchSuccessState()
      ],
    );

    blocTest(
      'emit [ProfilesFetchErrorState] when FetchProfilesEvent is called with error',
      build: () {
        when(
          profilesRepository.fetchProfiles(
              searchText: "Cruz-A", filterText: "Nothing"),
        ).thenAnswer((_) => Future.error(FetchDataException()));

        return ProfilesBloc(profilesRepository: profilesRepository);
      },
      act: (bloc) async => bloc
          .add(FetchProfilesEvent(searchText: "Cruz-A", filterText: "Nothing")),
      expect: () => const <ProfilesState>[
        ProfilesFetchInProgressState(),
        ProfilesFetchErrorState(),
      ],
    );
  });
}
