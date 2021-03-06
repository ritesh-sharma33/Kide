import 'package:Kide/pages/HomePage/widgets/PostCard.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostsPage extends StatefulWidget {
  final String postType;
  PostsPage({this.postType});

  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage>
    with AutomaticKeepAliveClientMixin<PostsPage> {
  Firestore firestore = Firestore.instance;
  List<DocumentSnapshot> posts = [];
  bool isLoading = false;
  bool hasMore = true;
  int documentLimit = 5;
  DocumentSnapshot lastDocument;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    fetchPosts();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        fetchPosts();
      }
    });
    super.initState();
  }

  Future<void> fetchPosts() async {
    if (!hasMore) {
      print("No more posts");
      return;
    }
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    QuerySnapshot querySnapshot;
    if (lastDocument == null) {
      querySnapshot = await firestore
          .collection('${widget.postType}')
          .orderBy('date')
          .limit(documentLimit)
          .getDocuments();
    } else {
      querySnapshot = await firestore
          .collection('${widget.postType}')
          .orderBy('date')
          .startAfterDocument(lastDocument)
          .limit(documentLimit)
          .getDocuments();
      print("Success");
    }
    if (querySnapshot.documents.length < documentLimit) {
      hasMore = false;
    }

    lastDocument = querySnapshot.documents[querySnapshot.documents.length - 1];
    posts.addAll(querySnapshot.documents);
    setState(() {
      isLoading = false;
    });
  }

  @override
  get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
            child: posts.length == 0
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: posts.length,
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          return PostCard(
                              postType: widget.postType,
                              id: posts[index].data['id'],
                              title: posts[index].data['title'],
                              subtitle: posts[index].data['subtitle'],
                              image: posts[index].data['imageUrl'],
                              body: posts[index].data['body'],
                              date: posts[index].data['date'],
                              likes: posts[index].data['likes'].toString(),
                              views: posts[index].data['views'].toString());
                        }),
                    onRefresh: fetchPosts)),
      ],
    );
  }
}
