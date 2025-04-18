document.getElementById('fileInput')
  .addEventListener('change', (event) => {
    const file = event.target.files[0];
    const reader = new FileReader();

    reader.onload = function () {
      const lines = reader.result.trim().split('\n');
      var content = '<table>\n';
      for(y = 0; y < lines.length; y++) {
        content += `<tr id="row-${y}">`;
        for(x = 0; x < lines[y].length; x++) {
          content += `<td id="cell-${x}-${y}">`;
          content += lines[y][x];
          content += '</td>';
        }
        content += '</tr>';
      }
      content += '</table>';
      document.getElementById('file-contents').innerHTML = content;
      const puzzle = lines.map((line) => line.split(''));
      solvePuzzle(puzzle);
    };

    reader.onerror = function () {
      console.error('Error reading the file');
    };

    reader.readAsText(file, 'utf-8');
  });

function moveCursor(x, y) {
  elements = document.getElementsByClassName(['cursor']);
  for(let element of elements) {
    element.classList.remove('cursor');
  }
  document.getElementById(`cell-${x}-${y}`).classList.add('cursor');
}

function markAccepted(x, y) {
  document.getElementById(`cell-${x}-${y}`).classList.add('accepted-cell');
}

function setCount(count) {
  document.getElementById('found-count').innerHTML = count;
}

async function solvePuzzle(puzzle) {
  let xmasCount = 0;
  for(y = 0; y < puzzle.length; y++) {
    let row = puzzle[y];
    for (x = 0; x < row.length; x++) {
      let char = row[x];
      moveCursor(x, y);
      await new Promise(r => setTimeout(r, 50));
      if(char == 'X') {
        for (let deltaX of [-1, 0, 1]) {
          for (let deltaY of [-1, 0, 1]) {
            if (
              x + (deltaX * 3) >= 0 &&
              x + (deltaX * 3) < row.length &&
              y + (deltaY * 3) >= 0 &&
              y + (deltaY * 3) < puzzle.length
            ) {
              moveCursor(x + deltaX, y + deltaY);
              await new Promise(r => setTimeout(r, 50));
              if(puzzle[y + deltaY][x + deltaX] == 'M') {
                moveCursor(x + (deltaX * 2), y + (deltaY * 2));
                await new Promise(r => setTimeout(r, 50));
                if(puzzle[y + (deltaY * 2)][x + (deltaX * 2)] == 'A') {
                  moveCursor(x + (deltaX * 3), y + (deltaY * 3));
                  await new Promise(r => setTimeout(r, 50));
                  if(puzzle[y + (deltaY * 3)][x + (deltaX * 3)] == 'S')
                  {
                    setCount(++xmasCount);
                    for(i = 0; i <= 3; i++) {
                      acceptedX = x + (deltaX * i);
                      acceptedY = y + (deltaY * i);
                      markAccepted(acceptedX, acceptedY);
                    }
                  }
                }
              }
            }
          }
        }
      }
      await new Promise(r => setTimeout(r, 50));
    }
  }
  return xmasCount;
}
