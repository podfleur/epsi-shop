class Article {
  final String title;
  final String description;
  final num prix;
  final String image;
  final String categorie;

  Article(this.title, this.description, this.prix, this.image, this.categorie);
  String prixEuro() => '$prix €';
}