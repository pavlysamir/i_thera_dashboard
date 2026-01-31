import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_thera_dashboard/core/di/service_locator.dart';
import 'package:i_thera_dashboard/features/regions/data/models/region_model.dart';
import 'package:i_thera_dashboard/features/regions/data/models/region_price_model.dart';
import 'package:i_thera_dashboard/features/regions/manager/regions_cubit.dart';

class RegionsScreen extends StatelessWidget {
  const RegionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RegionsCubit>()..loadData(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF0D47A1)),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'اسعار الجلسات',
            style: TextStyle(
              color: Color(0xFF0D47A1),
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          centerTitle: false,
        ),
        body: const _RegionsBody(),
      ),
    );
  }
}

class _RegionsBody extends StatefulWidget {
  const _RegionsBody({Key? key}) : super(key: key);

  @override
  State<_RegionsBody> createState() => _RegionsBodyState();
}

class _RegionsBodyState extends State<_RegionsBody> {
  final TextEditingController _priceController = TextEditingController();
  RegionModel? _selectedRegion;
  bool _isEditing = false;
  int? _editingRegionId;

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  void _resetForm() {
    setState(() {
      _priceController.clear();
      _selectedRegion = null;
      _isEditing = false;
      _editingRegionId = null;
    });
  }

  void _onEdit(RegionPriceModel priceData, List<RegionModel> regions) {
    setState(() {
      _isEditing = true;
      _editingRegionId = priceData.regionId;
      _priceController.text = priceData.price.toString();
      // Find region object by ID to pre-select dropdown
      try {
        _selectedRegion = regions.firstWhere((r) => r.id == priceData.regionId);
      } catch (e) {
        // If not found (shouldn't happen if consistency exists), just clear or keep null
        _selectedRegion = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegionsCubit, RegionsState>(
      listener: (context, state) {
        if (state is RegionsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is RegionsLoaded) {
          // If interaction finished successfully (re-loaded), maybe clear form?
          // We don't have a distinct "Success" state that persists, but re-loading effectively means success.
          // However, we might want to keep the form if user wants to add multiple? 
          // Usually clears on success.
          // But here, state is just loaded.
          // Let's rely on manual clear or clear if we detect data change?
          // Simplest: The "Add" button action resets the form.
        }
      },
      builder: (context, state) {
        if (state is RegionsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is RegionsLoaded) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Input Section
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    children: [
                      // Region Dropdown
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<RegionModel>(
                              hint: const Text(
                                'المنطقة',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  color: Colors.grey,
                                ),
                              ),
                              value: _selectedRegion,
                              isExpanded: true,
                              items: state.regions.map((RegionModel region) {
                                return DropdownMenuItem<RegionModel>(
                                  value: region,
                                  child: Text(
                                    region.nameAr,
                                    style: const TextStyle(fontFamily: 'Cairo'),
                                  ),
                                );
                              }).toList(),
                              onChanged: _isEditing
                                  ? null // Disable changing region in edit mode? Usually prices are per region. If editing price for X, X should be fixed.
                                  : (RegionModel? value) {
                                      setState(() {
                                        _selectedRegion = value;
                                      });
                                    },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Price Input
                      Expanded(
                        child: TextField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            hintText: 'السعر',
                            hintStyle: const TextStyle(
                                fontFamily: 'Cairo', color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Add/Edit Button
                Align(
                  alignment: Alignment.centerLeft, // Left because RTL? Image shows Left (which is Start in LTR but End in RTL context if button is left). Actually image shows button on left side of container? No, image is RTL, button is on Left. Wait. 
                  // Image: [Dropdown] [Input]
                  //         [   Button   ] (on left?)
                  // Let's look at image again.
                  // Img: Header "Prices". Inputs on row. Button below inputs, aligned to Left (Arabic left is end? No, Arabic reads Right to Left. So Left is End. )
                  // The inputs are [Price] [Region] (RTL: Region is Right, Price is Left). Wait.
                  // Image: [Price Field] [Region Field] (if RTL)
                  // The button is below them, Blue, "Add". Aligned to the Left (taking visual left).
                  child: SizedBox(
                    width: 200, // Fixed width or expanded? Image looks fixed width.
                    child: ElevatedButton(
                      onPressed: () {
                        if (_selectedRegion == null ||
                            _priceController.text.isEmpty) {
                          return;
                        }
                        final price = num.tryParse(_priceController.text);
                        if (price == null) return;

                        if (_isEditing && _editingRegionId != null) {
                          context
                              .read<RegionsCubit>()
                              .updatePrice(_editingRegionId!, price)
                              .then((_) => _resetForm());
                        } else {
                          context
                              .read<RegionsCubit>()
                              .addPrice(_selectedRegion!.id, price)
                              .then((_) => _resetForm()); // Reset after add
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007BFF), // Blue
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        _isEditing ? 'تعديل' : 'اضافة',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                // Table
                Expanded(
                  child: Container(
                     decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFA6C8FF)), // Light blue border
                      ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Table Header
                          Container(
                            color: const Color(0xFFE3F2FD),
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                            child: Row(
                              textDirection: TextDirection.rtl,
                              children: const [
                                Expanded(child: Text('المنطقة', textAlign: TextAlign.right, style: TextStyle(color: Color(0xFF5D7285), fontFamily: 'Cairo', fontWeight: FontWeight.bold))),
                                Expanded(child: Text('السعر', textAlign: TextAlign.right, style: TextStyle(color: Color(0xFF5D7285), fontFamily: 'Cairo', fontWeight: FontWeight.bold))),
                                SizedBox(width: 60, child: Text('التعديل', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF5D7285), fontFamily: 'Cairo', fontWeight: FontWeight.bold))),
                              ],
                            ),
                          ),
                          // Table Rows
                          ...state.prices.map((priceItem) {
                            return Container(
                              decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(color: Color(0xFFE3F2FD))),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                              child: Row(
                                textDirection: TextDirection.rtl,
                                children: [
                                  Expanded(child: Text(priceItem.regionName ?? '-', textAlign: TextAlign.right, style: const TextStyle(fontFamily: 'Cairo', color: Color(0xFF5D7285)))),
                                  Expanded(child: Text('${priceItem.price} جنيه', textAlign: TextAlign.right, style: const TextStyle(fontFamily: 'Cairo', color: Color(0xFF5D7285)))),
                                  SizedBox(
                                    width: 60,
                                    child: InkWell(
                                      onTap: () => _onEdit(priceItem, state.regions),
                                      child: const Text('تعديل', textAlign: TextAlign.center, style: TextStyle(color: Colors.blue, fontFamily: 'Cairo', decoration: TextDecoration.underline)),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
