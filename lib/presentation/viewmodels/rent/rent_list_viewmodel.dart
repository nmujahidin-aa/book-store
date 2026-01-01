import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/rent.dart';
import '../../../domain/usecases/rent/watch_rents.dart';
import '../auth/auth_viewmodel.dart';

final rentListProvider = StreamProvider<List<Rent>>((ref) {
  final user = ref.watch(authRepositoryProvider).currentUser;
  if (user == null) return const Stream.empty();
  final usecase = WatchRentsUsecase(ref.watch(rentRepositoryProvider));
  return usecase(uid: user.uid);
});