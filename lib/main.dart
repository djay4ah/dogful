import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(home: mainApp()));
}

class mainApp extends StatefulWidget {

  mainApp({super.key});

  @override
  State<mainApp> createState() => _mainAppState();
}

class _mainAppState extends State<mainApp> {
  final DoneSnackBar = SnackBar(content: Text('Saved!', style: TextStyle(fontSize: 35, fontFamily: 'Koulen', color: Colors.black),), backgroundColor: Colors.white, duration: Duration(seconds: 1),);
  final RemoveSnackBar = SnackBar(content: Text('Removed :(', style: TextStyle(fontSize: 35, fontFamily: 'Koulen', color: Colors.black),), backgroundColor: Colors.white, duration: Duration(seconds: 1));
  final ProblemSnackBar = SnackBar(content: Text('Error. Check your internet connection, and try again', style: TextStyle(fontSize: 25, fontFamily: 'Koulen', color: Colors.black),), backgroundColor: Colors.white, duration: Duration(seconds: 1));
  final _controller = ScrollController();
  dynamic dogUrl = 'https://cdn.britannica.com/34/233234-050-1649BFA9/Pug-dog.jpg';
  var dogList = ['https://cdn.britannica.com/34/233234-050-1649BFA9/Pug-dog.jpg',
    'https://static.wikia.nocookie.net/doge/images/e/e6/Pomeranskiy_shpits_04.jpg/revision/latest/scale-to-width-down/1200?cb=20180329162137&path-prefix=ru',
    'https://www.dogeat.ru/img/blog/chihuahua.jpg'];
  var breeds = ['Pug', 'Spitz', 'Chihuaua'];
  var savedDogs = [];
  var savedBreeds = [];
  void initState() {
    super.initState();
    _controller.addListener(() {
      var maxScrollExtent = _controller.position.maxScrollExtent;
      var scrolledPixels = _controller.position.pixels;
      if (scrolledPixels == maxScrollExtent) {
        setState(() {
            try {
              http.get(Uri.parse('https://dog.ceo/api/breeds/image/random')).then((response) {
                dynamic newUrl = jsonDecode(response.body)['message'];
                List<String> splitUrl = newUrl.split('/');
                dynamic breed = splitUrl[splitUrl.length - 2];
                dogList.add(newUrl);
                breeds.add(breed.toString());
              });
            } catch (error) {
              ScaffoldMessenger.of(context).showSnackBar(ProblemSnackBar);
            }
        });
      }
    });
  }

  void _menuOpen() {
    debugPrint(savedDogs.toString());
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return Scaffold(
            backgroundColor: Color(0xffd9d9d9),
            appBar: AppBar(
              backgroundColor: Color(0xffd9d9d9),
              title: const Text('SAVED DOGS', style: TextStyle(
                fontFamily: 'Koulen',
                fontSize: 50
              ),),
              centerTitle: true,
          ),
          body: ListView.builder(
              itemCount: savedDogs.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 275,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${savedBreeds[index]}', style: TextStyle(fontFamily: 'Koulen', fontSize: 35),),
                          IconButton(onPressed: (){
                            if (this.mounted) {
                              setState(() {
                                savedDogs.removeAt(index);
                                savedBreeds.removeAt(index);
                                Navigator.popUntil(context, ModalRoute.withName('/'));
                                _menuOpen();
                                ScaffoldMessenger.of(context).showSnackBar(RemoveSnackBar);
                              });
                            }
                          }, icon: Icon(Icons.bookmark_remove, size: 50,))
                        ],
                      ),
                      Container(
                        height: 200,
                        width: 300,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image(
                              image: NetworkImage(savedDogs[index]),
                              fit: BoxFit.cover
                          ),
                      ),
                      )],
                  ),
                );
              }
          ),
        );
      })
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffd9d9d9),
        appBar: AppBar(
          backgroundColor: Color(0xffd9d9d9),
          title: const Text('DOGFUL', style: TextStyle(
            fontFamily: 'Koulen',
            fontSize: 50
            ),
          ),
          actions: [
            IconButton(onPressed: _menuOpen, icon: Icon(Icons.bookmark, size: 35,))
          ],
          centerTitle: true,
        ),
        body: ListView.builder(
          controller: _controller,
          itemCount: dogList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 275,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${breeds[index]}', style: TextStyle(fontFamily: 'Koulen', fontSize: 35),),
                      IconButton(onPressed: (){
                        setState(() {
                          savedDogs.add(dogList[index]);
                          savedBreeds.add(breeds[index]);
                          ScaffoldMessenger.of(context).showSnackBar(DoneSnackBar);
                        });
                      }, icon: Icon(Icons.bookmark_border, size: 50,))
                    ],
                  ),
                  Container(
                    height: 200,
                    width: 300,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image(
                          image: NetworkImage(dogList[index]),
                          fit: BoxFit.cover
                      ),
                    )
                  ),
                ],
              ),
            );
          }
        ),
      );
  }
}
