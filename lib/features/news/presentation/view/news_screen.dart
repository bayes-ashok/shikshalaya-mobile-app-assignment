import 'package:flutter/material.dart';
import 'package:shikshalaya/features/news/presentation/view/pdf_viewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'web_scraper.dart';

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

  void openLink(String url) {
    if (url.endsWith('.pdf')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PDFViewerPage(url: url, title: "PDF Viewer")),
      );
    } else {
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Web Scraper"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFf0faff),
              Color(0xFFe6f7ff),
            ],
          ),
        ),
        child: Column(
          children: [
            // Catchy and unique message section with justified content
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "🚨 Attention! 🚨",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Below are the latest updates and news from the PSC (Public Service Commission). Stay informed about the latest announcements, job openings, and more!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.justify, // Justifying the content
                  ),
                ],
              ),
            ),
            // Pagination content area
            Expanded(
              child: PagingListener(
                controller: _pagingController,
                builder: (context, state, fetchNextPage) => PagedListView<int, Map<String, String>>(
                  state: state,
                  fetchNextPage: fetchNextPage,
                  builderDelegate: PagedChildBuilderDelegate<Map<String, String>>(
                    itemBuilder: (context, item, index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: Card(
                        elevation: 10,
                        shadowColor: Colors.grey.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: GestureDetector(
                          onTap: () => openLink(item['url'] ?? ""),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              item['name'] ?? "No Name",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.justify, // Justifying card content as well
                            ),
                          ),
                        ),
                      ),
                    ),
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
