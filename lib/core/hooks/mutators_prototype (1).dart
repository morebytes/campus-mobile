import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:hive/hive.dart';

import '../../../../../main.dart';


// This serves as the base class for all data storage types
abstract class Hook<T>
{
  const Hook();

  // unified interface for all types of flags
  get isInitializing; // has the hook been initialized with any data?
  get isFetching; // is the hook loading new data?
  get isError; // has the hook failed?
  // TODO: add unified interface for retrieving error object (either throw exception or add another getter)
  get error;
  // unified interface for data retrieval
  get data;

  // This is the mutator
  void mutate(T Function(T?) mutator);
}


// Example implementation of an FQuery hook
class FQueryHook<T> extends Hook<T>
{
  final UseQueryResult<T, dynamic> queryHook;
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