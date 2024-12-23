import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:epsi_shop/cart.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Cart>();
    final articles = cart.getAll();
    final prixTVA = articles.fold<num>(
      0,
      (sum, article) => sum + (article.prix * 1.2),
    );

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: articles.isEmpty
                ? _buildEmptyCartMessage()
                : _buildArticlesList(articles, context),
          ),
          _buildSummarySection(context, articles, prixTVA, cart),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Panier"),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    );
  }

  Widget _buildEmptyCartMessage() {
    return const Center(
      child: Text("Vous n'avez rien dans votre panier."),
    );
  }

  Widget _buildArticlesList(List articles, BuildContext context) {
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return ListTile(
          leading: _buildArticleImage(article),
          title: Text(article.title),
          subtitle: Text(article.prixEuro()),
          trailing: _buildArticleActions(context, article),
        );
      },
    );
  }

  Widget _buildArticleImage(article) {
    return Image.network(
      article.image,
      height: 60,
      width: 60,
      fit: BoxFit.cover,
    );
  }

  Widget _buildArticleActions(BuildContext context, article) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () => context.read<Cart>().add(article),
        ),
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: () => context.read<Cart>().remove(article),
        ),
      ],
    );
  }

  Widget _buildSummarySection(BuildContext context, List articles, num prixTVA, Cart cart) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Nombre d'articles : ${articles.length}",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            "Total : ${prixTVA.toStringAsFixed(2)} €",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          if (articles.isNotEmpty) ...[
            const SizedBox(height: 16.0),
            _buildPaymentButton(context, cart),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentButton(BuildContext context, Cart cart) {
    return ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Paiement en cours de traitement...")),
        );
        cart.clear();
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        backgroundColor: Theme.of(context).colorScheme.primary,
        minimumSize: const Size.fromHeight(50),
      ),
      child: const Text(
        "Procéder au paiement",
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}
