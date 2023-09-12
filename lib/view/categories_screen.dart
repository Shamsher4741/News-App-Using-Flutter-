import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/categories_news_model.dart';

import '../view_model/news_view_model.dart';
import 'home_screen.dart';


class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  NewsViewModel newsViewModel = NewsViewModel();


  final format = DateFormat('MM dd, yyyy');
  String category = 'General';

  List<String> categoriesList =[
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology'
  ];

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,

                itemCount: categoriesList.length,
                  itemBuilder: (context, index){
                  return InkWell(
                    onTap: (){
                      category = categoriesList[index];
                      setState(() {

                      });

                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: category == categoriesList[index] ? Colors.blue : Colors.grey,
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Center(
                              child: Text(categoriesList[index].toString())),
                        ),
                      ),
                    ),
                  );
                  }),
            ),
            const SizedBox(height: 20,),
            Expanded(
              child:
              FutureBuilder<CategoriesNews>(
                future: newsViewModel.fetchCategoryNewsApi(category),
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
                    //    scrollDirection: Axis.vertical,
                        itemCount: snapshot.data!.articles?.length,
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
      ),

    );
  }
}
