import 'dart:developer';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stockcounter/AppModule/utils/constants.dart';

import '../db/db_helper.dart';
import '../utils/Fonts/AppDimensions.dart';
import '../utils/Fonts/font_weights.dart';
import '../utils/app_text.dart';

class HomeProvider extends ChangeNotifier {
  DatabaseHelper dbHelper = DatabaseHelper();
  List categoryList = [];
  List brandList = [];
  List segmentList = [];
  List productNameList = [];
  bool isLoading = false;

  Future<void> pickXlFile(BuildContext context) async {
   try{
     var status = await Permission.storage.status;
     if (status.isPermanentlyDenied) {
       if(context.mounted){
         Constants.showPermissionDialog(context);
       }
     }
     else if (!status.isGranted) {
       await Permission.storage.request();
     }
     FilePickerResult? result = await FilePicker.platform.pickFiles(
         allowMultiple: false,
         allowedExtensions: [
           'xlsx',
         ],
         type: FileType.custom);
     if (result != null) {
       if (context.mounted) {
         _showAlertDialog(
           context,
           result.files.single.name,
               () async {
             categoryList.clear();
             brandList.clear();
             segmentList.clear();
             productNameList.clear();
             // await deleteDataFromDb();
             loadingG(true);
             /*String file = result.files.first.path ?? '';
             Uint8List bytes =  File(file).readAsBytesSync();
             var excel = Excel.decodeBytes(bytes);*/
             var bytes = File.fromUri(Uri.parse(result.files.first.path ?? '')).readAsBytesSync();
             var excel = SpreadsheetDecoder.decodeBytes(bytes);
             for (var table in excel.tables.keys) {
               for (var row in excel.tables[table]!.rows) {
                 categoryList
                     .add(row[0].toString().split(",")[0].split('(').last);
                 brandList
                     .add(row[1].toString().split(",")[0].split('(').last);
                 segmentList
                     .add(row[2].toString().split(",")[0].split('(').last);
                 productNameList
                     .add(row[3].toString().split(",")[0].split('(').last);
                 debugPrint(
                     "Category Name:::: ${'${row[0]}'.split(",")[0].split('(').last}");
                 // debugPrint("Brand Name:::: ${row[1].toString().split(",")[0].split('(').last}");
               }
             }
             // add condition categoryList.length > 2
             if(categoryList.length > 2 && brandList.length > 2 && segmentList.length > 2 && productNameList.length > 2){
               categoryList.removeAt(0);
               brandList.removeAt(0);
               segmentList.removeAt(0);
               productNameList.removeAt(0);
               await saveToDb().then((value) {
                 debugPrint('--success--\n$categoryList');
                 Navigator.of(context).pop();
                 loadingG(false);
                 ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(
                     content: SizedBox(
                       height: 15.h,
                       child: AppText(text: "File uploaded successfully",color: Constants.whiteColor,),
                     ),
                   ),
                 );
               }).onError((error, stackTrace) {
                 debugPrint('--error--\n$error\n$stackTrace');
                 loadingG(false);
               });
             }else{
                loadingG(false);
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: SizedBox(
                      height: 15.h,
                      child: AppText(text: "Please select valid file",color: Constants.whiteColor,),

                    ),
                    backgroundColor: Constants.redColor,
                  ),
                );
             }
           },
         );
       }
     } else {
       debugPrint('---- User canceled the picker ----');
     }
   }
       catch(e,stackTrace){
         debugPrint('---- error\n ----> $e\n$stackTrace');
       }

  }


  //save to db
  Future<void> saveToDb() async {
    Database? database = await dbHelper.db;
    for (int i = 0; i < categoryList.length; i++) {
      Future.delayed(const Duration(milliseconds: 400), () async {
       // print("Save:--> ${categoryList[i]}, ${brandList[i]} , ${segmentList[i]}, ${productNameList[i]}");
        await database!.insert(
          'products',
          {
            'category': categoryList[i],
            'brand': brandList[i],
            'segment': segmentList[i],
            'productName': productNameList[i],
          },
        );
      });
    }
  }

  void loadingG(var loading) {
    isLoading = loading;
    notifyListeners();
  }

  //create excel file
  Future<void> createExcelFile(BuildContext _) async {
    try {
      var status = await Permission.storage.status;
      if (status.isPermanentlyDenied) {
        if (_.mounted) {
          Constants.showPermissionDialog(_);
        }
      }
      else if (!status.isGranted) {
        await Permission.storage.request();
      }
        var excel = Excel.createExcel();
        Sheet sheetObject = excel['Sheet1'];
        CellStyle boldStyle = CellStyle(
          bold: true,
        );
        sheetObject.cell(CellIndex.indexByString("A1")).cellStyle = boldStyle;
        sheetObject.cell(CellIndex.indexByString("B1")).cellStyle = boldStyle;
        sheetObject.cell(CellIndex.indexByString("C1")).cellStyle = boldStyle;
        sheetObject.cell(CellIndex.indexByString("D1")).cellStyle = boldStyle;
        sheetObject.cell(CellIndex.indexByString("A1")).value = 'Category';
        sheetObject.cell(CellIndex.indexByString("B1")).value = 'Brand';
        sheetObject.cell(CellIndex.indexByString("C1")).value = 'Segment';
        sheetObject.cell(CellIndex.indexByString("D1")).value = 'ProductName';

        Directory? directory = await getApplicationDocumentsDirectory();
        String downloadPath = directory.path;

        // Use SAF file picker to let the user choose the download directory
        String? result = await FilePicker.platform.getDirectoryPath();
        if (result != null) {
          downloadPath = result;
          var locTime = await getTime();
          String fileName = "masterData$locTime.xlsx";
          String excelFilePath = '$downloadPath/$fileName';
           File file = File(excelFilePath);
          await file.writeAsBytes(excel.encode()!);
          log("Excel file created successfully at $downloadPath");
          if (_.mounted) {
            ScaffoldMessenger.of(_).showSnackBar(
              SnackBar(
                content: AppText(
                  text: "Excel file created successfully",
                  color: Constants.whiteColor,
                ),
              ),
            );
          }
        }else{
          log("---- User canceled the picker ----");
        }

    } catch (e, stackTrace) {
      log("---> Error occurred while creating Excel file: $e\n $stackTrace");
      if (_.mounted) {
        ScaffoldMessenger.of(_).showSnackBar(
           SnackBar(
            content: Text("Error occurred while creating Excel file\n$e\n$stackTrace",style: const TextStyle(color: Colors.white),),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  //get current time
  Future<String> getTime() async {
    var now = DateTime.now();
    return '${now.millisecondsSinceEpoch}';
  }

  void _showAlertDialog(
      BuildContext context, String fileName, VoidCallback onTap) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Align(
              alignment: Alignment.topCenter,
              child: AppText(
                text: fileName,
                fontSize: AppDimension.fontSize18,
                fontWeight: FontWeights.medium,
              )),
          content: const AppText(
            text: 'Are you sure you want to upload the file..?',
            softWrap: true,
            fontSize: AppDimension.fontSize16,
            fontWeight: FontWeights.regular,
          ),
          actions: [
            Consumer<HomeProvider>(
              builder: (context, provider, child) {
                return provider.isLoading
                    ? Center(
                        child: SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: CircularProgressIndicator(
                            color: Constants.darkGreyColor,
                          ),
                        ),
                      )
                    : TextButton(
                        onPressed: onTap,
                        child: const AppText(text: 'Yes'),
                      );
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const AppText(text: 'No'),
            ),
          ],
        );
      },
    );
  }

  // deleting data from db
  // Future<void> deleteDataFromDb() async {
  //   try {
  //     Database? db = await dbHelper.db;
  //     await db!.delete('products');
  //     debugPrint('----old db removed----');
  //   } catch (e) {
  //     log('Error while deleting data from db: $e');
  //   }
  // }
}


/*-----------------*/
/*  Future<void> readCsvFile()async{
    ByteData data = await rootBundle.load('assets/images/latlng_file.xlsx');
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);
    for (var table in excel.tables.keys) {
      // debugPrint('-----------> Table:  $table'); //sheet Name
      // debugPrint('-----------> max Cols: ${excel.tables[table]!.maxCols}');
      // debugPrint('-----------> max Rows:${excel.tables[table]!.maxRows}');
      for (var row in excel.tables[table]!.rows) {
        excelLatList.add(row[2].toString().split(",")[0].split('(').last);
        excelLongList.add(row[3].toString().split(",")[0].split('(').last);
         debugPrint("Latitude:::: ${row[2].toString().split(",")[0].split('(').last}");
         debugPrint("Longitude:::: ${row[3].toString().split(",")[0].split('(').last}");
      }
     // log("ExcelSheetLat:::: ${excelLatList.length}");
    //  log("ExcelSheetLng:::: ${excelLongList.length}");
      // log("--------->${excel.tables[table]!.rows[0][0]}");
    }
  }*/
//read from asset
/*  Future<void> readExcelFromAsset() async {
    ByteData data = await rootBundle.load('assets/images/my_mob_sc1.xlsx');
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);
    for (var table in excel.tables.keys) {
      // debugPrint('-----------> Table:  $table'); //sheet Name
      // debugPrint('-----------> max Cols: ${excel.tables[table]!.maxCols}');
      // debugPrint('-----------> max Rows:${excel.tables[table]!.maxRows}');
      for (var row in excel.tables[table]!.rows) {
        categoryList.add(row[0].toString().split(",")[0].split('(').last);
        brandList.add(row[1].toString().split(",")[0].split('(').last);
        segmentList.add(row[2].toString().split(",")[0].split('(').last);
        productNameList.add(row[3].toString().split(",")[0].split('(').last);
        debugPrint(
            "Category Name:::: ${row[0].toString().split(",")[0].split('(').last}");
        debugPrint(
            "Brand Name:::: ${row[1].toString().split(",")[0].split('(').last}");
      }
    }
  }*/
