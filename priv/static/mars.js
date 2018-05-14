function Mars() {
  this.domElement = document.getElementById('mars');
}

Mars.prototype.moveSpace = function(left, top) {
  const body = document.body;
  const bodyWidth = body.clientWidth - 400;
  const bodyHeight = body.clientHeight;
  const bodyCenterTop =  (bodyHeight / 2) - 10;
  const bodyCenterLeft =  (bodyWidth / 2) - 10;

  const tLeft = left * 40  + 2000;
  const tTop = ((49 - top) * 40) + 2000;

  const leftTranslation = bodyCenterLeft - tLeft;
  const topTranslation = bodyCenterTop - tTop;

  this.domElement.style.setProperty('transform', `translate(${leftTranslation}px, ${topTranslation}px)`)
}

Mars.prototype.addRover = function(rover) {
  this.domElement.appendChild(rover);
}

