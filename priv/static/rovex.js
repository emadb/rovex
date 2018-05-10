document.addEventListener('DOMContentLoaded', () => { 

  let connection = null;
  let rovers = [];

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
      connection = new WebSocket(`ws://${window.location.host}/ws?rover=${rover}`)
      initializeWebSocket();
    } else {
      submit.style.display = 'block';
    }
  });


  const initializeWebSocket = () => {
    connection.onopen = () => {
      console.log('connection ready');
      createRover(rover);
      listenToKeyPress();
    }

    connection.onerror = (err) => {
      console.log('websocket error', err)
    }
  
    connection.onmessage = (evt) => {
      data = JSON.parse(evt.data);
      const { status, name, x, y, direction } = data;
      switch (status) {
        case 'born':
          rovers.push(name);
          createDOMRover(name, name === rover);
          animateRover(name, x, y, direction);
          break;
        case 'dead':
          deleteDOMRover(name);
        default:
          if (!rovers.includes(name)) {
            rovers.push(name);
            createDOMRover(name, name === rover);
          }
          animateRover(name, x, y, direction);
      }
    }
  } 

  


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
    x = Math.floor(Math.random() * 50)  
    y = Math.floor(Math.random() * 50)  
    xhr.send(JSON.stringify({
      name: name,
      x,
      y,
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
    const reverseTop = (50 - y) * 20;
    const top = reverseTop === 1000 ? 0 : reverseTop;
    const left = x * 20;
    return `translate(${left}px, ${top}px)`;
  }

  const rotateRover = (direction) => {
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

  const animateRover = (name, x, y, direction) => {
    const movement = moveRover(x, y);
    const rotation = rotateRover(direction);
    const id = `rover-${name}`
    const rover = document.getElementById(id)
    rover.style.setProperty('transform', `${movement} ${rotation}`);
  }

});