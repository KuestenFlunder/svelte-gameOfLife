<script>
    import { writable } from "svelte/store";

    let url = "ws://localhost:8080/gameoflife";
    let playground = writable([]); // Use Svelte store for reactivity
    let rounds = 1;
    let socket;

    function startGame() {
        socket = new WebSocket(url);

        socket.onopen = (event) => {
            console.log("Connection opened:", event);
           
             socket.send(String(rounds));
        };

        socket.onmessage = (event) => {
            console.log("Message received:", event.data);
            let rawData;

            try {
                rawData = JSON.parse(event.data).cellField;
            } catch (e) {
                console.error("Error parsing the JSON data:", e);
                return;
            }

            let size = Math.sqrt(rawData.length); // assuming the playground is square
            let transformedData = [];

            for (let i = 0; i < size; i++) {
                let row = [];
                for (let j = 0; j < size; j++) {
                    row.push(rawData[i * size + j]);
                }
                transformedData.push(row);
            }

            $playground = transformedData;
        };

        socket.onerror = (error) => {
            console.error("WebSocket Error:", error);
        };

        socket.onclose = (event) => {
            if (event.wasClean) {
                console.log(
                    `Connection closed cleanly, code=${event.code}, reason=${event.reason}`
                );
            } else {
                console.error("Connection died");
            }
        };
    }
</script>

<div>
    
    <button on:click={startGame}>Start Game</button>
    <input type="number" id="rounds" bind:value={rounds} />
    <div class="grid">
        {#each $playground as row, y}
            <div class="row">
                {#each row as cell, x}
                    <div
                        bind:this={cell}
                        class="cell {cell.cellState === 'ALIVE'
                            ? 'alive'
                            : 'dead'}"
                    >
                    <!-- {cell.point.x}, {cell.point.y} -->
                    </div>
                {/each}
            </div>
        {/each}
    </div>
</div>

<style>
    .grid {
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center; /* add this line to center the grid horizontally */
        height: 100vh; /* add this line to make the grid take up the full height of the viewport */
    }

    .row {
        display: flex;
    }

   
    .cell {
        width: 30px;
        height: 30px;
        border: 1px solid #ccc;
        display: flex;
        justify-content: center;
        align-items: center;
    }
    

    .alive {
        background-color: green;
    }

    .dead {
        background-color: white;
    }
</style>
