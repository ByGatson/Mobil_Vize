import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kütüphane Otomasyon',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 58, 183, 62)),
        useMaterial3: true,
      ),
      home: const BookList(),
    );
  }
}

class BookList extends StatefulWidget {
  const BookList({super.key});

  @override
  State<BookList> createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "BERKAY COŞGUN 02225076405",
          style: TextStyle(color: Color.fromARGB(255, 199, 199, 199)),
        ),
        backgroundColor: Colors.purple,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 30),
            child: Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: FirestoreOperations().getBook(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Map<String, dynamic>> books = snapshot.data ?? [];

          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              String bookName = books[index]['bookName'];
              String authorInfo =
                  'Yazar: ${books[index]['author'] ?? ''}, Sayfa Sayısı: ${books[index]['sayfaSayisi'] ?? ''}';

              return KitapCard(
                title: bookName,
                subtitle: authorInfo,
                documentId: books[index]['documentId'],
                onDelete: () {
                  setState(() {
                    books.removeAt(index);
                  });
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddBook(
                      documentId: '',
                    )),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Kitaplar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Satın Al',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ayarlar',
          ),
        ],
        selectedItemColor: Colors.purple,
        onTap: (index) {},
      ),
    );
  }
}

class AddBook extends StatefulWidget {
  const AddBook({Key? key, required this.documentId}) : super(key: key);

  final String documentId;

  @override
  // ignore: library_private_types_in_public_api
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  var bookName = TextEditingController();
  var publisherName = TextEditingController();
  var author = TextEditingController();
  var category = "Hikaye";
  var numberOfPage = TextEditingController();
  var publishedYear = TextEditingController();
  var isPublish = false;

  @override
  void initState() {
    super.initState();

    // widget.documentId null değilse, mevcut veriyi yükle
    if (widget.documentId.isNotEmpty) {
      FirestoreOperations()
          .updateData(
        documentId: widget.documentId,
        bookName: bookName.text,
        publisherName: publisherName.text,
        author: author.text,
        category: category,
        pageNumber: numberOfPage.text,
        publishedYear: publishedYear.text,
        isPublish: isPublish,
      )
          .then((_) {
        if (kDebugMode) {
          print('Book update operation is successfully');
        }
      }).catchError((error) {
        if (kDebugMode) {
          print('Exception: $error');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var ekranBilgi = MediaQuery.of(context);
    final double ekranGenislik = ekranBilgi.size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kitap Ekle"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextField(
                controller: bookName,
                decoration: const InputDecoration(
                  hintText: "Kitap Adı",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextField(
                controller: publisherName,
                decoration: const InputDecoration(
                  hintText: "Yayın Evi",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextField(
                controller: author,
                decoration: const InputDecoration(
                  hintText: "Yazarlar",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextField(
                controller: numberOfPage,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Sayfa Sayısı",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextField(
                controller: publishedYear,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Basım Yılı",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Listede yayınlanacak mı?",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: Checkbox(
                      value: isPublish,
                      onChanged: (value) {
                        setState(() {
                          isPublish = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: ekranGenislik - 150),
              child: ElevatedButton(
                onPressed: () {
                  if (widget.documentId.isNotEmpty) {
                    // documentId mevcut ise güncelleme yap
                    FirestoreOperations()
                        .updateData(
                      documentId: widget.documentId,
                      bookName: bookName.text,
                      publisherName: publisherName.text,
                      author: author.text,
                      category: category,
                      pageNumber: numberOfPage.text,
                      publishedYear: publishedYear.text,
                      isPublish: isPublish,
                    )
                        .then((_) {
                      if (kDebugMode) {
                        print('The book update operation is successfully');
                      }
                      // Clear text controllers and pop context after successful update
                      bookName.clear();
                      publisherName.clear();
                      author.clear();
                      numberOfPage.clear();
                      publishedYear.clear();
                    }).catchError((error) {
                      if (kDebugMode) {
                        print('Exception: $error');
                      }
                      // Handle the error (e.g., show a snackbar or alert dialog)
                    });
                    Navigator.pop(context);
                  } else {
                    // documentId yoksa yeni kitap ekle
                    FirestoreOperations()
                        .firebaseAdd(
                      bookName: bookName.text,
                      publisherName: publisherName.text,
                      author: author.text,
                      category: category,
                      pageNumber: numberOfPage.text,
                      publishedYear: publishedYear.text,
                      isPublish: isPublish,
                    )
                        .then((_) {
                      if (kDebugMode) {
                        print('The book is add successfully.');
                      }
                      // Clear text controllers and pop context after successful addition
                      bookName.clear();
                      publisherName.clear();
                      author.clear();
                      numberOfPage.clear();
                      publishedYear.clear();
                    }).catchError((error) {
                      if (kDebugMode) {
                        print('Exception: $error');
                      }
                      // Handle the error (e.g., show a snackbar or alert dialog)
                    });
                    Navigator.pop(context);
                  }
                },
                child: Text("Kaydet"),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                    const Size(130, 45),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KitapCard extends StatefulWidget {
  const KitapCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.documentId,
    required this.onDelete,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String documentId;
  final Function onDelete;

  @override
  State<KitapCard> createState() => _BookCardState();
}

class _BookCardState extends State<KitapCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.title),
        subtitle: Text(widget.subtitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                if (kDebugMode) {
                  print(widget.documentId);
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddBook(documentId: widget.documentId),
                  ),
                );
              },
              child: Icon(Icons.edit),
            ),
            SizedBox(width: 20.0),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              //Herhangi bir işlem yapılmasına gerek yok
                              Navigator.of(context).pop();
                            },
                            child: Text("Hayır")),
                        ElevatedButton(
                            onPressed: () {
                              _deleteBook(widget.documentId);
                              Navigator.of(context).pop();
                            },
                            child: Text("Evet"))
                      ],
                      title: const Text("Silme İşlemi"),
                      contentPadding: const EdgeInsets.all(20.0),
                      content: const Text(
                          "Bu kitap kaydını silmek istediğinize eminmisiniz?")),
                );
              },
              child: Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteBook(String documentId) async {
    try {
      await FirestoreOperations().dataDelete(documentId);
      widget.onDelete();
      if (kDebugMode) {
        print('The book is successfully deleted');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception: $e');
      }
      // Handle the error (e.g., show a snackbar or alert dialog)
    }
  }
}

class FirestoreOperations {
  final CollectionReference books =
      FirebaseFirestore.instance.collection('books');

  Stream<List<Map<String, dynamic>>> getBook() {
    return books
        .where('isPublish', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'documentId': doc.id,
          'bookName': doc['bookName'] ?? '',
          'author': doc['author'] ?? '',
          'pageNumber': doc['pageNumber'] ?? 0,
        };
      }).toList();
    });
  }

  Future<void> firebaseAdd({
    required String bookName,
    required String publisherName,
    required String author,
    required String category,
    required String pageNumber,
    required String publishedYear,
    required bool isPublish,
  }) async {
    Map<String, dynamic> addData = {
      'bookName': bookName,
      'publisherName': publisherName,
      'author': author,
      'category': category,
      'pageNumber': int.parse(pageNumber),
      'publishedYear': int.parse(publishedYear),
      'isPublish': isPublish,
    };

    await books.add(addData);
  }

  Future<void> updateData({
    required String documentId,
    required String bookName,
    required String publisherName,
    required String author,
    required String category,
    required String pageNumber,
    required String publishedYear,
    required bool isPublish,
  }) async {
    if (documentId.isEmpty) {
      if (kDebugMode) {
        print('Error: DocumentId is empty.');
      }
      return;
    }

    await books.doc(documentId).update({
      'bookName': bookName,
      'publisherName': publisherName,
      'author': author,
      'category': category,
      'pageNumber': pageNumber,
      'publishedYear': publishedYear,
      'isPublish': isPublish,
    });
  }

  Future<void> dataDelete(String documentId) async {
    try {
      if (documentId.isNotEmpty) {
        await books.doc(documentId).delete();
        if (kDebugMode) {
          print('delete operation is successfully.');
        }
      } else {
        if (kDebugMode) {
          print('Exception -> Document id cannot be null.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception: $e');
      }
      // Handle the error (e.g., show a snackbar or alert dialog)
    }
  }
}
