const generateRandomPos = () => {
  const rand = Math.floor(Math.random() * 50);
  return rand;
}

const generateRandomDirection = () => {
  const directions = ['N', 'S', 'E', 'W'];
  const rand = Math.floor(Math.random() * 4);
  return directions[rand];
}

function Rover(name, x, y , d, score) {
  this.name = name;
  this.domId = this.generateDomId(name);
  this.x = x ? x : generateRandomPos();
  this.y = y ? y : generateRandomPos();
  this.direction = d ? d : generateRandomDirection();
  this.score = score ? score : 0;
  this.dead = false;
}

Rover.prototype.updatePosition = function(x, y) {
  this.x = x;
  this.y = y;
}

Rover.prototype.getTranslation = function() {
  const top = ((99 - this.y) * 40) + 2000;
  const left = (this.x * 40) + 2000;
  return `translate(${left}px, ${top}px)`;
}

Rover.prototype.generateDomId = function(name) {
  const cleanId = name.replace(/^[^1-9a-z]+|[^\w:.-]+/gi, "");
  return `rover-${cleanId}`;
}

Rover.prototype.getRotation = function() {
  const direction = this.direction; 
  let transform = ''
  switch (direction) {
    case 'S':
      transform = 'rotate(180deg)'
      break;
    case 'N':
      transform = 'rotate(0deg)';
      break;
    case 'E':
      transform = 'rotate(90deg)';
      break;
    default:
      transform = 'rotate(270deg)';
  }
  return transform;
}
