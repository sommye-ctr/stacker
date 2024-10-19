import 'package:mobx/mobx.dart';
import 'package:stacker/models/booking.dart';
import 'package:stacker/models/stack.dart';
import 'package:stacker/services/database.dart';
part 'home_store.g.dart';

class HomeStore = _HomeStoreBase with _$HomeStore;

abstract class _HomeStoreBase with Store {
  final Database database = Database();

  @observable
  List<StackModel> createdStacks = ObservableList.of([]);
  @observable
  List<StackModel> joinedStacks = ObservableList.of([]);
  @observable
  List<Booking> bookings = ObservableList.of([]);
  @observable
  String? error;

  @action
  void fetchCreatedStacks() async {
    createdStacks.clear();
    var result = await database.fetchCreatedStacks();

    result.when((success) => createdStacks.addAll(success),
        (err) => error = err.toString());
  }

  @action
  void fetchJoinedStacks() async {
    joinedStacks.clear();
    var result = await database.fetchJoinedStacks();

    result.when(
      (success) => joinedStacks.addAll(success),
      (err) => error = err.toString(),
    );
  }

  @action
  void fetchbookings() async {
    bookings.clear();
    var result = await database.fetchBookings();

    result.when(
      (success) => bookings.addAll(success),
      (err) => error = err.toString(),
    );
  }

  @action
  void refresh() {
    fetchCreatedStacks();
    fetchJoinedStacks();
    fetchbookings();
  }
}
