import 'dart:math';
import 'monster.dart';

enum PlayerAction{
  attack,
  heal,
  defend,
}

class Player{
  String name;
  int hp;
  int level;
  int exp;
  int maxHp;
  int maxExp;
  int damage;
  int criticalRate;
  bool isDefend;
  
  Player({
    required this.name, 
    required this.hp,
    required this.level,
    required this.exp,
    required this.maxHp,
    required this.maxExp,
    required this.damage,
    required this.criticalRate,
    required this.isDefend,
    });

  Player.dragonSlayer()
  : name = "千祐",
    hp = 100,
    level = 5,
    exp = 90,
    maxHp = 100,
    maxExp = 100,
    damage = 30,
    criticalRate = 30,
    isDefend = false;

  void heal(int recover){
    hp += recover;
    if (hp > maxHp){
      hp = maxHp;
    }
    print("$name恢復$recover血");
    print("目前血量:$hp");
  }

  void showStatus(){
    print("玩家:$name");
    print("等級:$level");
    print("血量:$hp");
    print("經驗:$exp");
  }

  void levelUp(){
    if (exp < maxExp){
      return;
    }
    
    while(exp >= maxExp){
        level += 1;
        exp -= maxExp;
        print("$name升級了!");
        print("目前等級:$level");
        print("目前經驗:$exp");
    }
  }

  void attack(Monster monster){
    print("$name攻擊${monster.name}");
    int currentDamage = damage;
    if (isCritical(criticalRate)){
        currentDamage *= 2;
        print("爆擊!");
    }
    
    monster.takeDamage(currentDamage);
    
    print("${monster.name}受到$currentDamage傷害");
    print("${monster.name}剩餘血量:${monster.hp}");
  }

  bool isCritical(int rate){
    int criticalChance = Random().nextInt(100);
    return criticalChance < rate;
  }

  void gainExp(int amount){
    exp += amount;
    print("獲得${amount}經驗");
    print("目前經驗${exp}");
  }

  void defend(){
    isDefend = true;
    print("${name}選擇防禦");
  }

  void reset(){
    isDefend = false;
  }

  void takeDamage(int damage){
    hp -= damage;
    if(hp < 0){
      hp = 0;
    }
  }
}