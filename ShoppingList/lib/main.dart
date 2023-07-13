import 'dart:async';
import 'package:flutter/material.dart';

final List<ShoppingListItem> listFav = [];

void main() => runApp(const Shopping());

class Shopping extends StatelessWidget{
  const Shopping({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context){
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Shopping List",
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomePage(),
        '/shoppingList': (context) => const ShoppingList(),
        '/favorite' : (context) =>   FavoriteList(favList:  listFav),
      },
    );
  }
}

class FavoriteList extends StatefulWidget {
  final List<ShoppingListItem> favList;

  const FavoriteList({super.key, required this.favList});

  @override
  FavoritesPageState createState() => FavoritesPageState();

}

class FavoritesPageState extends State<FavoriteList> {
  List<ShoppingListItem> favoriteItems = [];

  void delete (ShoppingListItem elem) {
    setState(() {
      favoriteItems.remove(elem);
    });
  }

  @override
  void initState() {
    super.initState();
    favoriteItems = widget.favList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Items'),
      ),
      body:Column(
        children: <Widget>[
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: favoriteItems.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (BuildContext context, int index) {
                final elem = favoriteItems[index];
                return Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.blueGrey,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(elem.name),
                            Text(elem.category,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey
                                )
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          delete(elem);
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text('Home')
        ),
        leading: IconButton(
          onPressed: (){
            Navigator.pushNamed(context, '/shoppingList');
          },
          icon: const Icon(Icons.shopping_bag),
        ),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.pushNamed(context, '/favorite');
            },
            icon: const Icon(Icons.favorite),
          ),
        ],
      ),
      body: const Center(
        child: Text("Welcome to your shopping list!"),
      ),
    );
  }
}

class ShoppingListItem {
  final String name;
  String category;

  ShoppingListItem({required this.name, required this.category});
}

class ShoppingList extends StatefulWidget{
  const ShoppingList({Key? key}) : super(key: key);


  @override
  ShoppingListItemState createState() => ShoppingListItemState();
}

class CategoryPainter extends CustomPainter {
  final String category;
  Map<String, Color> categoryColors;

  CategoryPainter(this.category, this.categoryColors);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    if (category == 'Grocery') {
      paint.color = categoryColors[category]!;
      canvas.drawCircle(
          Offset(size.width / 2, size.height / 2), size.width / 2, paint);
    } else if (category == 'Vegetables') {
      paint.color = categoryColors[category]!;
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    } else if (category == 'Fruits') {
      paint.color = categoryColors[category]!;
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(0, 0, size.width, size.height),
              const Radius.circular(8)),
          paint);
    } else if (category == 'Home') {
      paint.color = categoryColors[category]!;
      canvas.drawCircle(
          Offset(size.width / 2, size.height / 2), size.width / 2, paint);
    }

  }

  @override
  bool shouldRepaint(CategoryPainter oldDelegate) {
    return oldDelegate.category != category;
  }
}

class ShoppingListItemState extends State<ShoppingList> {
  final List<ShoppingListItem> list = [];
  final TextEditingController input = TextEditingController();
  List<String> categories = ['Grocery', 'Home', 'Fruits', 'Vegetables'];
  bool flag = true;

  Map<String, Color> categoryColors = {
    'Grocery': Colors.blue,
    'Home': Colors.deepOrange,
    'Fruits': Colors.yellow,
    'Vegetables': Colors.green,
  };


  void addElem(String elem, String category) {
    setState(() {
      list.add(ShoppingListItem(name: elem, category: category));
    });
    input.clear();
  }

  void deleteElem(ShoppingListItem elem) {
    setState(() {
      list.remove(elem);
      if (listFav.contains(elem)){
        listFav.remove(elem);
      }
    });
  }


  void addElemFavList(ShoppingListItem elem){
    setState(() {
      if (! listFav.contains(elem)) {
        listFav.add(elem);
      }
      else {
        listFav.remove(elem);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping list"),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.pushNamed(context, '/favorite',);
            },
            icon: const Icon(Icons.favorite),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: input,
                    decoration: const InputDecoration(
                      hintText: "Add element",
                    ),
                    onSubmitted: (String value) {
                      addElem(value, categories[0]);
                    },
                  ),
                ),
              ),
              DropdownButton<String>(
                value: categories[0],
                onChanged: (String? value) {
                  setState(() {
                    categories.remove(value!);
                    categories.insert(0, value);
                  });
                },
                items: categories
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: list.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (BuildContext context, int index) {
                final elem = list[index];
                return Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.blueGrey,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(elem.name),
                            Text(elem.category,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                      CustomPaint(
                        size: const Size(24, 24),
                        painter: CategoryPainter(elem.category, categoryColors),
                      ),
                      IconButton(
                        onPressed: () {
                          deleteElem(elem);
                        },
                        icon: const Icon(Icons.delete),
                      ),
                      IconButton(onPressed: (){
                        addElemFavList(elem);
                         const snackBar = SnackBar(
                          content: Text('Item added to favorites'),
                          duration: Duration(seconds: 2),
                        );
                       ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                          icon: const Icon(Icons.favorite,)
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
  ShoppingListItemState(){
    Timer.periodic(const Duration(seconds: 5), (timer) => setState(() {
      if (flag) {
        categoryColors = {
          'Grocery': Colors.red,
          'Home': Colors.purple,
          'Fruits': Colors.pink,
          'Vegetables': Colors.greenAccent,
        };
        flag = false;
      }
      else{
        categoryColors = {
          'Grocery': Colors.blue,
          'Home': Colors.deepOrange,
          'Fruits': Colors.yellow,
          'Vegetables': Colors.green,
        };
        flag = true;
      }
    }
    ));
  }
}
