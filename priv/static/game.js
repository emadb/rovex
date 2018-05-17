function Game() {
  this.currentPlayer;
  this.players = [];
  this.mars = new Mars();
  this.container = document.getElementsByClassName('container')[0];
  this.scoreBoard = document.getElementById('score-board');

  this.connection = new WebSocket(`ws://${window.location.host}/ws`);

  this.connection.onopen = () => {
    console.log('connection ready');
  }

  this.connection.onerror = (err) => {
    console.log('websocket error', err)
  }

  this.connection.onmessage = (evt) => {
    data = JSON.parse(evt.data);
    const { op, name } = data;
    const isCurrentPlayer = this.currentPlayer && name === this.currentPlayer;
    let finded = this.findRoverByName(name); 
    switch (op) {
      case 'born':
        if (isCurrentPlayer) {
          this.createCurrentPlayer(data);
        } else {
          if (!finded){
            this.addPlayer(data);
          } 
        }
        this.updateScore();
        break;
      case 'die':
        if (finded){
          finded.dead = true;
          if (isCurrentPlayer) {
            document.getElementsByClassName('dead-message')[0].classList.add('dead-message--visible');
            document.getElementById('regenerate').style.display = 'block';
            document.getElementById('name').removeAttribute('readonly');
          }
          const deadRover = document.getElementById(finded.domId);
          if(deadRover){
            deadRover.remove();
          }
        }
        break;
      case 'update_score':  
        if (finded){
          finded.score = data.score;
          this.updateScore();
        }
        break;
      default:
        const { x, y, direction, score } = data;
        console.log(x, y, name);
        if (!finded) {
          this.addPlayer(data);
        } else { 
          finded = Object.assign(finded, {x, y, direction, score});
          if (isCurrentPlayer) {
            this.moveCurrentPlayer(finded);
          } else {
            this.movePlayer(finded);
          }
        }
        this.updateScore();
    }
  }

  document.addEventListener('keydown', (e) => {
    if(this.currentPlayer){
      if (e.keyCode == '38') {
        this.connection.send(JSON.stringify({ n: this.currentPlayer, c: 'F' }))
      } else if (e.keyCode == '40') {
        this.connection.send(JSON.stringify({ n: this.currentPlayer, c: 'B' }))
      } else if (e.keyCode == '37') {
        this.connection.send(JSON.stringify({ n: this.currentPlayer, c: 'L' }))
      } else if (e.keyCode == '39') {
        this.connection.send(JSON.stringify({ n: this.currentPlayer, c: 'R' }))
      }
    }
  });

  document.getElementById('regenerate').addEventListener('click', function(){
    document.getElementById('regenerate').style.display = 'none';
    document.getElementsByClassName('dead-message')[0].classList.remove('dead-message--visible');
  });
}

Game.prototype.setCurrentPlayer = function(name){
  this.currentPlayer = name;
}

Game.prototype.createCurrentPlayer = function(data) {
  const {name, x, y, direction, score} = data;
  const rover = new Rover(name, x, y, direction, score);
  this.players.push(rover);
  const domRover = this.createDomRover(rover);
  domRover.classList.add('rover--mine');
  this.container.appendChild(domRover);
  this.moveCurrentPlayer(rover);
}

Game.prototype.addPlayer = function(data) {
  const {name, x, y, direction, score} = data;
  const player = new Rover(name, x, y, direction, score);
  this.players.push(player);
  const rover = this.createDomRover(player);
  const rotation = player.getRotation();
  const translation = player.getTranslation(); 
  rover.style.setProperty('transform', `${translation} ${rotation}`);
  this.mars.addRover(rover);
}

Game.prototype.createDomRover = function(rover) {
  const domRover = document.createElement('div');
  domRover.classList.add('rover');
  domRover.id = rover.domId;
  domRover.innerHTML = `<div class="rover-icon"></div><p>${rover.name}</p>`;
  return domRover;
}

Game.prototype.moveCurrentPlayer = function(rover) {
  const rotation = rover.getRotation();
  const roverElement = document.getElementById(rover.domId)
  roverElement.style.setProperty('transform', `${rotation}`);
  this.mars.moveSpace(rover.x, rover.y);
}

Game.prototype.movePlayer = function(player){
  const rotation = player.getRotation();
  const translation = player.getTranslation(); 
  const roverElement = document.getElementById(player.domId)
  roverElement.style.setProperty('transform', `${translation} ${rotation}`);
}

Game.prototype.getCurrentPlayerId = function() {
  if (this.currentPlayer) {
    return this.currentPlayer.id;
  }
  return null;
}

Game.prototype.findRoverByName = function(name) {
  return this.players.find((p) => {
    return p.name === name;
  });
}

Game.prototype.updateScore = function() {
  const scoreboardText = this.players.sort(sortFunction).reduce((acc, p) => {
    const dead = p.dead ? '(dead)' : '';
    return acc = acc + `<li>${p.name}: ${p.score} ${dead}</li>`;
  }, '<h2>Score Board</h2><ol id="score-board">');

  this.scoreBoard.innerHTML = scoreboardText + '</ol>';
}

const sortFunction = (a, b) =>{
  if (a.score < b.score){
    return 1;
  }
  if (a.score > b.score){
    return -1;
  }
  if (a.score === b.score){
    const nameA = a.name.toUpperCase();
    const nameB = b.name.toUpperCase();
    if (nameA < nameB) {
      return -1;
    }
    if (nameA > nameB) {
      return 1;
    }
    return 0;
  }
  return 0;
}

