document.addEventListener('DOMContentLoaded', () => { 

  const connection = new WebSocket('ws://localhost:3000/ws')
  let rovers = [];

  const maxWidth = 1000;
  const maxHeight = 1000;

  let rover = null;

  const form = document.getElementById('control-form');
  const submit = document.getElementById('submit');
  const nameInput = document.getElementById('name');

  

  form.addEventListener('submit', (event) =>{
    event.preventDefault();
    submit.style.display = 'none';
    const roverName = nameInput.value;
    if (roverName){
      nameInput.readOnly = true;
      rover = roverName;
      createRover(roverName);
      listenToKeyPress();
    } else {
      submit.style.display = 'block';
    }
  });


  const listenToKeyPress = () => {
    document.addEventListener('keydown', (e) => {
      if (e.keyCode == '38') {
        connection.send(JSON.stringify({ n: rover, c: 'F' }))
      } else if (e.keyCode == '40') {
        connection.send(JSON.stringify({ n: rover, c: 'B' }))
      } else if (e.keyCode == '37') {
        connection.send(JSON.stringify({ n: rover, c: 'L' }))
      } else if (e.keyCode == '39') {
        connection.send(JSON.stringify({ n: rover, c: 'R' }))
      }
    })
  }

  const createRover = (name) => {
    const xhr = new XMLHttpRequest();
    xhr.open('POST', '/rover');
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.onload = function() {
      if (xhr.status === 200) {
          console.log(JSON.parse(xhr.responseText));
      }
    };
    xhr.send(JSON.stringify({
      name: name,
      x: 0,
      y: 0,
      d: 'N'
    }));
  }

  const createDOMRover = (name, mine = false) => {
    const rover = document.createElement('div');
    rover.classList.add('rover')
    if (mine) {
      rover.classList.add('rover--mine');
    }
    rover.id = `rover-${name}`;
    document.getElementsByClassName('mars')[0].appendChild(rover);
    rovers.push(name);
  }

  const deleteDOMRover = (name) => {
    const id = `rover-${name}`;
    const rover = document.getElementById(id);
    if(rover){
      rover.remove();
    }
  }

  const moveRover = (x, y) => {
    const top = y * 100 / maxHeight;
    const left = x * 100 / maxWidth;
    return `translate(${left}vw, ${top}vh)`;
  }

  const rotateRover = (direction) => {
    let transform = ''
    switch (direction) {
      case 'S':
        transform = 'rotate(270deg)'
        break;
      case 'N':
        transform = 'rotate(90deg)';
        break;
      case 'E':
        transform = 'rotate(0deg)';
        break;
      default:
        transform = 'rotate(180deg)';
    }
    return transform;
  }

  const animateRover = (name, x, y, direction) => {
    const movement = moveRover(x, y);
    const rotation = rotateRover(direction);
    const id = `rover-${name}`
    const rover = document.getElementById(id)
    console.log(movement, rotation);
    rover.style.setProperty('transform', `${movement} ${rotation}`);
  }

  connection.onopen = () => {
    console.log('connection ready')
    //  heartBeat = setInterval(() => connection.send('ping'), 5000)
  }

  connection.onerror = (err) => {
    console.log('websocket error', err)
  }

  connection.onmessage = (evt) => {
    data = JSON.parse(evt.data);
    const { status, name } = data;
    switch (status) {
      case 'born':
        createDOMRover(name, name === rover);
        break;
      case 'dead':
        deleteDOMRover(name);
      default:
        console.log(data);
    }
    /*const { name, x, y, direction } = data;
    if (!rovers.includes(name)) {
      createRover(name)
    }
    animateRover(name, x, y, direction)*/
  }

  function sendMessage() {
    console.log('Qui');
    connection.send(JSON.stringify({ n: "rover_1", c: "F" }))
  }
});