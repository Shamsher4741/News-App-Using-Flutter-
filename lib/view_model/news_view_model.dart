


import 'package:news_app/models/categories_news_model.dart';
import 'package:news_app/repository/news_repository.dart';

import '../models/news_channels_headlines_model.dart';

class NewsViewModel{
  final _rep = NewsRepository();

  Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlinesApi(String channelName) async {
    final response = await _rep.fetchNewsChannelHeadlinesApi(channelName);
     return response;
  }
  Future<CategoriesNews> fetchCategoryNewsApi( String category) async {
    final response = await _rep.fetchCategoryNewsApi(category);
    return response;
  }


}