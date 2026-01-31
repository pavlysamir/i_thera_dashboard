import 'package:dio/dio.dart';
import 'package:i_thera_dashboard/core/network/api_endpoints.dart';
import 'package:i_thera_dashboard/core/network/dio_helper.dart';
import 'package:i_thera_dashboard/features/regions/data/models/region_model.dart';
import 'package:i_thera_dashboard/features/regions/data/models/region_price_model.dart';

class RegionsRepository {
  Future<List<RegionModel>> getAllRegions() async {
    try {
      final response = await DioHelper.getData(url: ApiEndpoints.getAllRegions);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => RegionModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<List<RegionPriceModel>> getAllRegionsPrices() async {
    try {
      final response =
          await DioHelper.getData(url: ApiEndpoints.getAllRegionsPrices);
      if (response.statusCode == 200) {
        // Response format: { "result": { "data": [...] } } based on user description?
        // Wait, user said:
        /*
        {
          "result": {
            "id": 0,
            "success": true,
            "data": [ ... ]
          }
        }
        */
        // Let's verify the parsing logic.
        final data = response.data['result']['data'] as List<dynamic>;
        return data.map((e) => RegionPriceModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateRegionPrice(int regionId, num price) async {
    try {
      await DioHelper.postData(
        url: ApiEndpoints.updateRegionPrices,
        data: {
          "regionId": regionId,
          "price": price,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addRegionPrices(List<Map<String, dynamic>> prices) async {
    try {
      // DioHelper.postData takes a Map as `data`.
      // The endpoint requires a List as the body.
      // We might need to adjust DioHelper or pass it appropriately.
      // Dio's post supports `data` being `dynamic`.
      // Let's check DioHelper.postData signature.
      /*
      static Future<Response> postData({
        required String url,
        Map<String, dynamic>? query,
        required Map<String, dynamic> data, // <--- This enforces Map
        String? token,
      })
      */
      // DioHelper enforces Map. This is a problem for `addRegionPrices` which expects a List.
      // I should update DioHelper or use a workaround? 
      // Workaround: Call Dio directly here for this specific endpoint or update DioHelper.
      // Updating DioHelper is cleaner but risky for other usages? No, I can overload or make it dynamic.
      // I'll check DioHelper again.
      
      // For now, I'll bypass DioHelper for this specific call or make a new method in it if strict.
      // Because `DioHelper.postData` signature is `required Map<String, dynamic> data`, I cannot pass a List.
      // I will add `postDataList` to DioHelper or just modify `RegionsRepo` to access `DioHelper.dio.post` directly. 
      // Accessing `DioHelper.dio` is possible since it's static public.
      
      await DioHelper.dio.post(
        ApiEndpoints.addRegionPrices,
        data: prices,
        options: Options(
           headers: {
            'Content-Type': 'application/json',
            'accept': 'text/plain',
            // Token handling might be needed if not handled by interceptor?
            // DioHelper.init adds ApiInterceptor.
           }
        )
      );

    } catch (e) {
      rethrow;
    }
  }
}
