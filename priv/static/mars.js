function Mars() {
  this.domElement = document.getElementById('mars');
  this.leftTranslation = null;
  this.topTranslation = null;
}

Mars.prototype.moveSpace = function(left, top) {
  const body = document.body;
  const bodyWidth = body.clientWidth - 400;
  const bodyHeight = body.clientHeight;
  const bodyCenterTop =  (bodyHeight / 2) - 20;
  const bodyCenterLeft =  (bodyWidth / 2) - 20;

  const tLeft = left * 40  + 2000;
  const tTop = ((99 - top) * 40) + 2000;

  const leftTranslation = bodyCenterLeft - tLeft;
  const topTranslation = bodyCenterTop - tTop;

  let transition = true;

  if (this.leftTranslation && Math.abs(this.leftTranslation - leftTranslation) > 40){
    transition = false;
  }


  if (this.topTranslation && Math.abs(this.topTranslation - topTranslation) > 40){
    transition = false;
  }

  if(transition) {
    this.domElement.classList.add('mars--transition');
  } else {
    this.domElement.classList.remove('mars--transition');
  }

  this.leftTranslation = leftTranslation;
  this.topTranslation = topTranslation;

  this.domElement.style.setProperty('transform', `translate(${leftTranslation}px, ${topTranslation}px)`);
}

Mars.prototype.addRover = function(rover) {
  this.domElement.appendChild(rover);
}

