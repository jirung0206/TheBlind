class Room {
  Box room;
  PVector position;
  PVector dimensions;
  float w;
  float h = 20;
  float d;
  float y = -groundBlockSize/2 - h/2;
  color c = color(105, 96, 91);

  Room(PApplet parent, float x, float z, float _w, float _d) {
    w = _w;
    d = _d;
    position = new PVector(x, y, z);
    dimensions = new PVector(w, h, d);
    room = new Box(parent, w, h, d);
    room.setTexture("information.jpeg", Box.FRONT);
    room.setTexture("information.jpeg", Box.BACK);
    room.setTexture("information.jpeg", Box.LEFT);
    room.setTexture("information.jpeg", Box.RIGHT);
    room.visible(false, Box.TOP);
    room.drawMode(S3D.TEXTURE);
  }
  
    void update() {
    float playerLeft = player.position.x - player.dimensions.x/2;
    float playerRight = player.position.x + player.dimensions.x/2;
    float playerTop = player.position.y - player.dimensions.y/2;
    float playerBottom = player.position.y + player.dimensions.y/2;
    float playerFront = player.position.z - player.dimensions.z/2;
    float playerBack = player.position.z + player.dimensions.z/2;

    float boxLeft = position.x - dimensions.x/2;
    float boxRight = position.x + dimensions.x/2;
    float boxTop = position.y - dimensions.y/2;
    float boxBottom = position.y + dimensions.y/2;
    float boxFront = position.z - dimensions.z/2;
    float boxBack = position.z + dimensions.z/2;

    float boxLeftOverlap = playerRight - boxLeft;
    float boxRightOverlap = boxRight - playerLeft;
    float boxTopOverlap = playerBottom - boxTop;
    float boxBottomOverlap = boxBottom - playerTop;
    float boxFrontOverlap = playerBack - boxFront;
    float boxBackOverlap = boxBack - playerFront;

    if (((playerLeft > boxLeft && playerLeft < boxRight || (playerRight > boxLeft && playerRight < boxRight)) && ((playerTop > boxTop && playerTop < boxBottom) || (playerBottom > boxTop && playerBottom < boxBottom)) && ((playerFront > boxFront && playerFront < boxBack) || (playerBack > boxFront && playerBack < boxBack)))) {
      crashed=true;

      float xOverlap = max(min(boxLeftOverlap, boxRightOverlap), 0);
      float yOverlap = max(min(boxTopOverlap, boxBottomOverlap), 0);
      float zOverlap = max(min(boxFrontOverlap, boxBackOverlap), 0);

      if (xOverlap < yOverlap && xOverlap < zOverlap) {
        if (boxLeftOverlap < boxRightOverlap) {
          player.position.x = boxLeft - player.dimensions.x/2;
        } else {
          player.position.x = boxRight + player.dimensions.x/2;
        }
      } else if (yOverlap < xOverlap && yOverlap < zOverlap) {
        if (boxTopOverlap < boxBottomOverlap) {
          player.position.y = boxTop - player.dimensions.y/2;
          player.velocity.y = 0;
          player.grounded = true;
        } else {
          player.position.y = boxBottom + player.dimensions.y/2;
        }
      } else if (zOverlap < xOverlap && zOverlap < yOverlap) {
        if (boxFrontOverlap < boxBackOverlap) {
          player.position.z = boxFront - player.dimensions.x/2;
        } else {
          player.position.z = boxBack + player.dimensions.x/2;
        }
      }
    }
  }

  void display() {
    room.moveTo(position.x, position.y, position.z);
    room.draw();
  }
}