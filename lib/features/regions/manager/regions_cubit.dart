import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_thera_dashboard/features/regions/data/models/region_model.dart';
import 'package:i_thera_dashboard/features/regions/data/models/region_price_model.dart';
import 'package:i_thera_dashboard/features/regions/data/repo/regions_repo.dart';

// States
abstract class RegionsState {}

class RegionsInitial extends RegionsState {}

class RegionsLoading extends RegionsState {}

class RegionsLoaded extends RegionsState {
  final List<RegionModel> regions;
  final List<RegionPriceModel> prices;

  RegionsLoaded({required this.regions, required this.prices});
  
  RegionsLoaded copyWith({
     List<RegionModel>? regions,
     List<RegionPriceModel>? prices,
  }) {
    return RegionsLoaded(
      regions: regions ?? this.regions,
      prices: prices ?? this.prices,
    );
  }
}

class RegionsError extends RegionsState {
  final String message;
  RegionsError(this.message);
}

class RegionsActionSuccess extends RegionsState {
  final String message;
  RegionsActionSuccess(this.message);
}

// Cubit
class RegionsCubit extends Cubit<RegionsState> {
  final RegionsRepository _repo;

  RegionsCubit(this._repo) : super(RegionsInitial());

  List<RegionModel> _regions = [];
  List<RegionPriceModel> _prices = [];

  Future<void> loadData() async {
    emit(RegionsLoading());
    try {
      // Load both in parallel
      final results = await Future.wait([
        _repo.getAllRegions(),
        _repo.getAllRegionsPrices(),
      ]);

      _regions = results[0] as List<RegionModel>;
      _prices = results[1] as List<RegionPriceModel>;

      emit(RegionsLoaded(regions: _regions, prices: _prices));
    } catch (e) {
      emit(RegionsError(e.toString()));
    }
  }
  
  // Reload without showing full loading screen if desired, or just re-emit
  Future<void> _refreshData() async {
     try {
       final prices = await _repo.getAllRegionsPrices();
       _prices = prices;
        emit(RegionsLoaded(regions: _regions, prices: _prices));
     } catch(e) {
       // Keep old state or show error?
       // For simple UI, we can just emit error
       emit(RegionsError(e.toString()));
     }
  }

  Future<void> addPrice(int regionId, num price) async {
    try {
      // Endpoint expects List
      await _repo.addRegionPrices([
        {"regionId": regionId, "price": price}
      ]);
      await _refreshData();
    } catch (e) {
      emit(RegionsError(e.toString()));
      // Revert to loaded state after error?
      // emit(RegionsLoaded(regions: _regions, prices: _prices));
    }
  }

  Future<void> updatePrice(int regionId, num price) async {
    try {
      await _repo.updateRegionPrice(regionId, price);
      await _refreshData();
    } catch (e) {
      emit(RegionsError(e.toString()));
    }
  }
}
