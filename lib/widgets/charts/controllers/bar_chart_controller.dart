import 'package:get/get.dart';
import '../models/chart_data.dart';

class BarChartController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<ChartData?> chartData = Rx<ChartData?>(null);
  final RxString selectedPeriod = 'geral'.obs;

  Future<void> loadData({
    required Future<ChartData> Function(String period) fetchData,
    required String period,
    Function(String)? onPeriodChange,
    Function(String, List<ChartDataItem>)? onDataLoaded,
    Function(String)? onError,
  }) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';
      selectedPeriod.value = period;
      
      onPeriodChange?.call(period);

      final data = await fetchData(period);
      chartData.value = data;
      
      onDataLoaded?.call(period, data.data);
      
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      onError?.call(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void retry({
    required Future<ChartData> Function(String period) fetchData,
    Function(String)? onPeriodChange,
    Function(String, List<ChartDataItem>)? onDataLoaded,
    Function(String)? onError,
  }) {
    loadData(
      fetchData: fetchData,
      period: selectedPeriod.value,
      onPeriodChange: onPeriodChange,
      onDataLoaded: onDataLoaded,
      onError: onError,
    );
  }

  @override
  void onClose() {
    chartData.value = null;
    super.onClose();
  }
}