document.addEventListener('DOMContentLoaded', () => { 

  const game = new Game();
  let rover = null;
  
  document.getElementById('control-form').addEventListener('submit', (event) =>{
    event.preventDefault();
    const submit = document.getElementById('submit');
    const nameInput = document.getElementById('name');
    const error = document.getElementById('error');
    submit.style.display = 'none';
    const roverName = nameInput.value;
    if (roverName){
      nameInput.readOnly = true;
      rover = new Rover(roverName);
      game.setCurrentPlayer(roverName);
      const data = {
        x: rover.x,
        y: rover.y,
        name: rover.name,
        d: rover.direction,
      }
      error.style.display = 'none';
      fetch('/rover', {
        method: 'POST',
        body: JSON.stringify(data),
        headers: new Headers({
          'Content-Type': 'application/json'
        })
      })
      .catch((error) => {
        console.error('Error:', error);
        game.setCurrentPlayer(null);
        submit.style.display = 'block';
      })
      .then((response) => {
        if ([400, 500].includes(response.status)) {
          return response.json();
        } else {
          return false;
        }
      }).then((data) =>{
        if(data){
          game.setCurrentPlayer(null);
          submit.style.display = 'block';
          nameInput.removeAttribute('readonly');
          let text = 'ERROR'
          if(data.message){
            text = `${text}: ${data.message}`;
          } 
          error.innerText = text
          error.style.display = 'block';
        }
      })
    } else {
      submit.style.display = 'block';
      nameInput.removeAttribute('readonly');
      error.innerText = 'ERROR';
    }
  });

});