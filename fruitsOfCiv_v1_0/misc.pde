void drawUI() {
  //Statistics
  fill(terrainmap[mouseX+screenPosX-width/2][mouseY+screenPosY-height/2].typeColor);
  stroke(0);
  rect(50, height-20, 90, 30);
  fill(255);
  text("TYPE = " + terrainmap[mouseX+screenPosX-width/2][mouseY+screenPosY-height/2].type, 10, height-13);

  fill(255);
  stroke(0);
  rect(180, height-20, 155, 30);
  fill(0);
  if (displayPops) text("VisiblePops: " + "ON", 115, height-13);
  else if (!displayPops) text("VisiblePops: " + "OFF", 115, height-13);

  fill(0);
  stroke(255);
  rect(width/2+width/8+width/32, height-20, width*2/3, 30);
  fill(255);
  text("Total: " + settlersTotal() + " settlers" + " | " + warriorsTotal() + " warriors" + " | " + civ.size() + " total" + " | " + 
  cit.size() + " cities", width/2-width/8-width/32, height-13);
  
  fill(0);
  stroke(255);
  rect(width/2, 20, width-10, 30);
  fill(teamColor());
  text("Team: " + team + " | " + settlersinTeam() + " settlers" + " | " + warriorsinTeam() + " warriors" + " | " + popinTeam() + " total" +
  " | " + citinTeam() + " cities" , 20, 25);
}

int settlersTotal() {
  int count = 0;
  for (int x=0;x<civ.size();x++) {
    if (civ.get(x).settler == true) count++;
  }
  return count;
}

int warriorsTotal() {
  int count = 0;
  for (int x=0;x<civ.size();x++) {
    if (civ.get(x).warrior == true) count++;
  }
  return count;
}

int settlersinTeam() {
  int count = 0;
  for (int x=0;x<civ.size();x++) {
    if (civ.get(x).team == team && civ.get(x).settler == true) count++;
  }
  return count;
}

int warriorsinTeam() {
  int count = 0;
  for (int x=0;x<civ.size();x++) {
    if (civ.get(x).team == team && civ.get(x).warrior == true) count++;
  }
  return count;
}

int popinTeam() {
  return settlersinTeam() + warriorsinTeam();
}

int citinTeam() {
  int count = 0;
  for (int x=0;x<cit.size();x++) {
    if (cit.get(x).team == team) count++;
  }
  return count;
}

color teamColor() {
  color teamCol = 0;
  if (team == 1) teamCol = #FF0000;
  else if (team == 2) teamCol = #00FF00;
  else if (team == 3) teamCol = #0000FF;
  else if (team == 4) teamCol = #F5A607;
  else if (team == 5) teamCol = #FFFF00;
  else if (team == 6) teamCol = #CE30CE;
  else if (team == 7) teamCol = #FFFFFF;
  return teamCol;
}
