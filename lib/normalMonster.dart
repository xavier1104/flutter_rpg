import 'monster.dart';
import 'player.dart';

class NormalMonster extends Monster{
  NormalMonster({
    required super.name,
    required super.hp,
    required super.damage,
    required super.gainExp,
    required super.maxHp,
  });

  NormalMonster.fromData(String name)
  : super(
    name: name,
    hp: Monster.monsterData[name]!["hp"] as int,
    damage: Monster.monsterData[name]!["damage"] as int,
    gainExp:Monster.monsterData[name]!["gainExp"] as int,
    maxHp: Monster.monsterData[name]!["maxHp"] as int,
  );

  @override
  void attack(Player player){
    dealDamage(player, damage);
  }
}