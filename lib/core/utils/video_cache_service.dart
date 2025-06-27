import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class VideoCacheService {
  Future<File> getVideo(String url) async {
    final file = await DefaultCacheManager().getSingleFile(url);
    return file;
  }
}
