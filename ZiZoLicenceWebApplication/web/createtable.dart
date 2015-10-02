library table;

import 'dart:html';

class CreateTable
{
  static createTable()
  {
    TableElement table = querySelector("#searchTable");
    TableSectionElement header = table.createTHead();
    TableRowElement headerRow = header.insertRow(-1);
    TableCellElement cell = headerRow.insertCell(0);
    TableCellElement cell2 = headerRow.insertCell(1);
    TableCellElement cell3 = headerRow.insertCell(2);
    TableCellElement cell4 = headerRow.insertCell(3);
    cell.text = "";
    cell.style.backgroundColor = "#235B6D";
    cell2.style.backgroundColor = "#235B6D";
    cell3.style.backgroundColor = "#235B6D";
    cell4.style.backgroundColor = "#235B6D";
    cell.style.color = "#F0F2F0";
    cell2.style.color = "#F0F2F0";
    cell3.style.color = "#F0F2F0";
    cell4.style.color = "#F0F2F0";
    cell.style.textAlign = "left";
    cell2.style.textAlign = "left";
    cell3.style.textAlign = "left";
    cell4.style.textAlign = "left";
    cell2.innerHtml = "Licence Name:";
    cell3.innerHtml = "Licence Key:";
    cell4.innerHtml = "Licence Length:";
    table.hidden = false;
  }
}