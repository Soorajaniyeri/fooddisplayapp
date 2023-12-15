import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:foodmanagement/models/Slidermodel.dart';
import 'package:foodmanagement/models/catagoriesmodel.dart';
import 'package:http/http.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  Future<SliderClass> getData() async {
    Response res = await get(
        Uri.parse("https://www.themealdb.com/api/json/v1/1/search.php?f=b"));

    if (res.statusCode == 200) {
      var body = SliderClass.fromJson(jsonDecode(res.body));
      print(body);
      return body;
    } else {
      return throw "";
    }
  }

  Future<CatagorieClass> getCat() async {
    Response res = await get(
        Uri.parse("https://www.themealdb.com/api/json/v1/1/categories.php"));

    if (res.statusCode == 200) {
      var body = CatagorieClass.fromJson(jsonDecode(res.body));
      print(body);
      return body;
    } else {
      return throw "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text("Home Page",style: TextStyle(color: Colors.white),),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 10,
          ),
          const Center(
              child: Text(
            "Todays Meals",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          FutureBuilder(
            future: getData(),
            builder: (context, AsyncSnapshot<SliderClass> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                return CarouselSlider.builder(
                    itemCount: 10,
                    itemBuilder: (context, index, realIndex) {
                      Meals meals = snapshot.data!.meals![index];

                      return Card(
                        child: Column(
                          children: [
                            Container(
                              height: 150,
                              width: 450,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image:
                                          NetworkImage(meals.strMealThumb!))),
                            ),
                            Center(child: Center(child: Text(meals.strMeal!)))
                          ],
                        ),
                      );
                    },
                    options: CarouselOptions(
                      disableCenter: true,
                      autoPlay: true,
                    ));
              } else {
                return const SizedBox();
              }
            },
          ),
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Text(
              "Popular Categories",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          SizedBox(
            height: 300,
            child: FutureBuilder(
              future: getCat(),
              builder: (context, AsyncSnapshot<CatagorieClass> snapshot) {

                if(snapshot.connectionState==ConnectionState.waiting){

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData) {
                  return GridView.builder(
                    itemCount: snapshot.data!.categories!.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      Categories ctList = snapshot.data!.categories![index];
                      return Card(
                        child: Column(
                          children: [
                            Image(
                              image: NetworkImage(ctList.strCategoryThumb!),
                            ),
                            Text(ctList.strCategory!)
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
