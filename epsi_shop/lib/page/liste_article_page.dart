import 'package:epsi_shop/article.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:epsi_shop/cart.dart';

class ListeArticlePage extends StatelessWidget {
  const ListeArticlePage({super.key});

  @override
  Widget build(BuildContext context) {
    // fscaff - je le mets là car tu es bête
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('EPSI Shop'),
          actions: [
            IconButton(
              onPressed: () => context.go("/cart"),
              icon: Badge(
                label: Text(context.watch<Cart>().getAll().length.toString()),
                child: const Icon(Icons.shopping_cart),
              ),
            )
          ],
        ),
        body: FutureBuilder<List<Article>>(
          future: fetchListArticle(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return ListArticles(
                listArticle: snapshot.data!,
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return const CircularProgressIndicator();
            }
          },
        ));
  }

  Future<List<Article>> fetchListArticle() async {
    final res = await get(Uri.parse('https://fakestoreapi.com/products'));
    if (res.statusCode == 200) {
      print(" Réponse ${res.body}");
      final listMapArticles = jsonDecode(res.body) as List<dynamic>;
      return listMapArticles
          .map((e) => Article(
                e['title'],
                e['description'],
                e['price'],
                e['image'],
                e['category'],
              ))
          .toList();
    }
    return <Article>[];
  }
}

class ListArticles extends StatelessWidget {
  final List<Article> listArticle;
  const ListArticles({super.key, required this.listArticle});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: listArticle.length,
        itemBuilder: (ctx, index) => ListTile(
              onTap: () => ctx.go("/detail", extra: listArticle[index]),
              leading: Image.network(
                listArticle[index].image,
                height: 80,
                width: 80,
              ),
              title: Text(listArticle[index].title),
            ));
  }
}
