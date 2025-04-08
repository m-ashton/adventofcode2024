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
      const puzzle = lines.map((line) => line.split(''));
      document.getElementById('file-contents').innerHTML = content;
      xmasCount = solvePuzzle(puzzle)
    };

    reader.onerror = function () {
      console.error('Error reading the file');
    };

    reader.readAsText(file, 'utf-8');
  });

async function solvePuzzle(puzzle) {
  let xmasCount = 0;
  for(y = 0; y < puzzle.length; y++) {
    let row = puzzle[y];
    for (x = 0; x < row.length; x++) {
      let char = row[x];
      document.getElementById(`cell-${x}-${y}`).classList.add('cursor');
      if(char == 'X') {
        for (let deltaX of [-1, 0, 1]) {
          for (let deltaY of [-1, 0, 1]) {
            if (
              x + (deltaX * 3) >= 0 &&
              x + (deltaX * 3) < row.length &&
              y + (deltaY * 3) >= 0 &&
              y + (deltaY * 3) < puzzle.length &&
              puzzle[y + deltaY][x + deltaX] == 'M' &&
              puzzle[y + (deltaY * 2)][x + (deltaX * 2)] == 'A' &&
              puzzle[y + (deltaY * 3)][x + (deltaX * 3)] == 'S'
            ){
              xmasCount += 1;
              document.getElementById('found-count').innerHTML = xmasCount;
              for(i = 0; i <=3; i++) {
                acceptedX = x + (deltaX * i);
                acceptedY = y + (deltaY * i);
                document.getElementById(`cell-${acceptedX}-${acceptedY}`).classList.add('accepted-cell');
              }
            }
          }
        }
      }
      await new Promise(r => setTimeout(r, 5));
      if(!(x == row.length - 1 && y == puzzle.length - 1)) {
        document.getElementById(`cell-${x}-${y}`).classList.remove('cursor');
      }
    }
  }
  return xmasCount;
}
