import 'player.dart';

abstract class Monster{
  String name;
  int hp;
  int damage;
  int gainExp;
  int maxHp;
  
  static Map<String, Map<String, dynamic>> monsterData ={
    "哥布林":{"hp":50, "damage":10, "gainExp":20, "maxHp":50},
    "史萊姆":{"hp":30, "damage":5, "gainExp":10, "maxHp":30},
    "巨魔":{"hp":100, "damage":20, "gainExp":50, "maxHp": 100},
  };

  Monster({
    required this.name,
    required this.hp,
    required this.damage,
    required this.gainExp,
    required this.maxHp,
    });
  
  

  void attack(Player player);

  void dealDamage(Player player, int damage){
    print("${this.name}反擊");
    int currentDamage = damage;
    if (player.isDefend){
      currentDamage ~/= 2;
    }
    player.takeDamage(currentDamage);
    print("${player.name}剩餘血量:${player.hp}");
  }

  void takeDamage(int damage){
    hp -= damage;
    if(hp < 0){
      hp = 0;
    }
  }
}