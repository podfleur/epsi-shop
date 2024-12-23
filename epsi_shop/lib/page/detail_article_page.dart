import 'package:flutter/material.dart';
import 'package:epsi_shop/article.dart';
import 'package:provider/provider.dart';
import 'package:epsi_shop/cart.dart';
import 'package:go_router/go_router.dart';

class DetailArticlePage extends StatelessWidget {
  const DetailArticlePage({super.key, required this.article});
  final Article article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(article.title),
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
      body: Column(
        children: [
          Image.network(
            article.image,
            height: 400,
            width: MediaQuery.of(context).size.width,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  article.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  article.prixEuro(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 12.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Catégorie: ${article.categorie}"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              article.description,
              textAlign: TextAlign.start,
            ),
          ),
          OutlinedButton(
            onPressed: () {
              context.read<Cart>().add(article);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Article ajouté au panier !")),
              );
            },
            child: const Text("Ajouter au panier"),
          ),
          FutureBuilder(
            future: wait5S(),
            builder: (ctx, snapshot) {
              if (snapshot.hasData) {
                return Text("Données téléchargées : ${snapshot.data}");
              }
              return const CircularProgressIndicator();
            },
          )
        ],
      ),
    );
  }

  Future<bool> wait5S() async {
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }
}
