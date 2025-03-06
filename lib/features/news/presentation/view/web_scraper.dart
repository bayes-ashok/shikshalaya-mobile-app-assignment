import 'package:dio/dio.dart';
import 'package:html/parser.dart'; // For parsing HTML
import 'package:html/dom.dart'; // For manipulating HTML DOM

class WebScraper {
  final Dio dio = Dio();

  Future<List<Map<String, String>>> scrapeLinks(String url) async {
    try {
      Response response = await dio.get(url);
      var document = parse(response.data);

      // Extract all <a> tags inside the list
      List<Element> links = document.querySelectorAll('ul.uk-list a');

      List<Map<String, String>> extractedData = [];
      for (var link in links) {
        String name = link.text.trim();
        String href = link.attributes['href'] ?? '#';

        // Convert relative URL to absolute URL
        if (!href.startsWith("http")) {
          href = "https://psc.gov.np$href";
        }

        extractedData.add({'name': name, 'url': href});
      }

      return extractedData;
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }
}
