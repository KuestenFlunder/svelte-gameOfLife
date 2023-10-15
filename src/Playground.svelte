<script>
    let url = "ws://localhost:8080/gameoflife";
    let playground = []; // To hold data sent from server
    let socket;

    function startGame() {
        socket = new WebSocket(url);

        socket.onopen = function (event) {
            console.log("Connection opened:", event);
            socket.send("10");
        };

        socket.onmessage = function (event) {
            console.log("Message received:", event.data);
            let rawData = JSON.parse(event.data).cellField;

            let size = Math.sqrt(rawData.length); // assuming the playground is square
            let transformedData = [];

            for (let i = 0; i < size; i++) {
                let row = [];
                for (let j = 0; j < size; j++) {
                    row.push(rawData[i * size + j]);
                }
                transformedData.push(row);
            }

            playground = transformedData;
        };

        socket.onerror = function (error) {
            console.error("WebSocket Error:", error);
        };

        socket.onclose = function (event) {
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

    {#each playground as row, y}
        <div>
            {#each row as cell, x}
                <div
                    bind:this={cell}
                    class="cell {cell.cellState === 'ALIVE' ? 'alive' : 'dead'}"
                />
            {/each}
        </div>
    {/each}
</div>

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
