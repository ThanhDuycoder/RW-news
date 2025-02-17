import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';
import 'add_article_page.dart';
import 'main.dart';
import 'objectbox.g.dart'; // Generated file by ObjectBox

class ArticleListScreen extends StatefulWidget {
  @override
  _ArticleListScreenState createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> {
  List<Article> articles = [];
  late Box<Article> articleBox;

  @override
  void initState() {
    super.initState();
    _initializeObjectBox();
  }

  Future<void> _initializeObjectBox() async {
    articleBox = store.box<Article>();
    loadArticles();
  }

  void loadArticles() {
    setState(() {
      articles = articleBox.getAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RW NEWS'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddArticleScreen()),
            ).then((_) => loadArticles()),
          ),
        ],
      ),
      body: articles.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Chưa có bài viết nào, hãy thêm bài viết tại đây'),
                  ElevatedButton(
                    child: Text('Thêm bài viết'),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddArticleScreen()),
                    ).then((_) => loadArticles()),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return Card(
                  child: ListTile(
                    leading: Image.asset(article.imagePath,
                        width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(article.title),
                    subtitle: Text(
                        '${article.source} - ${DateFormat('dd/MM/yyyy HH:mm').format(article.publishDate)}'),
                  ),
                );
              },
            ),
    );
  }
}
