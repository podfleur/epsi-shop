import 'package:flutter/material.dart';
import 'article.dart';

class Cart extends ChangeNotifier{
  final _listArticles = <Article>[];
  
  void add(Article article){
    _listArticles.add(article);
    notifyListeners();
  }
  void remove(Article article){
    _listArticles.remove(article);
    notifyListeners();
  }
  void clear(){
    _listArticles.clear();
    notifyListeners();
  }
  
  List<Article> getAll()=> _listArticles;
}