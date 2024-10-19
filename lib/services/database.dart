import 'dart:ffi';
import 'dart:io';

import 'package:multiple_result/multiple_result.dart';
import 'package:stacker/models/booking.dart';
import 'package:stacker/models/stack_details.dart';
import 'package:stacker/models/stack_dto.dart';
import 'package:stacker/utils/date_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:stacker/models/stack.dart';

class Database {
  late SupabaseClient supabase;

  Database() {
    supabase = Supabase.instance.client;
  }

  Future<Result<List<StackModel>, PostgrestException>>
      fetchCreatedStacks() async {
    try {
      final resp = await supabase
          .from("stacks")
          .select()
          .eq("user_id", supabase.auth.currentUser!.id);

      return Success((resp as List).map((e) => StackModel.fromMap(e)).toList());
    } on PostgrestException catch (e) {
      return Error(e);
    }
  }

  Future<Result<List<StackModel>, PostgrestException>>
      fetchJoinedStacks() async {
    try {
      final res = await supabase
          .from("joined_stacks")
          .select('stack_id')
          .eq("user_id", supabase.auth.currentUser!.id);

      List<String> ids = (res as List)
          .map(
            (e) => e['stack_id'] as String,
          )
          .toList();

      final resp = await supabase.from("stacks").select().inFilter("id", ids);
      return Success((resp as List).map((e) => StackModel.fromMap(e)).toList());
    } on PostgrestException catch (e) {
      return Error(e);
    }
  }

  Future<Result<List<Booking>, PostgrestException>> fetchBookings() async {
    try {
      final res = await supabase
          .from("booking")
          .select('*, stacks!inner(*)')
          .eq('user_id', supabase.auth.currentUser!.id);

      return Success((res as List).map((e) => Booking.fromMap(e)).toList());
    } on PostgrestException catch (e) {
      return Error(e);
    }
  }

  Future<Result<bool, String>> createStack(
      StackDto stack, File image, StackDetails details) async {
    String id, imageUrl;
    try {
      final resp =
          await supabase.from("stacks").insert(stack.toMap()).select('id');
      id = resp[0]['id'];
    } catch (e) {
      return Error(e.toString());
    }

    try {
      await supabase
          .from("stack_details")
          .insert(details.copyWith(stackId: id).toMap());
    } catch (e) {
      return Error(e.toString());
    }

    try {
      String path = await _uploadImage(image, id);
      imageUrl = supabase.storage
          .from("stack_images")
          .getPublicUrl(path.split("/").last);
    } catch (e) {
      return Error(e.toString());
    }

    try {
      await supabase.from("stacks").update({'image': imageUrl}).eq('id', id);
    } catch (e) {
      return Error(e.toString());
    }

    return const Success(true);
  }

  Future<String> _uploadImage(File file, String stackId) async {
    return supabase.storage.from("stack_images").upload("/$stackId", file);
  }

  Future<Result<void, String>> joinStack(String shortId, String userId) async {
    try {
      var resp = await supabase
          .from("stacks")
          .select('id')
          .eq('short_id', shortId)
          .neq('user_id', userId);
      if (resp.isEmpty) {
        return const Error("No stack with such ID exists");
      }
      String id = resp.first['id'];

      await supabase
          .from("joined_stacks")
          .insert({'user_id': userId, 'stack_id': id});
      // ignore: void_checks
      return const Success(Void);
    } catch (e) {
      return Error(e.toString());
    }
  }

  Future<Result<Map<String, dynamic>, String>> getBookingDetails(
      String userId, String stackId) async {
    try {
      var resp = await supabase.functions.invoke(
        "create-booking",
        queryParameters: {
          "userId": userId,
          "stackId": stackId,
        },
      );
      print(resp.data);
      if (resp.status == 200) {
        return Success(resp.data as Map<String, dynamic>);
      }
      return Error(resp.data['message']);
    } on FunctionException catch (e) {
      return Error(e.details);
    } catch (e) {
      return Error(e.toString());
    }
  }

  Future<Result<void, String>> proceedBooking(Map<String, dynamic> data) async {
    String isoFormat = data['time_arrival'];
    data['time_arrival'] = DateHelper.convertTimeOfDayToPostgres(
        DateHelper.convertIso8601ToTimeOfDay(isoFormat));
    try {
      await supabase.from("booking").insert(data);
      // ignore: void_checks
      return const Success(Void);
    } catch (e) {
      return Error(e.toString());
    }
  }

  Future<Result<StackModel, String>> openStack(String stackId) async {
    try {
      var resp = await supabase
          .from("stacks")
          .update({"status": "Open"})
          .eq('id', stackId)
          .select()
          .single();
      return Success(StackModel.fromMap(resp));
    } catch (e) {
      return Error(e.toString());
    }
  }

  Future<Result<StackModel, String>> closeStack(String stackId) async {
    try {
      var resp = await supabase
          .from("stacks")
          .update({"status": "Closed"})
          .eq('id', stackId)
          .select()
          .single();
      return Success(StackModel.fromMap(resp));
    } catch (e) {
      return Error(e.toString());
    }
  }
}
