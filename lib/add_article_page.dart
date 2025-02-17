import 'dart:io'; // Import thêm thư viện dart:io
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:objectbox/objectbox.dart';
import 'objectbox.g.dart'; // Generated file by ObjectBox
import 'main.dart';

@Entity()
class Article {
  @Id(assignable: true)
  int id;
  String title;
  String source;
  DateTime publishDate;
  String imagePath;

  Article({
    this.id = 0,
    required this.title,
    required this.source,
    required this.publishDate,
    required this.imagePath,
  });
}

class AddArticleScreen extends StatefulWidget {
  @override
  _AddArticleScreenState createState() => _AddArticleScreenState();
}

class _AddArticleScreenState extends State<AddArticleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _sourceController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _imagePath;
  late Box<Article> _articleBox;

  @override
  void initState() {
    super.initState();
    _initializeObjectBox();
  }

  Future<void> _initializeObjectBox() async {
    _articleBox = store.box<Article>();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = DateTime(picked.year, picked.month, picked.day,
            _selectedDate.hour, _selectedDate.minute);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = DateTime(_selectedDate.year, _selectedDate.month,
            _selectedDate.day, picked.hour, picked.minute);
      });
    }
  }

  Future<void> _getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Article')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Tiêu đề',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Vui lòng nhập tiêu đề' : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _sourceController,
              decoration: InputDecoration(
                labelText: 'Nguồn',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Vui lòng nhập nguồn' : null,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                      'Thời gian: ${DateFormat('dd/MM/yyyy HH:mm').format(_selectedDate)}'),
                ),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Chọn ngày'),
                ),
                TextButton(
                  onPressed: () => _selectTime(context),
                  child: Text('Chọn giờ'),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getImage,
              child: Text('Chọn ảnh'),
            ),
            if (_imagePath != null) ...[
              SizedBox(height: 16),
              Image.file(File(_imagePath!), height: 200),
            ],
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate() && _imagePath != null) {
                  final article = Article(
                    title: _titleController.text,
                    source: _sourceController.text,
                    publishDate: _selectedDate,
                    imagePath: _imagePath!,
                  );

                  _articleBox.put(article);
                  Navigator.pop(context);
                } else if (_imagePath == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Vui lòng chọn ảnh cho bài viết')),
                  );
                }
              },
              child: Text('Lưu bài viết'),
            ),
          ],
        ),
      ),
    );
  }
}
