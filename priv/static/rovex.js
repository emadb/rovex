document.addEventListener('DOMContentLoaded', () => { 

  const game = new Game();
  let rover = null;
  
  document.getElementById('control-form').addEventListener('submit', (event) =>{
    event.preventDefault();
    const submit = document.getElementById('submit');
    const nameInput = document.getElementById('name');
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
        console.log('Success:', response);
        if (response && response.status === 500){
          game.setCurrentPlayer(null);
          submit.style.display = 'block';
        }
      });
    } else {
      submit.style.display = 'block';
    }
  });

});