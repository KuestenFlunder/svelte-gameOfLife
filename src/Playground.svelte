<script>
    let url = 'ws://localhost:8080/gameoflife';
    let playground = []; // To hold data sent from server
    let socket;

    function startGame() {
        socket = new WebSocket(url);

        socket.onopen = function(event) {
            console.log("Connection opened:", event);
            // Assuming you want to send a message to the backend to start the game. 
            // send the number of iterations you want to run the game for
            socket.send("10");
        };

        socket.onmessage = function(event) {
            console.log("Message received:", event.data);
            playground = JSON.parse(event.data);
            
        };

        socket.onerror = function(error) {
            console.error("WebSocket Error:", error);
        };

        socket.onclose = function(event) {
            if (event.wasClean) {
                console.log(`Connection closed cleanly, code=${event.code}, reason=${event.reason}`);
            } else {
                console.error('Connection died');
            }
        };
    }
</script>

<style>
    .cell {
        width: 20px;
        height: 20px;
        border: 1px solid black;
    }
    .alive {
        background-color: black;
    }
    .dead {
        background-color: white;
    }
</style>

<div>
    <button on:click={startGame}>Start Game</button>
    
    {#each playground as row, y}
        <div>
            {#each row as cell, x}
                <div bind:this={cell} class="cell {cell.cellState === 'ALIVE' ? 'alive' : 'dead'}"></div>
            {/each}
        </div>
    {/each}
</div>
