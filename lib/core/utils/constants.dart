import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../features/auth/data/models/login_models/login_response/user_cache.dart';

double height = 812.h;

double width = 375.w;

const Map<String, Color> noteColors = {
  '--note1': Color(0xFFFFF6C8),
  '--note2': Color(0xFFC8F2FF),
  '--note3': Color(0xFFFFC8C8),
  '--note4': Color(0xFFE0FFC8),
  '--note5': Color(0xFFFFE6C8),
};

String boxName = 'userCacheBox';

UserCache? userCache;
