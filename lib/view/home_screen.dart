import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/news_channels_headlines_model.dart';
import 'package:news_app/view/categories_screen.dart';
import 'package:news_app/view_model/news_view_model.dart';

import '../models/categories_news_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList{bbcNews, aryNews, independent, jazeera, cnn}

class _HomeScreenState extends State<HomeScreen> {

NewsViewModel newsViewModel = NewsViewModel();
FilterList? selectedMenu;

final format = DateFormat('MM dd, yyyy');
String name = 'bbc-news';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoryScreen()));
          },
          icon: Image.asset('images/category_icon.png',
          height: 30,
          width: 30,),
        ),
        title:  Text('News', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),),
        centerTitle: true,
        actions: [
          PopupMenuButton<FilterList>(
            initialValue: selectedMenu,
              icon: const Icon(Icons.more_vert, color: Colors.black),
              onSelected: (FilterList item){

              if(FilterList.bbcNews.name == item.name){
                name = 'bbc-news';
              }
              if(FilterList.aryNews.name == item.name){
                name = 'ary-news';
              }
              if(FilterList.independent.name == item.name){
                name = 'independent';
              }
              if(FilterList.jazeera.name == item.name){
                name = 'al-jazeera-english';
              }
              if(FilterList.cnn.name == item.name){
                name = 'cnn';
              }
              //newsViewModel.fetchNewsChannelHeadlinesApi();
              setState(() {
                selectedMenu = item;

              });

              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterList>> [
                 const PopupMenuItem<FilterList>(
                  value:FilterList.bbcNews,
                  child:Text('BBC News'),
                ),
                const PopupMenuItem<FilterList>(
                  value:FilterList.aryNews,
                  child:Text('Ary News'),
                ),
                const PopupMenuItem<FilterList>(
                  value:FilterList.independent,
                  child:Text('Independant News'),
                ),
                const PopupMenuItem<FilterList>(
                  value:FilterList.jazeera,
                  child:Text('Al jazeera English News'),
                ),
                const PopupMenuItem<FilterList>(
                  value:FilterList.cnn,
                  child:Text('CNN News'),
                )

              ]),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height * .55,
            width: width,
              child: FutureBuilder<NewsChannelsHeadlinesModel>(
                future: newsViewModel.fetchNewsChannelHeadlinesApi(),
                builder: (BuildContext context, snapshot ){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(
                      child: SpinKitCircle(
                        size: 50,
                        color: Colors.blue,
                      ),
                    );

                  }else{
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.articles?.length,
                        itemBuilder: (context, index){
                        DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                          return SizedBox(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: height * 0.6,
                                  width: width * .9,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: height * .02
                                  ),

                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),

                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                      fit: BoxFit.cover,
                                      placeholder:(context, url) => Container( child:spinKit2),
                                      errorWidget: (context, url, error) => const Icon(Icons.error_outline, color: Colors.red,),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  child: Card(
                                    elevation: 5,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),

                                    ),
                                    child: Container(
                                    alignment: Alignment.bottomCenter,
                                    padding: const EdgeInsets.all(15),
                                    height: height * .22,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: width * 0.7,
                                          child:
                                          Text(snapshot.data!.articles![index].title.toString(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.bold ),),
                                        ),
                                        const Spacer(
                                        ),
                                         Container(
                                          width: width * 0.7,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(snapshot.data!.articles![index].source!.name.toString(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(fontSize: 13,fontWeight: FontWeight.w600 ),),
                                              Text(format.format(dateTime),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.w500 ),),

                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ),
                                )
                              ],
                            ),

                          );
                        });


                  }

                },
              ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder<CategoriesNews>(
              future: newsViewModel.fetchCategoryNewsApi('General'),
              builder: (BuildContext context, snapshot ){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(
                    child: SpinKitCircle(
                      size: 50,
                      color: Colors.blue,
                    ),
                  );

                }else{
                  return ListView.builder(

                      itemCount: snapshot.data!.articles?.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index){
                        DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                        return Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),

                              child: CachedNetworkImage(
                                imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                fit: BoxFit.cover,
                                height: height * .18,
                                width: width * .3,
                                placeholder:(context, url) => Container( child:const Center(
                                  child: SpinKitCircle(
                                    size: 50,
                                    color: Colors.blue,
                                  ),
                                ),),
                                errorWidget: (context, url, error) => const Icon(Icons.error_outline, color: Colors.red,),
                              ),
                            ),
                            Expanded(
                                child: Container(
                                  height: height * .18,
                                  padding: const EdgeInsets.only(left:15),
                                  child: Column(
                                    children: [
                                      Text(snapshot.data!.articles![index].title.toString(),
                                        maxLines: 3,
                                        style: GoogleFonts.poppins(
                                            fontSize:  15, color: Colors.black54,
                                            fontWeight: FontWeight.w700

                                        ),),
                                      const Spacer(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [

                                          Text(snapshot.data!.articles![index].source!.name.toString(),
                                            style: GoogleFonts.poppins(
                                                fontSize:  14, color: Colors.black54,
                                                fontWeight: FontWeight.w600

                                            ),),
                                          Text(format.format(dateTime),
                                            style: GoogleFonts.poppins(
                                                fontSize:  15,
                                                fontWeight: FontWeight.w500

                                            ),),

                                        ],
                                      )

                                    ],
                                  ),

                                ))
                          ],

                        );
                      });


                }

              },
            ),
          ),
        ],
      ),
    );
  }

}
const spinKit2 = SpinKitCircle(
  color: Colors.amber,
  size: 50,
);
