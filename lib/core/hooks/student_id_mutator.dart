import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:hive/hive.dart';
import 'student_id_query.dart';
import '../../main.dart';
import 'package:flutter/cupertino.dart';
import 'package:fquery/fquery.dart';
import '../../app_networking.dart';
import '../models/student_id_barcode.dart';
import '../models/student_id_photo.dart';
import '../models/student_id_profile.dart';
import '../models/student_id_name.dart';

// This serves as the base class for all data storage types
abstract class Hook<StudentIdModel>
//changed from Hook<T> to Hook<StudentIdProfileModel>
{
  const Hook();

  // unified interface for all types of flags
  get isInitializing; // has the hook been initialized with any data?
  get isFetching; // is the hook loading new data?
  get isError; // has the hook failed?
  // TODO: add unified interface for retrieving error object (either throw exception or add another getter)
  get error {
    throw FormatException('Error');
  }
  // unified interface for data retrieval
  get data{

    useFetchStudentIdBarcodeModel(accessToken);
    useFetchStudentIdProfileModel(accessToken);
    useFetchStudentIdPhotoModel(accessToken);
    useFetchStudentIdNameModel(accessToken);
  }
  // This is the mutator
  void mutate(StudentIdProfileModel Function(StudentIdProfileModel?) mutator);
}


// Example implementation of an FQuery hook
class FQueryHook<StudentIdProfileModel> extends Hook<StudentIdProfileModel>
{
  final UseQueryResult<StudentIdProfileModel, dynamic> queryHook;
  final String key; // key for FQuery

  // forwarded methods from UseQueryResult
  @override
  
  get data => queryHook.data;
  get dataUpdatedAt => queryHook.dataUpdatedAt;
  get error => queryHook.error;
  get errorUpdatedAt => queryHook.errorUpdatedAt;

  @override
  get isError => queryHook.isError;

  @override
  get isInitializing => queryHook.isLoading;

  @override
  get isFetching => queryHook.isFetching;

  get isSuccess => queryHook.isSuccess;
  get status => queryHook.status;
  get refetch => queryHook.refetch;

  const FQueryHook({ required this.queryHook, required this.key });

  // Must be called from within a build() method
  @override
  void mutate(T Function(T?) mutator) {
    queryClient.setQueryData<T>([key], mutator);
  }
}