import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:stockcounter/AppModule/provider/survey_provider.dart';
import 'package:stockcounter/AppModule/utils/app_text.dart';
import 'package:vibration/vibration.dart';
import '../db/db_helper.dart';
import '../utils/constants.dart';

class NewSurveyProvider extends ChangeNotifier {
  late SurveyProvider surveyProvider;
  final TextEditingController surveyNameController = TextEditingController();
  final TextEditingController counterController = TextEditingController();
  final TextEditingController productCountController = TextEditingController();

  final FocusNode focusNodeCounter = FocusNode();
  final FocusNode focusNodeSName = FocusNode();
  DatabaseHelper dbHelper = DatabaseHelper();

  bool isGrid = false;
  bool isLoading = false;
  List categoriesList = [];
  Map<int, List<dynamic>> categoryTempLists = {};
  List<bool> categoriesBoolList = [];
  List brandList = [];
  Map<int, List<dynamic>> brandTempLists = {};
  List<bool> brandBoolList = [];
  Map<int, List<dynamic>> segmentTempLists = {};
  List segmentList = [];
  List<bool> segmentBoolList = [];
  List<ItemModel> productItemModelList =[];
  List productNameList = [];
  List<bool> productNameBoolList = [];
  List<dynamic> productTrueList = [];
  Map<int, List<dynamic>> productNameTempLists = {};
  List surveyDetailList = [];
 List<int> sDetailCounter = [];
 int detialCounter = 0;
  var productName = '';
  var date = '';
  //excel lists
  List categoryXLList = [];
  List brandXLList = [];
  List segmentXLList = [];
  List productXLList = [];
  List qtyXLList = [];
  bool isMultiTap = false;


  void changeGrid() {
    isGrid = !isGrid;
    notifyListeners();
  }
  void clearLists() {
    brandList.clear();
    categoriesList.clear();
    segmentList.clear();
    productNameList.clear();
    surveyDetailList.clear();
    sDetailCounter.clear();
    productTrueList.clear();
    productItemModelList.clear();
    // newSurveyProvider.surveyDetailCountList.clear();
    isGrid = false;
    detialCounter = 0;
    productName = '';
  }

  void counterIncrement() {
    if(counterController.text.isEmpty){
      counterController.text = '0';
    }
    int counter = int.parse(counterController.text.trim());
    counter++;
    counterController.text = counter.toString();
    notifyListeners();
  }

  void counterDecrement() {
    if(counterController.text.isEmpty){
      counterController.text = '0';
    }
    int counter = int.parse(counterController.text.trim());
    counter--;
    counterController.text = counter.toString();
    notifyListeners();
  }
  void triggerVibrate() async{
     Vibration.vibrate(duration: 10);
   await HapticFeedback.mediumImpact();
  }

  Future<void> getUniqueCategories() async {
    Database? database = await dbHelper.db;
    List<Map<String, dynamic>> list = await database!.rawQuery('''
    SELECT DISTINCT category FROM products
    ''');
    categoriesList =
        List<String>.from(list.map((row) => row['category'] as String));
    categoriesBoolList = List<bool>.filled(categoriesList.length, false);

    notifyListeners();
    log('categoriesList---> $categoriesList');
  }

  Future<void> getUniqueBrand(int index, bool check) async {
    triggerVibrate();
    try {
      if (check) {
        Database? database = await dbHelper.db;
        List<Map<String, dynamic>> list = await database!.rawQuery('''
        SELECT DISTINCT brand FROM products WHERE category = '${categoriesList[index]}'
      ''');
        categoryTempLists[index] = List<String>.from(list.map((row) => row['brand'] as String));

        for (var brand in categoryTempLists[index]!) {
          if (!brandList.contains(brand)) {
            brandList.add(brand);
          }
        }
        brandBoolList = List<bool>.filled(brandList.length, false);
        segmentList.clear();
        productNameList.clear();
        notifyListeners();
        debugPrint('----BrandList----\n$brandList');
      } else {
        if (categoryTempLists.containsKey(index)) {
       //   debugPrint('-->tempList ${categoryTempLists[index]}');
          List<String> elementsToRemove = [];
          for (var brand in categoryTempLists[index]!) {
            if (brandList.contains(brand)) {
              elementsToRemove.add(brand);
            }
          }
          brandList.removeWhere((element) => elementsToRemove.contains(element));
          segmentList.clear();
          productNameList.clear();
          productItemModelList.clear();
        //  debugPrint('-->BrandList $brandList');
          notifyListeners();
        }
      }
    } catch (e, stackTrace) {
      debugPrint('error while getting unique brand list---> $e\n$stackTrace');
    }
  }

  Future<void> getUniqueSegment(index,bool check) async {
    triggerVibrate();
    try {
      if (check) {
        Database? database = await dbHelper.db;
        List<Map<String, dynamic>> list = await database!.rawQuery('''
        SELECT DISTINCT segment FROM products WHERE brand = '${brandList[index]}'
      ''');
        segmentTempLists[index] = List<String>.from(list.map((row) => row['segment'] as String));
        for (var segment in segmentTempLists[index]!) {
          if (!segmentList.contains(segment)) {
            segmentList.add(segment);
          }
        }
        segmentBoolList = List<bool>.filled(segmentList.length, false);
        productNameList.clear();
        notifyListeners();
        debugPrint('----segmentList----\n$segmentList');
      } else {
        if (segmentTempLists.containsKey(index)) {
          List<String> elementsToRemove = [];
          for (var segment in segmentTempLists[index]!) {
            if (segmentList.contains(segment)) {
              elementsToRemove.add(segment);
            }
          }
          segmentBoolList = List<bool>.filled(segmentList.length, false);
          segmentList.removeWhere((element) => elementsToRemove.contains(element));
          productNameList.clear();
          productItemModelList.clear();
          notifyListeners();
        }
      }
    } catch (e, stackTrace) {
      log('error while getting unique segment list---> $e\n$stackTrace');
    }
    // try {
    //   Database? database = await dbHelper.db;
    //   List<Map<String, dynamic>> list = await database!.rawQuery('''
    // SELECT DISTINCT segment FROM products WHERE brand = '${brandList[index]}'
    // ''');
    //   segmentList =
    //       List<String>.from(list.map((row) => row['segment'] as String));
    //   segmentBoolList = List<bool>.filled(segmentList.length, false);
    //   notifyListeners();
    //   log('segmentList---> $segmentList');
    // } catch (e,stackTrace) {
    //   log('error while getting unique segment list---> $e\n$stackTrace');
    // }
  }

  /*Future<void> getProducts(int index) async{
    Database? database = await dbHelper.db;
    List<Map<String, dynamic>> list = await database!.rawQuery('''
        SELECT * FROM products WHERE segment = '${segmentList[index]}'
      ''');
    allProducts = list;
    debugPrint("---- allProducts ---- \n$allProducts");
    notifyListeners();
  }*/

  Future<void> getUniqueProduct(index,bool check,{String? segmentName}) async {
    triggerVibrate();
    try {
      if (check) {
        Database? database = await dbHelper.db;
        List<Map<String, dynamic>> list = await database!.rawQuery('''
        SELECT * FROM products WHERE segment = '${segmentList[index]}'
      ''');
        productNameTempLists[index] = List<String>.from(list.map((row) => row['productName'] as String));
        List<dynamic> products = [];
        for (var productName in productNameTempLists[index]!) {
          if (!productNameList.contains(productName)) {
            productNameList.add(productName);
            products.add(productName);
          }
        }
        if (products.isNotEmpty) {
          productItemModelList.add(
              ItemModel(
                headerValue: segmentName ?? '',
                products: products,
              )
          );
        }
      //  debugPrint('----->headerVal: ${productItemModelList.first.headerValue}');
        for (var element in productItemModelList) {
          debugPrint('----->products: ${element.products}');
        }
        /*for (var productName in productNameTempLists[index]!) {
          if (!productNameList.contains(productName)) {
             productNameList.add(productName);
            productItemModelList.add(ItemModel(
              headerValue: segmentName??'',
              products: productNameTempLists[index],
            ));
          }
        }
        debugPrint('----->headerVal: ${productItemModelList.first.headerValue}');
        for (var element in productItemModelList) {
          debugPrint('----->products: ${element.products}');
        }*/

        productNameBoolList = List<bool>.filled(productNameList.length, false,);
        notifyListeners();
       // log('productNameList---> $productNameList');
      } else {
        if (productNameTempLists.containsKey(index)) {
          List<String> elementsToRemove = [];
          for (var productName in productNameTempLists[index]!) {
            if (productNameList.contains(productName)) {
              elementsToRemove.add(productName);
            }
          }
          productNameList.removeWhere((element) => elementsToRemove.contains(element));
          notifyListeners();
        }
        var itemToRemove = productItemModelList.firstWhere(
                (item) => item.headerValue == segmentName,
            orElse: () => ItemModel(headerValue: '', products: [])
        );
        if (itemToRemove != null) {
          productItemModelList.remove(itemToRemove);
          notifyListeners();
        }
      }
    } catch (e, stackTrace) {
      log('error while getting unique product name list---> $e\n$stackTrace');
    }
  }
  void expandTileValue(int index, bool isExpanded){
    productItemModelList.elementAt(index).isExpanded = !productItemModelList.elementAt(index).isExpanded;
    notifyListeners();
  }

  int? number;
  int counterOne = 0;
  int? count1;
  void addSurveyDetail(int index, var pName,{int? count}) async{
    isMultiTap = true;
    if(count==0){}
    else{
      triggerVibrate();
      Database? database = await dbHelper.db;
      int? counter = int.tryParse(counterController.text) ?? 0;
      number = 0;
      //search product name in products table
      await database!.rawQuery('''
    SELECT * FROM products WHERE productName = '$pName'
  ''').then((value) {
        // log('------<<< value >>>------\n$value');
      });
      if (!productTrueList.contains(pName)) {
        productTrueList.add(pName);
      }
      if (surveyDetailList.contains(pName)) {
        int detailIndex = surveyDetailList.indexOf(pName);
        sDetailCounter[detailIndex] += count ?? counter;
        number = sDetailCounter[detailIndex];
      } else {
        surveyDetailList.add(pName);
        sDetailCounter.add(count ?? counter);
        number = count ?? counter;
      }
      productName = pName;
      detialCounter = number ?? 0;
      isMultiTap = false;
      notifyListeners();
    }
  }
// if (surveyDetailList.contains(productNameList[index])) {
  //   int detailIndex = surveyDetailList.indexOf(productNameList[index]);
  //
  //   sDetailCounter[detailIndex]++;
  // } else {
  //   surveyDetailList.add(productNameList[index]);
  //   sDetailCounter.add(1); // Initialize the counter for this product to 1.
  // }
  // notifyListeners();∂
  Map<String, dynamic> surveyDetailMap = {};
  List<int> prodIds = [];
  int count = 0;
  String editSurveyName = '';
  List editProductNameList = [];
  List editQuantityList = [];
  List tempProductts = [];
  String formattedDate = '';
  Future<void> saveSurveyDetailToDb(
    BuildContext context,
  {bool isEdit = false,}
  ) async {
    if(isEdit){
      try{
        log('---- isEdit ----');
        var database = await dbHelper.db;
        var existingSurvey = await database!.rawQuery(
            'Select * from survey where surveyName = "${surveyNameController.text}"');
        var surveyId = existingSurvey[0]['surveyId'];
        for (int i = 0; i < surveyDetailList.length; i++) {
          surveyDetailMap[surveyDetailList[i]] = sDetailCounter[i];
        }
        await database.query('survey', where: 'surveyId = ?', whereArgs: [surveyId]).then((value) async {
          if(value.isNotEmpty) {
            await database.update('survey', {
              'surveyName': surveyNameController.text,
            }, where: 'surveyId = ?', whereArgs: [surveyId]);
            for (var prod in surveyDetailMap.keys) {
              await database.rawQuery('''
          SELECT * FROM products WHERE productName = '$prod'
        ''').then((value) {
                List<int> list =
                List<int>.from(value.map((row) => row['productId'] as int));
                debugPrint('Products to be saved---> $list');
                prodIds.addAll(list);
              });
            }
            for (var prod in surveyDetailMap.values) {
              await database.insert('surveyDetail', {
                'surveyId': surveyId,
                'productId': prodIds[count],
                'quantity': prod,
              });
              count++;
            }
            surveyNameController.clear();
            if (context.mounted) {
              surveyProvider =
                  Provider.of<SurveyProvider>(context, listen: false);
            }
            surveyNameController.clear();
            Future.delayed(const Duration(milliseconds: 300), () {
              context.pop();
            });
            debugPrint("---- saved successfully ----");
            if(context.mounted){
              surveyProvider.getAllSurvey(context);
            }
            notifyListeners();}
        }).onError((error, stackTrace) {
          debugPrint('error while creating survey table---> $error\n$stackTrace');
        });
      }
      catch (e) {
        if (context.mounted) {
          Constants.snackBar(context, 'error-02 in saving survey');
        }
      }
    } else{
      try{
        isLoading = true;
        for (int i = 0; i < surveyDetailList.length; i++) {
          surveyDetailMap[surveyDetailList[i]] = sDetailCounter[i];
        }
        Database? database = await dbHelper.db;
        //format date
        DateTime currentDate = DateTime.now();
        date = DateFormat("dd/MM/yyyy hh:mm a").format(currentDate);

        await database!.insert('survey', {
          'surveyName': surveyNameController.text.trim(),
          'createdDate': date
        }).then((value) async {
          for (var prod in surveyDetailMap.keys) {

            await database.rawQuery('''
          SELECT * FROM products WHERE productName = '$prod'
        ''').then((value) {
              List<int> list =
              List<int>.from(value.map((row) => row['productId'] as int));
              debugPrint('Products to be saved---> $list');
              prodIds.addAll(list);
            });

          }

          for (var prod in surveyDetailMap.values) {
            await database.insert('surveyDetail', {
              'surveyId': value,
              'productId': prodIds[count],
              'quantity': prod,
            });
            count++;
          }
          surveyNameController.clear();
          if(context.mounted){
            surveyProvider = Provider.of<SurveyProvider>(context, listen: false);
          }
          surveyNameController.clear();
          Future.delayed(const Duration(milliseconds: 300), () {
            context.pop();
          });
          debugPrint("---- saved successfully ----");
          isLoading = false;
          if(context.mounted){
            surveyProvider.getAllSurvey(context);
          }
          notifyListeners();
        }).onError((error, stackTrace) {
          debugPrint('error while creating survey table---> $error\n$stackTrace');
        });
      } catch (e) {
        if (context.mounted) {
          Constants.snackBar(context, 'error-01 in saving survey');
        }
      }
    }
  }


  Future<void> getEditSurveyDetails(int index)async{
    tempProductts.clear();
    editQuantityList.clear();
    try {
      var database = await dbHelper.db;
      //survey Table
      var survey = await database!.rawQuery('Select * from survey where surveyId = $index');
      // get surveyDetails
      var details = await database.rawQuery('Select * from surveyDetail where surveyId = ${survey[0]['surveyId']}');

      for(var detail in details){
        tempProductts.add(await database.rawQuery('select * from products where productId = ${detail['productId']}'));
      }

        editQuantityList = details.map((e) => e['quantity']).toList();
      log('tempProductts ---> $tempProductts\n editQuantityList ---> $editQuantityList');
        editSurveyName = '${survey[0]['surveyName']}';
        surveyNameController.text = editSurveyName;
        var date = survey[0]['createdDate'];
        DateTime dateTime = DateFormat("dd/MM/yyyy hh:mm a").parse('$date');
        formattedDate = DateFormat("dd/MM/yyyy").format(dateTime);
        notifyListeners();
         // log('productIds ---> $productIds');
        // log('editProductNameList ---> $editProductNameList\nsurveyName ---> $editSurveyName');
        // log('quantity ---> $editQuantityList');

      // }
    } catch (e, stackTrace) {
      debugPrint('Error in getting Products ---> $e\n$stackTrace');
    }
  }
  var qtyList =[];
  Future<void> exportSurveyToExcelIndex(int surveyIndex,BuildContext context,{bool getSingleResult = false,String surveyName = ''}) async {
    qtyList.clear();
    if(getSingleResult){
     await getEditSurveyDetails(surveyIndex);
    }
    AndroidDeviceInfo info = await DeviceInfoPlugin().androidInfo;
    if(info.version.sdkInt >= 30){
      var prem = await Permission.manageExternalStorage.request();
      if(prem.isGranted){
        var db = await dbHelper.db;
        var surveyDetails = await db!.query('surveyDetail');
        for(var detail in surveyDetails){
          if(detail['surveyId'] == surveyIndex){
            qtyList.add(detail['quantity']);
          }
        }

        if (tempProductts.isNotEmpty) {
          Excel excel = Excel.createExcel();
          Sheet sheetObject = excel['Sheet1'];
          CellStyle boldStyle = CellStyle(
            bold: true,
          );
          CellStyle normalStyle = CellStyle(
            bold: false,
          );

          // Add headers with bold text
          sheetObject.cell(CellIndex.indexByString('A1')).value = 'Survey Name';
          sheetObject.cell(CellIndex.indexByString('C1')).value = 'Survey Date';

          // Set bold style for the header cells
          sheetObject.cell(CellIndex.indexByString('A1')).cellStyle = boldStyle;
          sheetObject.cell(CellIndex.indexByString('B1')).cellStyle = normalStyle;
          sheetObject.cell(CellIndex.indexByString('C1')).cellStyle = boldStyle;
          sheetObject.cell(CellIndex.indexByString('D1')).cellStyle = normalStyle;

          sheetObject.appendRow(['', '', '', '']);

          sheetObject.cell(CellIndex.indexByString('B1')).value = editSurveyName;
          sheetObject.cell(CellIndex.indexByString('D1')).value = formattedDate;
          //bold the category,brand,segment, product and quantity
          sheetObject.cell(CellIndex.indexByString('A3')).cellStyle = boldStyle;
          sheetObject.cell(CellIndex.indexByString('B3')).cellStyle = boldStyle;
          sheetObject.cell(CellIndex.indexByString('C3')).cellStyle = boldStyle;
          sheetObject.cell(CellIndex.indexByString('D3')).cellStyle = boldStyle;
          sheetObject.cell(CellIndex.indexByString('E3')).cellStyle = boldStyle;
          sheetObject.cell(CellIndex.indexByString('A3')).value = 'Category';
          sheetObject.cell(CellIndex.indexByString('B3')).value = 'Brand';
          sheetObject.cell(CellIndex.indexByString('C3')).value = 'Segment';
          sheetObject.cell(CellIndex.indexByString('D3')).value = 'Product';
          sheetObject.cell(CellIndex.indexByString('E3')).value = 'Quantity';

          // Add headers
          // sheetObject.appendRow([
          //   'Category',
          //   'Brand',
          //   'Segment',
          //   'Product',
          //   'Quantity',
          // ]);

          // Add product details to rows

          for (var product in tempProductts) {
            sheetObject.appendRow([
              product[0]['category'],
              product[0]['brand'],
              product[0]['segment'],
              product[0]['productName'],
              qtyList[tempProductts.indexOf(product)],
            ]);
          }
          // final Directory directory = Directory('/storage/emulated/0/Download');
          var directory = await getExternalStorageDirectory();
          String downloadPath = directory!.path;

          // Use SAF file picker to let the user choose the download directory
          String? result = await FilePicker.platform.getDirectoryPath();
          if (result != null) {
            downloadPath = result;
            // Save the Excel file
            //survey_data_$surveyIndex.xlsx
            final String excelFileName = '$surveyName.xlsx';

            final String excelFilePath = '$downloadPath/$excelFileName';
            final File file = File(excelFilePath);
            await file.writeAsBytes(excel.encode()!);
            if(context.mounted){
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: AppText(text:'Exported survey successfully',color: Colors.white,),
                  backgroundColor: Colors.green,
                ),
              );
            }
            //excelFilePath
            debugPrint('Excel file exported: $surveyName');
          }else{
            log("---- User canceled the picker ----");
          }

        } else {
          // Handle the case where no survey is found for the given index
          debugPrint('No survey found for index $surveyIndex');
        }
      }
      else if(prem.isPermanentlyDenied){
        if(context.mounted){
          Constants.showPermissionDialog(context);
        }
      }
      else{
        debugPrint('------permission denied------13');
      }
    } else{
      try{
      PermissionStatus status = await Permission.storage.request();
      if (status.isPermanentlyDenied) {
        if(context.mounted){
          Constants.showPermissionDialog(context);
        }
      }
      else if(status.isGranted){
        var db = await dbHelper.db;
        var surveyDetails = await db!.query('surveyDetail');
        for(var detail in surveyDetails){
          if(detail['surveyId'] == surveyIndex){
            qtyList.add(detail['quantity']);
          }
        }

        if (tempProductts.isNotEmpty) {
          Excel excel = Excel.createExcel();
          Sheet sheetObject = excel['Sheet1'];
          CellStyle boldStyle = CellStyle(
            bold: true,
          );
          CellStyle normalStyle = CellStyle(
            bold: false,
          );

          // Add headers with bold text
          sheetObject.cell(CellIndex.indexByString('A1')).value = 'Survey Name';
          sheetObject.cell(CellIndex.indexByString('C1')).value = 'Survey Date';

          // Set bold style for the header cells
          sheetObject.cell(CellIndex.indexByString('A1')).cellStyle = boldStyle;
          sheetObject.cell(CellIndex.indexByString('B1')).cellStyle = normalStyle;
          sheetObject.cell(CellIndex.indexByString('C1')).cellStyle = boldStyle;
          sheetObject.cell(CellIndex.indexByString('D1')).cellStyle = normalStyle;

          sheetObject.appendRow(['', '', '', '']);

          sheetObject.cell(CellIndex.indexByString('B1')).value = editSurveyName;
          sheetObject.cell(CellIndex.indexByString('D1')).value = formattedDate;
          //bold the category,brand,segment, product and quantity
          sheetObject.cell(CellIndex.indexByString('A3')).cellStyle = boldStyle;
          sheetObject.cell(CellIndex.indexByString('B3')).cellStyle = boldStyle;
          sheetObject.cell(CellIndex.indexByString('C3')).cellStyle = boldStyle;
          sheetObject.cell(CellIndex.indexByString('D3')).cellStyle = boldStyle;
          sheetObject.cell(CellIndex.indexByString('E3')).cellStyle = boldStyle;
          sheetObject.cell(CellIndex.indexByString('A3')).value = 'Category';
          sheetObject.cell(CellIndex.indexByString('B3')).value = 'Brand';
          sheetObject.cell(CellIndex.indexByString('C3')).value = 'Segment';
          sheetObject.cell(CellIndex.indexByString('D3')).value = 'Product';
          sheetObject.cell(CellIndex.indexByString('E3')).value = 'Quantity';

          // Add headers
          // sheetObject.appendRow([
          //   'Category',
          //   'Brand',
          //   'Segment',
          //   'Product',
          //   'Quantity',
          // ]);

          // Add product details to rows

          for (var product in tempProductts) {
            sheetObject.appendRow([
              product[0]['category'],
              product[0]['brand'],
              product[0]['segment'],
              product[0]['productName'],
              qtyList[tempProductts.indexOf(product)],
            ]);
          }
          // final Directory directory = Directory('/storage/emulated/0/Download');
          var directory = await getExternalStorageDirectory();
          String downloadPath = directory!.path;

          // Use SAF file picker to let the user choose the download directory
          String? result = await FilePicker.platform.getDirectoryPath();
          if (result != null) {
            downloadPath = result;
            // Save the Excel file
            // 'survey_data_$surveyIndex.xlsx';
            final String excelFileName = '$surveyName.xlsx';

            final String excelFilePath = '$downloadPath/$excelFileName';
            final File file = File(excelFilePath);
            await file.writeAsBytes(excel.encode()!);
            if(context.mounted){
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: AppText(text:'Exported survey successfully',color: Colors.white,),
                  backgroundColor: Colors.green,
                ),
              );
            }
            debugPrint('Excel file exported: $surveyName');
          }else{
            log("---- User canceled the picker ----");
          }

        } else {
          // Handle the case where no survey is found for the given index
          debugPrint('No survey found for index $surveyIndex');
        }
      }
      else{
        debugPrint('------permission denied------');
      }

    } catch(e,stackTrace){
      debugPrint('Error in exporting survey to excel ---> $e\n$stackTrace');
    }
    }

  }


  void deleteFromEditProduct(int index){
    tempProductts.removeAt(index);
    editQuantityList.removeAt(index);
    notifyListeners();
  }
  /*void removeSurveyDetail(int index) {
    surveyDetailList.removeAt(index);
    sDetailCounter.removeAt(index);
    notifyListeners();
  }*/
  void removeSurveyDetail1(int index) {
    String removedProduct = surveyDetailList[index];
    surveyDetailList.removeAt(index);
    sDetailCounter.removeAt(index);
    while (productTrueList.contains(removedProduct)) {
      productTrueList.remove(removedProduct); // Remove the product from productTrueList
    }
    notifyListeners();
  }
  //old
/*  void removeSurveyDetail(int index) {
    surveyDetailList.removeAt(index);
    sDetailCounter.removeAt(index);
    productNameBoolList[index] = false;
    //make false in productTrueList
    productTrueList[index] = false;
    log('-----> productTrueList <-----\n${productTrueList[index]}');
    notifyListeners();
  }*/


  @override
  void dispose() {
    surveyNameController.dispose();
    super.dispose();
  }

}
class ItemModel {
  ItemModel({
    required this.headerValue,
    this.products =const [],
    this.isExpanded = true,

  });
  String headerValue;
  List products;
  bool isExpanded;

}
//export to ex
/*
  Future<void> exportSurveyToExcelIndex(var index) async {
    if(index ==0){
      index++;
    }else{
      index = index+1;}


    Database? database = await dbHelper.db;
    List<Map<String, dynamic>> list = await database!.rawQuery('''
      SELECT * FROM savedSurvey WHERE surveyId = $index
    ''');

    if (list.isNotEmpty) {
      Map<String, dynamic> surveyMap = list.first;
      String category = surveyMap['category'];
      String brand = surveyMap['brand'];
      String segment = surveyMap['segment'];
      String surveyDetailMapJson = surveyMap['surveyDetailMap'];
      String surveyName = surveyMap['surveyName'];
      String date = surveyMap['createdDate'];
      List  categoryExcelList = category.split(',');
      List brandExcelList = brand.split(',');
      List segmentExcelList = segment.split(',');
      log('categoryXLList---> $categoryExcelList\n brandXLList---> $brandExcelList\n segmentXLList---> $segmentExcelList');
      //get only the date
      DateTime dateTime = DateFormat("dd/MM/yyyy hh:mm a").parse(date);
      String formattedDate = DateFormat("dd/MM/yyyy").format(dateTime);
      Map<String, dynamic> surveyDetailMap =
      Map<String, dynamic>.from(json.decode(surveyDetailMapJson));
      List<String> surveyDetailList = surveyDetailMap.keys.toList();

      Excel excel = Excel.createExcel();
      Sheet sheetObject = excel['Sheet1'];
      CellStyle boldStyle = CellStyle(
        bold: true,
      );
      CellStyle normalStyle = CellStyle(
        bold: false,
      );

      // Add headers with bold text
      sheetObject.cell(CellIndex.indexByString('A1')).value = 'Survey Name';
      sheetObject.cell(CellIndex.indexByString('B1')).value = surveyName;
      sheetObject.cell(CellIndex.indexByString('C1')).value = 'Survey Date';
      sheetObject.cell(CellIndex.indexByString('D1')).value = formattedDate;

      // Set bold style for the header cells
      sheetObject.cell(CellIndex.indexByString('A1')).cellStyle = boldStyle;
      sheetObject.cell(CellIndex.indexByString('B1')).cellStyle = normalStyle;
      sheetObject.cell(CellIndex.indexByString('C1')).cellStyle = boldStyle;
      sheetObject.cell(CellIndex.indexByString('D1')).cellStyle = normalStyle;

      sheetObject.appendRow(['', '', '', '']);

      // Add headers
      sheetObject.appendRow([
        'Category',
        'Brand',
        'Segment',
        'Product',
        'Quantity',
      ]);


      // Add survey details to rows
      for (var productName in surveyDetailList) {
        sheetObject.appendRow([
          category,
          brand,
          segment,
          productName,
          surveyDetailMap[productName],
        ]);
      }

      // Save the Excel file
      final String excelFileName = 'survey_data_$index.xlsx';
      final String excelFilePath =
          '${(await getExternalStorageDirectory())!.path}/$excelFileName';
      final File file = File(excelFilePath);
      await file.writeAsBytes(excel.encode()!);
      debugPrint('Excel file exported: $excelFilePath');
    } else {
      // Handle the case where no survey is found for the given index
      debugPrint('No survey found for index $index');
    }
  }
*/
// for( int i =0; i<categoryExcelList.length;i++) {
//   sheetObject.appendRow([
//     categoryExcelList[i],
//     brandExcelList[i],
//     segmentExcelList[i],
//     surveyDetailList[i],
//     surveyDetailMap[surveyDetailList[i]],
//   ]);
// }

// FOREIGN KEY (productId) REFERENCES products(productId),
// FOREIGN KEY (surveyId) REFERENCES ${surveyNameController.text.trim()}(surveyId)
// ON DELETE CASCADE
//  List<Map<String,dynamic>> surveyHierarchyList = [];
// if(categoriesBoolList.contains(true)){
// for(int i =0; i<categoriesBoolList.length;i++){
// if(categoriesBoolList[i]){
// surveyHierarchyList.add({
// 'category': categoriesList[i],
// });
// }
// }
// }
// if(brandBoolList.contains(true)){
// for(int i =0; i<brandBoolList.length;i++){
// if(brandBoolList[i]){
// surveyHierarchyList.add({
// 'brand': brandList[i],
// });
// }
// }
// }
// if(segmentBoolList.contains(true)){
// for(int i =0; i<segmentBoolList.length;i++){
// if(segmentBoolList[i]){
// surveyHierarchyList.add({
// 'brand': segmentList[i],
// });
// }
// }
// }
//save to xl
/* Future<void> exportSurveyToExcelIndex(var index) async {
    if(index ==0){
      index++;
    }else{
      index = index+1;
    }
    Database? database = await dbHelper.db;
    List<Map<String, dynamic>> list = await database!.rawQuery('''
      SELECT * FROM savedSurvey WHERE surveyId = $index
    ''');

    if (list.isNotEmpty) {
      Map<String, dynamic> surveyMap = list.first;
      String category = surveyMap['category'];
      String brand = surveyMap['brand'];
      String segment = surveyMap['segment'];
      String surveyDetailMapJson = surveyMap['surveyDetailMap'];
      String surveyName = surveyMap['surveyName'];
      String date = surveyMap['createdDate'];
      //get only the date
      DateTime dateTime = DateFormat("dd/MM/yyyy hh:mm a").parse(date);
      String formattedDate = DateFormat("dd/MM/yyyy").format(dateTime);
      Map<String, dynamic> surveyDetailMap =
      Map<String, dynamic>.from(json.decode(surveyDetailMapJson));
      List<String> surveyDetailList = surveyDetailMap.keys.toList();

      Excel excel = Excel.createExcel();
      Sheet sheetObject = excel['Sheet1'];
      CellStyle boldStyle = CellStyle(
        bold: true,
      );
      CellStyle normalStyle = CellStyle(
        bold: false,
      );

      // Add headers with bold text
      sheetObject.cell(CellIndex.indexByString('A1')).value = 'Survey Name';
      sheetObject.cell(CellIndex.indexByString('B1')).value = surveyName;
      sheetObject.cell(CellIndex.indexByString('C1')).value = 'Survey Date';
      sheetObject.cell(CellIndex.indexByString('D1')).value = formattedDate;

      // Set bold style for the header cells
      sheetObject.cell(CellIndex.indexByString('A1')).cellStyle = boldStyle;
      sheetObject.cell(CellIndex.indexByString('B1')).cellStyle = normalStyle;
      sheetObject.cell(CellIndex.indexByString('C1')).cellStyle = boldStyle;
      sheetObject.cell(CellIndex.indexByString('D1')).cellStyle = normalStyle;

      sheetObject.appendRow(['', '', '', '']);

      // Add headers
      sheetObject.appendRow([
        'Category',
        'Brand',
        'Segment',
        'Product',
        'Quantity',
      ]);

      // Add survey details to rows
      for (var productName in surveyDetailList) {
        sheetObject.appendRow([
          category,
          brand,
          segment,
          productName,
          surveyDetailMap[productName],
        ]);
      }

      // Save the Excel file
      final String excelFileName = 'survey_data_$index.xlsx';
      final String excelFilePath =
          '${(await getExternalStorageDirectory())!.path}/$excelFileName';
      final File file = File(excelFilePath);
      await file.writeAsBytes(excel.encode()!);
      debugPrint('Excel file exported: $excelFilePath');
    } else {
      // Handle the case where no survey is found for the given index
      debugPrint('No survey found for index $index');
    }
  }*/

//save to db old
/*
Future<void>saveSurveyDetailToDb(BuildContext context,)async{
  Map<String, dynamic> surveyDetailMap = {};
  for (int i = 0; i < surveyDetailList.length; i++) {
    surveyDetailMap[surveyDetailList[i]] = sDetailCounter[i];
  }
  //format date
  DateTime currentDate = DateTime.now();
  date = DateFormat("dd/MM/yyyy hh:mm a").format(currentDate);

  // Convert the map to a JSON string
  String surveyDetailMapJson = json.encode(surveyDetailMap);

  await createSurveyTable().then((value) async {
    Database? database = await dbHelper.db;
    await database!.insert(
      'savedSurvey',
      {
        'category': categoriesList.join(','),
        'brand': brandList.join(','),
        'segment': segmentList.join(','),
        'surveyName': surveyNameController.text.trim(),
        'createdDate': date,
        'surveyDetailMap': surveyDetailMapJson,
      },
    ).then((value) {
      surveyProvider = Provider.of<SurveyProvider>(context, listen: false);
      surveyNameController.clear();
      Future.delayed(const Duration(milliseconds: 500), () {
        context.pop();
      });
      debugPrint("---- saved successfully ----");
      surveyProvider.getAllSurvey();
      notifyListeners();
    });
  }).onError((error, stackTrace) {
    debugPrint('error while creating survey table---> $error\n$stackTrace');
  });
  // debugPrint('mapp --> $surveyDetailMap');
}*/
// -----
// Convert the map to a JSON string

// Object? productIdd = 0;
// await database!.rawQuery('''
//     SELECT * FROM products WHERE productName = '$productName'
//   ''').then((value) async{
//
//   for(var prod in surveyDetailMap.keys){
//     if(prod == productName){
//       await database.rawQuery('''
//     SELECT * FROM products WHERE productName = '$prod'
//   ''').then((value) {
//         prodIds.add(value[0]['productId'] as int);
//       });
//     }
//
//   }
//   for(var prod in surveyDetailMap.keys){
//     await database!.insert('surveyDetail', {
//       'surveyId': surveyNameController.text.trim(),
//       'createdDate': date
//     })
//
//   }
// });
// save to db

/*
  Future<void> createSurveyTable() async {
    Database? database = await dbHelper.db;
    await database!.execute('''
    CREATE TABLE IF NOT EXISTS savedSurvey (
      surveyId INTEGER PRIMARY KEY,
      category TEXT,
      brand TEXT,
      segment TEXT,
      surveyName TEXT,
      createdDate TEXT,
      surveyDetailMap TEXT NOT NULL
    )
  ''').catchError((error, stackTrace) {
      debugPrint('error while creating survey table---> $error\n$stackTrace');
    });
  }
 */
/*
 void deleteEditSurveyDetail(int index,Map<String, dynamic> surveyDetailList) {

    // Check if the index is within the bounds of the list
    if (index >= 0 && index < surveyDetailList.length) {
      // Convert the map keys to a list to access the key to be removed
      List<String> keys = surveyDetailList.keys.toList();

      // Remove the key at the specified index
      String keyToRemove = keys[index];
      surveyDetailList.remove(keyToRemove);
      notifyListeners();
    } else {
      debugPrint('Index out of bounds');
    }
  }
 */