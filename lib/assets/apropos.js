// cheap as muck, but at least modestly effective

function redraw() {
  let apropos = document.getElementById("apropos").value.toLowerCase(),
      section_headers = document.getElementsByClassName("section"),
      tables = document.getElementsByClassName("index"),
      matched = document.getElementById("matched"),
      total_entries = document.getElementById("indexed").textContent,
      total_selected = 0;

  // assumes one section heading for each index table
  for (let i = 0; i < section_headers.length; i++) {
    let hdr = section_headers[i],
        tbl = tables[i],
        rows = tbl.rows,
        rows_selected = rows.length;

    for (let j = 0; j < rows.length; j++) {
      cells = rows[j].cells;
      if (apropos === "" ||
          cells[0].textContent.toLowerCase().includes(apropos) ||
          cells[1].textContent.toLowerCase().includes(apropos) ||
          cells[2].textContent.toLowerCase().includes(apropos)) {
        rows[j].style.display = "";
      } else {
        rows[j].style.display = "none";
        rows_selected -= 1;
      }
    };

    if (rows_selected == 0) {
      hdr.style.display = "none";
      tbl.style.display = "none";
    } else {
      hdr.style.display = "";
      tbl.style.display = "";
    };
    total_selected += rows_selected;
  };

  if (total_selected < total_entries) {
    matched.textContent = total_selected + " of ";
  } else {
    matched.textContent = '';
  };
}
