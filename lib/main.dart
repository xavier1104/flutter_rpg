import 'package:flutter/material.dart';
import 'player.dart';
import 'monster.dart';
import 'dart:math';
import 'normalMonster.dart';
import 'boss.dart';
import 'map_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MapScreen(),
    );
  }
}

class GameScreen extends StatefulWidget{
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>{
  late Player player;
  List<Monster> monsters = [];
  PlayerAction? selectedAction;
  String hint = "";

  @override
  void initState(){
    super.initState();
    setupGame();
  }

  void takeDamage(){
    setState((){
      player.takeDamage(10);
    });
  }

  void heal(){
    setState(() {
      selectedAction = PlayerAction.heal;
      player.heal(20);
      hint = "${player.name}選擇補血";
      selectedAction = null;
    });
  }
  
  void defend(){
    setState(() {
      selectedAction = PlayerAction.defend;
      player.defend();
      hint = "${player.name}選擇防禦";
      selectedAction = null;
    });
  }

  void attack(Monster monster){
    setState((){
      if (selectedAction != PlayerAction.attack){
        hint = "玩家沒有選擇攻擊";
        return;
      }

      player.attack(monster);

      if(monster.hp > 0){
        monster.attack(player);
      }
      else{
          print("${monster.name}被擊敗!");
          player.gainExp(monster.gainExp);
      }

      if (player.hp <= 0){
        print("${player.name}被擊敗");
      }

      selectedAction = null;
      hint = "";
    });

    checkResult();
  }

  void checkResult(){
    bool result = true;
    if (player.hp <= 0){
      Navigator.pop(context, false);
    }
    else{
      for (Monster monster in monsters) {
        if (monster.hp > 0){
          result = false;
          break;
        }
      }

      if (result){
        Navigator.pop(context, true);
      }
    }
  }

  void selectAttack(){
    setState(() {
      selectedAction = PlayerAction.attack;
      hint = "請選擇攻擊對象";
    });
  }

  void cancelAttack(){
    setState(() {
      selectedAction = null;
      hint = "";
    });
  }

  void reset(){
    setState(() {
      setupGame();
    });
  }

  void setupGame(){
      player = Player.dragonSlayer();
      selectedAction = null;
      hint = "";
      monsters = [];
      for(int i = 0; i < 2; ++i){
        List<String> names = Monster.monsterData.keys.toList();
        int rand = Random().nextInt(names.length);
        monsters.add(NormalMonster.fromData(names[rand]));
      }
      monsters.add(Boss.dragon());
  }

  Color getHpColor(double percent){
    if(percent > 0.5) return Colors.green;
    if(percent > 0.2) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text(player.name),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            hint == ""? Text("請選擇行動") : Text(hint),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: selectAttack, child: const Text("攻擊")),
                selectedAction == PlayerAction.attack? ElevatedButton(onPressed: cancelAttack, child: const Text("取消攻擊")) : Text(""),
                ElevatedButton(onPressed: heal, child: const Text("補血")),
                ElevatedButton(onPressed: defend, child: const Text("防禦")),
              ],
            ),
            player.hp > 0? Text("${player.name} HP:${player.hp} / ${player.maxHp}", style: const TextStyle(fontSize: 24),) : Text("${player.name}被擊敗", style: const TextStyle(fontSize: 24, color: Colors.red),),
            LinearProgressIndicator(
              value: player.hp / player.maxHp,
              minHeight: 10,
              color: getHpColor(player.hp / player.maxHp),
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(height: 20,),
            ...monsters.map((monster){
              bool isDead = monster.hp <= 0;
              bool isPlayerDead = player.hp <= 0;
              bool isSelectAttack = selectedAction != PlayerAction.attack;
              return ElevatedButton(
                onPressed: isDead || isPlayerDead || isSelectAttack? null : () => attack(monster),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isDead? Text("${monster.name}被擊敗") : Text(monster.name),
                    Text("Hp: ${monster.hp} / ${monster.maxHp}"),
                    LinearProgressIndicator(
                      value: monster.hp / monster.maxHp,
                      minHeight: 10,
                      color: getHpColor(monster.hp / monster.maxHp),
                      backgroundColor: Colors.grey[300],
                    ),
                  ],
                ),
              );
            }),
            ElevatedButton(
              onPressed: reset, 
              child: const Text("重置"),
            ),
          ],
        ),
      ),
    );
  }
}