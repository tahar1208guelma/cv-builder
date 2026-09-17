import 'package:uuid/uuid.dart';

class Publication {
  final String id;
  final String title;
  final String authors;
  final String publisher; // Journal or Publisher
  final String date;
  final String url; // DOI or URL

  Publication({
    String? id,
    this.title = '',
    this.authors = '',
    this.publisher = '',
    this.date = '',
    this.url = '',
  }) : id = id ?? const Uuid().v4();

  Publication copyWith({
    String? id,
    String? title,
    String? authors,
    String? publisher,
    String? date,
    String? url,
  }) {
    return Publication(
      id: id ?? this.id,
      title: title ?? this.title,
      authors: authors ?? this.authors,
      publisher: publisher ?? this.publisher,
      date: date ?? this.date,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'authors': authors,
      'publisher': publisher,
      'date': date,
      'url': url,
    };
  }

  factory Publication.fromJson(Map<String, dynamic> json) {
    return Publication(
      id: json['id'] as String?,
      title: json['title'] as String? ?? '',
      authors: json['authors'] as String? ?? '',
      publisher: json['publisher'] as String? ?? '',
      date: json['date'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }
}
