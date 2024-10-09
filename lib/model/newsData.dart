class NewsData {
  String newsUpdate;
  String newsTime;
  String postedBy;

  NewsData({required this.newsUpdate, required this.newsTime, required this.postedBy});

  void setUserData(NewsData newdata) {
    newsUpdate = newdata.newsUpdate;
    newsTime = newdata.newsTime;
    postedBy = newdata.postedBy;
  }
}