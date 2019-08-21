import 'package:rxdart/rxdart.dart';
import 'package:vost/common/event.dart';
import 'package:vost/domain/managers/mock_manager.dart';
import 'package:vost/domain/managers/parish_manager.dart';
import 'package:vost/domain/models/mock_data.dart';
import 'package:vost/domain/models/parish_model.dart';
import 'package:vost/presentation/assets/error_messages.dart';
import 'package:vost/presentation/ui/_base/base_bloc.dart';

class HomeBloc extends BaseBloc {
    ParishManager _mockManager;

    /// Event to fetch new data
    var _fetchNewDataSubject = PublishSubject<Event>();
    Sink<Event> get fetchNewDataSink => _fetchNewDataSubject.sink;

    /// Event to relay MockData information to the UI
    var _mockDataSubject = BehaviorSubject<List<ParishModel>>();
    Stream<List<ParishModel>> get mockDataStream => _mockDataSubject.stream;

    HomeBloc(this._mockManager) {
      disposable.add(
          _fetchNewDataSubject
            .stream
            .flatMap((_) => _mockManager.getParishes())
            .map((base) => base.data.toList())
            .listen(_mockDataSubject.add, onError: (error) {
              print(error);
              handleOnError(genericErrorMessage);
          })
      );
    }
}