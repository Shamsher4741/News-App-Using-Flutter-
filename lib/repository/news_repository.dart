import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/models/categories_news_model.dart';
import 'package:news_app/models/news_channels_headlines_model.dart';
class NewsRepository{

  Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlinesApi(String channelName)async{
    String url = 'https://newsapi.org/v2/top-headlines?sources=$channelName&apiKey=ba4aa87415504b20800c3e2750a8f21a' ;
    final response = await http.get(Uri.parse(url));
   
    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      return NewsChannelsHeadlinesModel.fromJson(body);

    }throw Exception('Error');
  }

  Future<CategoriesNews> fetchCategoryNewsApi(String category)async{
    String url = 'https://newsapi.org/v2/everything?q=$category&apiKey=ba4aa87415504b20800c3e2750a8f21a' ;
    final response = await http.get(Uri.parse(url));

    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      return CategoriesNews.fromJson(body);

    }throw Exception('Error');
  }
}