import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/book.dart';
import '../../../domain/entities/rent.dart';
import '../../../domain/usecases/rent/create_rent.dart';
import '../auth/auth_viewmodel.dart';

class RentFormState {
  final int days;
  final bool isLoading;

  const RentFormState({required this.days, required this.isLoading});
  factory RentFormState.initial() => const RentFormState(days: 1, isLoading: false);

  int get pricePerDay => 5000;
  int get totalPrice => days * pricePerDay;

  RentFormState copyWith({int? days, bool? isLoading}) {
    return RentFormState(days: days ?? this.days, isLoading: isLoading ?? this.isLoading);
  }
}

final rentFormViewModelProvider = NotifierProvider<RentFormViewModel, RentFormState>(RentFormViewModel.new);

class RentFormViewModel extends Notifier<RentFormState> {
  late final CreateRentUsecase _create = CreateRentUsecase(ref.read(rentRepositoryProvider));

  @override
  RentFormState build() => RentFormState.initial();

  void setDays(int value) {
    final v = value.clamp(1, 7);
    state = state.copyWith(days: v);
  }

  Future<void> submit(Book book) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) throw Exception('Sesi login berakhir. Silakan login ulang.');

    state = state.copyWith(isLoading: true);
    try {
      final now = DateTime.now();
      final expired = now.add(Duration(days: state.days));

      final rent = Rent(
        id: '',
        bookId: book.id,
        title: book.title,
        coverImage: book.coverImage,
        authorName: book.authorName,
        rentDays: state.days,
        pricePerDay: state.pricePerDay,
        totalPrice: state.totalPrice,
        rentedAt: now,
        expiredAt: expired,
      );

      await _create(uid: user.uid, rent: rent);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}