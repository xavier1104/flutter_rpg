import 'monster.dart';
import 'player.dart';

class Boss extends Monster{
  int skillCoolDown;
  int _skillCoolDownCount = 0;

  Boss({
    required super.name,
    required super.hp,
    required super.damage,
    required super.gainExp,
    required super.maxHp,
    required this.skillCoolDown,
  }){
    _skillCoolDownCount = skillCoolDown;
  }

  Boss.dragon()
  :skillCoolDown = 3,
  super(name: "巨龍", hp: 200, damage: 15, gainExp: 100, maxHp: 200){
    _skillCoolDownCount = skillCoolDown;
  }

  @override
  void attack(Player player){
    if (_skillCoolDownCount == 0){
      print("${name}使用終極技能!");
      int currentDamage = damage * 2;
      player.takeDamage(currentDamage);
      print("${player.name}剩餘血量:${player.hp}");
      _skillCoolDownCount = skillCoolDown;
    }
    else{
      dealDamage(player, damage);
      print("還有${_skillCoolDownCount}回合使用終極技能");
      _skillCoolDownCount--;
    }
  }
}