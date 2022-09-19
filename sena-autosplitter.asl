state("sh3") 
{
    float GameTimer: "sh3.exe", 0x6CE66F4;
    uint roomID: "sh3.exe", 0x32D2C0;
}

split
{
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
	  !(old.roomID == 227 && current.roomID == 216) // Douglas talking to Claudia to haunted mansion
	);
}

start
{
	return (old.roomID == 0 && current.roomID != 0);
}
 

reset
{
	return (old.roomID != 0 && current.roomID == 0);
}

gameTime
{	
	return TimeSpan.FromSeconds(current.GameTimer);
} 
