import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikshalaya/app/di/di.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entity/news_entity.dart';
import '../view_model/news_bloc.dart';

class NewsScreenPage extends StatefulWidget {
  @override
  _NewsScreenPage createState() => _NewsScreenPage();
}

class _NewsScreenPage extends State<NewsScreenPage> {
  @override
  void initState() {
    super.initState();
    getIt<NewsBloc>().add(FetchNewsEvent()); // ✅ Dispatch event using getIt
  }

  void openLink(String url) {
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
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
      appBar: AppBar(title: Text("Latest News")),
      body: BlocBuilder<NewsBloc, NewsState>(
        bloc: getIt<NewsBloc>(), // ✅ Use getIt to provide BLoC instance
        builder: (context, state) {
          if (state is NewsLoading) {
            return _buildShimmerLoader();
          } else if (state is NewsLoaded) {
            return ListView.builder(
              itemCount: state.newsList.length,
              itemBuilder: (context, index) {
                NewsEntity news = state.newsList[index];
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          news.title,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => openLink(news.url),
                          child: Text(
                            "Read More",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is NewsError) {
            return Center(child: Text(state.message, style: TextStyle(color: Colors.red)));
          }
          return Container();
        },
      ),
    );
  }
}
