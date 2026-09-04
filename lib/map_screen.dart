import 'package:flutter/material.dart';
import 'package:flutter_rpg/main.dart';

class MapScreen extends StatefulWidget{
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>{
  int playerRow = 3;
  int playerCol = 0;
  List<List<String>> map = [
    ['.', '.', '.', 'M'],
    ['.', '#', '.', '.'],
    ['.', '.', '.', '.'],
    ['.', '.', '.', 'M'],
  ];

  void move(int rowDelta, int colDelta){
    setState(() {
      playerCol += colDelta;
      playerRow += rowDelta;

      if (playerCol > map[0].length - 1){
        playerCol = map[0].length - 1;
      }
      else if(playerCol < 0){
        playerCol = 0;
      }

      if (playerRow > map.length - 1){
        playerRow = map.length - 1;
      }
      else if(playerRow < 0){
        playerRow = 0;
      }

    });

    checkTile();
  }

  void checkTile() async{
    String tile = map[playerRow][playerCol];
    if(tile == "M"){
      final result = await Navigator.push(
        context, 
        MaterialPageRoute(builder: (context)=>const GameScreen()),
      );

      if (result == true){
        setState(() {
          map[playerRow][playerCol] = '.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("迷宮"),),
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              double cellWidth = constraints.maxWidth / map[0].length;
              double cellHeight = constraints.maxHeight / map.length;
              double aspectRatio = cellWidth / cellHeight;

              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: map[0].length,
                  childAspectRatio: aspectRatio,
                ),
                itemCount: map.length * map[0].length,
                itemBuilder: (context, index){
                  int row = index ~/ map[0].length;
                  int col = index % map[0].length;

                  bool isPlayer = (row == playerRow && col == playerCol);

                  return Container(
                    margin: const EdgeInsets.all(2),
                    color: isPlayer? Colors.blue : Colors.grey[300],
                    child: Center(child: Text(isPlayer? "P" : map[row][col])),
                  );
                },
              );
            })),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: (){move(0, -1);}, child: const Text("左")),
                ElevatedButton(onPressed: (){move(0, 1);}, child: const Text("右")),
                ElevatedButton(onPressed: (){move(-1, 0);}, child: const Text("上")),
                ElevatedButton(onPressed: (){move(1, 0);}, child: const Text("下")),
              ],
            )
        ]
        ),
      );
  }
}