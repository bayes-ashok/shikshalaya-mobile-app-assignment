import 'package:flutter/material.dart';
import 'package:shikshalaya/features/news/presentation/view/pdf_viewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'web_scraper.dart';
import 'package:shimmer/shimmer.dart';

class ScraperPage extends StatefulWidget {
  @override
  _ScraperPageState createState() => _ScraperPageState();
}

class _ScraperPageState extends State<ScraperPage> {
  final WebScraper scraper = WebScraper();
  static const int pageSize = 10; // Number of items per page

  late final PagingController<int, Map<String, String>> _pagingController = PagingController(
    getNextPageKey: (state) => (state.keys?.last ?? 0) + 1,
    fetchPage: (pageKey) => fetchData(pageKey),
  );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<List<Map<String, String>>> fetchData(int pageKey) async {
    try {
      List<Map<String, String>> data = await scraper.scrapeLinks('https://psc.gov.np/');

      // Determine if it's the last page
      final isLastPage = (pageKey + pageSize) >= data.length;
      final newItems = data.sublist(pageKey, isLastPage ? data.length : pageKey + pageSize);

      return newItems;
    } catch (error) {
      return Future.error(error);
    }
  }

  void openLink(String url, String title) {
    if (url.endsWith('.pdf')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PDFViewerPage(url: url, title: title)),
      );
    } else {
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildShimmerLoader() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Web Scraper"),
        centerTitle: true,
        elevation: 0,
      ),
      body: PagingListener(
        controller: _pagingController,
        builder: (context, state, fetchNextPage) => PagedListView<int, Map<String, String>>(
          state: state,
          fetchNextPage: fetchNextPage,
          builderDelegate: PagedChildBuilderDelegate<Map<String, String>>(
            itemBuilder: (context, item, index) => Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item['name'] ?? "No Name",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey[600]),
                onTap: () => openLink(item['url'] ?? "", item['name'] ?? "Document"),
              ),

            ),
          ),
        ),
      ),
    );
  }
}
