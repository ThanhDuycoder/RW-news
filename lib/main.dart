import 'package:flutter/material.dart';
import 'package:rw_news/add_article_page.dart';
import 'objectbox.g.dart'; // Import the generated file
import 'page.dart'; // Assuming this contains ArticleListScreen

late Store store;
late Box<Article> articleBox;

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter bindings are initialized
  store = await openStore(); // Open ObjectBox store
  articleBox = store.box<Article>(); // Open the box for Articles
  runApp(NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RW NEWS',
      theme: ThemeData(primarySwatch: Colors.green),
      home: ArticleListScreen(),
    );
  }
}
