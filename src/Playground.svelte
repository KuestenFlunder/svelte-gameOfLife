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

<style>
    .grid {
        display: flex;
        flex-direction: column;
    }

    .row {
        display: flex;
    }

    .cell {
        width: 30px; /* or any other value */
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

<div>
    <button on:click={startGame}>Start Game</button>

    <div class="grid">
        {#each playground as row, y}
            <div class="row">
                {#each row as cell, x}
                    <div
                        bind:this={cell}
                        class="cell {cell.cellState === 'ALIVE' ? 'alive' : 'dead'}"
                    >
                    {cell.point.x}, {cell.point.y}
                    </div>
                {/each}
            </div>
        {/each}
    </div>
</div>
