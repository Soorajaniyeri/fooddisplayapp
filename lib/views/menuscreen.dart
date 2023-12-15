import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodmanagement/views/fooddetails.dart';
import 'package:http/http.dart';

import '../models/Slidermodel.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<SliderClass> getData() async {
      Response res = await get(
          Uri.parse("https://www.themealdb.com/api/json/v1/1/search.php?f=b"));

      if (res.statusCode == 200) {
        var body = SliderClass.fromJson(jsonDecode(res.body));
        return body;
      } else {
        return throw "";
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Menu",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: snapshot.data!.meals!.length,
                itemBuilder: (context, index) {
                  Meals meals = snapshot.data!.meals![index];

                  return InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return FoodDetails(meal: meals);
                        },
                      ));
                    },
                    child: Card(
                      color: Colors.blue.shade100,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          CircleAvatar(
                            radius: 43,
                            backgroundColor: Colors.blue,
                            child: CircleAvatar(
                                radius: 40,
                                backgroundImage:
                                    NetworkImage(meals.strMealThumb!)),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(meals.strMeal!)
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const SizedBox();
            }
          }),
    );
  }
}
