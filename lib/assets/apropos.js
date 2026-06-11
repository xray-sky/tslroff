// cheap as muck, but at least modestly effective

parseQuery();

function parseQuery() {
  let urlString = location.href,
      queryStart = urlString.indexOf('?') + 1,
      queryEnd = urlString.indexOf('#') + 1 || urlString.length + 1,
      query = urlString.slice(queryStart, queryEnd - 1),
      pairs = query.replace(/\+/g, ' ').split('&');

  for (let i = 0; i < pairs.length; i++) {
    let pair = pairs[i].split('=', 2),
           n = decodeURIComponent(pair[0]),
           v = decodeURIComponent(pair[1]);

    if (n == "apropos") {
      document.getElementById("apropos").setAttribute("value", v);
      redraw();
    }
  }
}

function redraw() {
  let apropos = document.getElementById("apropos").value.toLowerCase(),
      section_headers = document.getElementsByClassName("section"),
      tables = document.getElementsByClassName("index"),
      matched = document.getElementById("matched"),
      total_entries = document.getElementById("indexed").textContent,
      total_selected = 0,
      non_section_tables = tables.length - section_headers.length;

  // might be fewer section headings than tables
  for (let i = 0; i < non_section_tables ; i++) {
    total_selected += filter_table(tables[i],apropos);
  }

  // assumes all tables with section headings follow all tables without
  for (let i = 0; i < section_headers.length; i++) {
    let hdr = section_headers[i],
        tbl = tables[i + non_section_tables],
        rows_selected = filter_table(tbl, apropos);

    if (rows_selected == 0) {
      hdr.style.display = "none";
    } else {
      hdr.style.display = "";
      total_selected += rows_selected;
    };
  };

  if (total_selected < total_entries) {
    matched.textContent = total_selected + " of ";
  } else {
    matched.textContent = '';
  };
}

function filter_table(tbl, apropos) {
  let rows = tbl.rows,
      rows_selected = rows.length;

  for (let i = 0; i < rows.length; i++) {
      cells = rows[i].cells;
      if (apropos === "" ||
          cells[0].textContent.toLowerCase().includes(apropos) ||
          cells[1].textContent.toLowerCase().includes(apropos) /*||
          cells[2].textContent.toLowerCase().includes(apropos)*/) {
        rows[i].style.display = "";
      } else {
        rows[i].style.display = "none";
        rows_selected -= 1;
      }
  };

  if (rows_selected == 0) {
    tbl.style.display = "none";
  } else {
    tbl.style.display = "";
  };

  return rows_selected;
}
