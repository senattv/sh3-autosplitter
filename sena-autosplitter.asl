state("sh3") {

  // Game Timer
  float GameTimer: "sh3.exe", 0x6CE66F4;

  // All doors split
  uint roomID: "sh3.exe", 0x32D2C0;
  
  // Heather's HP for NG
  float Heather_HP: "sh3.exe", 0x498660;
    
  // stats for 10 stars
  byte items: "sh3.exe", 0x6CE66E8;
  short shootingKills: "sh3.exe", 0x6CE66EA;
  short fightingKills: "sh3.exe", 0x6CE66EC;
  float damage: "sh3.exe", 0x6CE6700;
}

init {
  vars.Damage_Rounded = 0.0;
  
  refreshRate = 10;
}
startup {
  settings.Add("10Stars", true, "10 Stars (ignores rooms M and M5)");
}
update {  
  vars.Damage_Rounded = Math.Round(current.damage, 2);
  
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
