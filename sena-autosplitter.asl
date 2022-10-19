state("sh3") {

  // Game Timer
  float GameTimer: "sh3.exe", 0x6CE66F4;

  // All doors split
  uint roomID: "sh3.exe", 0x32D2C0;
  
  // Heather's HP for NG
  float Heather_HP: "sh3.exe", 0x498660;
  
  // all places a boss's HP can be
  float Worm_HP_Mem: "sh3.exe", 0x49E178;
  
  float Missionary_HP_Mem_One: "sh3.exe", 0x49D8A8;
  float Missionary_HP_Mem_Two: "sh3.exe", 0x49C9F8;
  
  float Lenny_HP_Mem_One: "sh3.exe", 0x49A3C8;
  float Lenny_HP_Mem_Two: "sh3.exe", 0x49C9F8;
  float Lenny_HP_Mem_Three : "sh3.exe", 0x498C48;
  
  float Alessa_HP_Mem: "sh3.exe", 0x498958;

  float God_HP_Mem_One: "sh3.exe", 0x499DE8;
  float God_HP_Mem_Two: "sh3.exe", 0x49C9F8;
  float God_HP_Mem_Three: "sh3.exe", 0x498958;
  float God_HP_Mem_Four: "sh3.exe", 0x49B568;
  
  // stats for 10 stars
  byte items: "sh3.exe", 0x6CE66E8;
  short shootingKills: "sh3.exe", 0x6CE66EA;
  short fightingKills: "sh3.exe", 0x6CE66EC;
  float damage: "sh3.exe", 0x6CE6700;
}

init {
  vars.Boss_HP = 0.0;
  vars.Damage_Rounded = 0.0;
  
  refreshRate = 10;
}
startup {
  settings.Add("10Stars", true, "10 Stars (ignores rooms M and M5)");
}
update {
  if (current.roomID == 45) { // split worm
    vars.Boss_HP = current.Worm_HP_Mem;
  }
  else if (current.roomID == 151) { // missionary
    vars.Boss_HP = Math.Min(current.Missionary_HP_Mem_One, current.Missionary_HP_Mem_Two);
  }
  else if (current.roomID == 189) { // lenny
    if (current.Lenny_HP_Mem_One != 0.0 && current.Lenny_HP_Mem_One != 100.0)
      vars.Boss_HP = current.Lenny_HP_Mem_One;
	  
    else if (current.Lenny_HP_Mem_Two != 0.0 && current.Lenny_HP_Mem_Two != 100.0)
      vars.Boss_HP = current.Lenny_HP_Mem_Two;
    
	else if (current.Lenny_HP_Mem_Three != 0.0 && current.Lenny_HP_Mem_Three != 100.0)
      vars.Boss_HP = current.Lenny_HP_Mem_Three;
	
	else if (current.Alessa_HP_Mem != 0.0 && current.Alessa_HP_Mem != 100.0)
      vars.Boss_HP = current.Alessa_HP_Mem;
	
    else vars.Boss_HP = 100;
  }    
  else if (current.roomID == 235) { // god
    vars.Boss_HP = current.Alessa_HP_Mem;
  }    
  else if (current.roomID == 266) { // god
    if (current.God_HP_Mem_One != 0.0 && current.God_HP_Mem_One < 100.0)
      vars.Boss_HP = current.God_HP_Mem_One;
    else if (current.God_HP_Mem_Two != 0.0 && current.God_HP_Mem_Two < 100.0)
      vars.Boss_HP = current.God_HP_Mem_Two;
	else if (current.God_HP_Mem_Three != 0.0 && current.God_HP_Mem_Three < 100.0)
      vars.Boss_HP = current.God_HP_Mem_Three;
	else if (current.God_HP_Mem_Four != 0.0 && current.God_HP_Mem_Four < 100.0)
      vars.Boss_HP = current.God_HP_Mem_Four;
	else
	  vars.Boss_HP = 100.0;
  }
  else vars.Boss_HP = 0.0;
  
  // present the boss HP and damage
  vars.Damage_Rounded = Math.Round(current.damage, 2);
  vars.Boss_HP = Math.Max(Math.Round(vars.Boss_HP, 2), 0.0);
  
  return true;
}

split {
  return (
    (old.roomID != current.roomID) &&
    
    // edge cases: some cutscenes where splitting would cause multiple splits
    // with no time difference
    !(old.roomID == 0 && current.roomID == 227) && // first nightmare cutscene on NG
    !(old.roomID == 227 && current.roomID == 210) && // second nightmare cutscene on NG
    !(old.roomID == 0 && current.roomID == 1) && // Heather waking up from the nightmare
    !(old.roomID == 1 && current.roomID == 2) && // Heather exits happy burger
    !(old.roomID == 2 && current.roomID == 3)  && // Heather hides in the bathroom from Douglas
    !(old.roomID == 10 && current.roomID == 46)  && // Subway entrance
    !(old.roomID == 133 && current.roomID == 135) && // Vincent cutscene
    !(old.roomID == 150 && current.roomID == 151) && // Heather's apartment to missionary
    !(old.roomID == 150 && current.roomID == 152) && // From living room to Harrys' bedroom
    !(old.roomID == 154 && current.roomID == 155) && // Outside of apartment to Douglas's car
    !(old.roomID == 155 && current.roomID == 156) && // Douglas's car to motel room
    !(old.roomID == 159 && current.roomID == 156) && // Hospital to Claudia+Vincent cutscene
    !(old.roomID == 157 && current.roomID == 156) && // Heather and Vincent cutscene at the motel
    !(old.roomID == 227 && current.roomID == 216) && // Douglas talking to Claudia to haunted mansion
    
    // 10 star ranking-specific skips of rooms M5 and M
    (!settings["10Stars"] || (
      (old.roomID != 171 && current.roomID != 171) && // not entering or exit M5
      (current.roomID != 186) &&
	  (old.roomID != 186 || current.roomID != 168) // not going back from M room to M hallway
    ))	 
  );
}

start {
  return (old.roomID == 0 && current.roomID != 0);
}
 

reset {
  return (old.roomID != 0 && current.roomID == 0);  
}

gameTime {  
  return TimeSpan.FromSeconds(current.GameTimer);
} 
