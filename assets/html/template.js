
var setClassesOnTemplateBody = function (className) {
  $("#templateBody").addClass(className);
}

var setHtml = function (html) {
  $("#templateBody").html(html);
}

var getHtml = function (html) {
  return $("#templateBody").html();
}

var addClicks = function (name) {
  $('.' + name).each(function ($i, $ele) {
    this.addEventListener('click', (e) => {
      $(document.activeElement).blur();
      window.flutter_inappwebview.callHandler('elementClicked', $i, name);
    });
  });
}

var getLocalStorageData = function(){
  setInterval(()=>{
    var data = JSON.parse(localStorage.getItem('ls.closeInAppBrowser'));
    window.flutter_inappwebview.callHandler('fetchData',data);
  },2000);
}

var bindListeners = function () {
  // Keep existing keyup handler for input[type="text"]
  $('#templateBody').on("keyup", 'input[type="text"]', function () {
    $(this).attr("value", $(this).val());
  });

  // Enhanced paste handler for input[type="text"] with PDF detection
$('#templateBody').on("paste", 'input[type="text"]', function (e) {
    var $this = $(this);
    var clipboardData = e.originalEvent.clipboardData || window.clipboardData;
    var source = detectPasteSource(clipboardData);
    
    if (source === 'pdf') {
      e.preventDefault();
      var plainText = clipboardData.getData('text/plain');
      $this.val(plainText);
      $this.attr("value", plainText);
    } else {
      requestAnimationFrame(function() {
        $this.attr("value", $this.val());
      });
    }
  });

  $('#templateBody').on("change", 'input[type="checkbox"]', function () {
    $(this).attr("checked", this.checked);
  });

  // Keep existing keyup handler for textarea
  $('#templateBody').on("keyup", "textarea", function () {
    $(this).text($(this).val());
  });

  // Enhanced paste handler for textarea with PDF detection
$('#templateBody').on("paste", "textarea", function (e) {
    var $this = $(this);
    var clipboardData = e.originalEvent.clipboardData || window.clipboardData;
    var source = detectPasteSource(clipboardData);
    
    if (source === 'pdf') {
      e.preventDefault();
      var plainText = clipboardData.getData('text/plain');
      $this.val(plainText);
      $this.text(plainText);
    } else {
      requestAnimationFrame(function() {
        $this.text($this.val());
      });
    }
  });

  // Enhanced paste handler for contenteditable elements with PDF detection
  $('#templateBody').on("paste", '[contenteditable="true"]', function (e) {
    var clipboardData = e.originalEvent.clipboardData || window.clipboardData;
    var source = detectPasteSource(clipboardData);

    if (source === 'pdf') {
      e.preventDefault();
      var plainText = clipboardData.getData('text/plain');
      document.execCommand('insertText', false, plainText);
    }
  });
}

var blockText = function () {
  $('.label').on('mousedown', function () {
    var item = $(this).find('.item');
    if (!item.closest('.block-text').length) {
      item.attr('contenteditable', true);
    }
  });
}

var setProposalSerialNumber = function (number) {
  $('.proposal-counter span').text(number);
}

var fillSignature = function (index, className, signature, date) {
  var $element = $('.' + className);

  if (haveValue(index)) {
    $element = $element.eq(index);
  }

  var $imgElement = $element.find('img');
  $imgElement.attr('src', signature);

  var $textElement = $element.find('div');
  $textElement.text(date);
}

var getDropDownList = function (index) {
  var $element = $('div.text-dropdown-propoal').eq(index);
  var optionList = $element.attr('options');

  if (!$element.attr('ref-manual')) {
    $element.attr('ref-manual', JSON.parse(optionList).length);
  }

  var defaultOptions = parseInt($element.attr('ref-manual'));

  return JSON.stringify({
    "options": JSON.parse(optionList),
    "index": defaultOptions - 1
  });
}

var setDropDownValue = function (index, label, encodedList) {

  var $dropDown = $('div.text-dropdown-propoal').eq(index);
  $dropDown.attr('options', encodedList);

  if (label) {
    $($dropDown).text(label);
  }
}

var getDropDownValue = function (index) {
  var $dropDown = $('div.text-dropdown-propoal').eq(index);
  return $dropDown.text();
}

var updateDynamicImage = function (index, className, image) {
  var $element = $('.' + className).eq(index);
  var $imgElement = $element.find('img');
  $imgElement.attr('src', image);
}

var updateMultiSelect = function (index, encodedList) {
  var $multiChoice = $('div.multi-choice-options').eq(index);
  $multiChoice.attr('ref-list', encodedList);

  var $ul = $($multiChoice).find('ul');
  $ul.empty(); // Clearing all previous li elements

  var list = JSON.parse(encodedList); // Stores data of updated list

  // Loop through the list of objects
  $.each(list, function (index, value) {
    if (value.checked) {
      var $li = $('<li>').text(value.name);
      $li.attr('style', 'font-size: 14px;display: list-item;line-height: 20px;white-space: pre-wrap; margin-bottom: 8px; text-align: left;');
      $li.addClass('checked');
      $ul.append($li);
    }
  });
}

var getTableData = function (index) {
  var tbl = $('div.arithmetic-table-proposal table').eq(index);

  // Extracting compute column reference from table
  var computeCols = tbl.attr("ref");
  // Converting HTML json to formatted JSON
  var computeDetails = eval(computeCols) || [];
  // Extracting additional compute columns from extra references
  var exCols = tbl.attr("ref-extra") || "[]";
  // Converting HTML json to formatted JSON
  var extraCols = eval(exCols) || [];

  var Others = {};
  if (tbl.attr("ref-rule") !== undefined) {
    Others.rule = JSON.parse(tbl.attr("ref-rule"));
  }
  Others.tableId = getString($(tbl).attr("id"));
  Others.computeCols = computeDetails;
  Others.exCols = extraCols;

  var tableHead = [];
  var tableBody = [];
  var tableFoot = [];

  $.each(tbl.find("tbody tr"), function (iTr, tr) {
    var trData = {
      id: getString($(tr).attr("id")),
      tds: [],
      options: JSON.parse($(tr).attr("options")),
    };

    $.each($(tr).find("td"), function (iTh, td) {

      var obj = {
        text: getTableCellText(td), //td.text().trim() || '',
        dropdown: getTableCellDropDown(td),
        cssClass: getCellAttrClass(td),
        isNumber: $(td).attr("ref-number") || "false",
        refDb: $(td).attr("ref-db"),
        style: getTdStyle($(td).attr("style")),
        id: getString($(td).attr("id")),
        spanId: getString($(td).find("span").attr("id")),
        ddId: getString($(td).find(".cell-dd").attr("id")),
        row: iTr,
        col: iTh
      };
      trData.tds.push(obj);
    });


    tableBody.push(trData);

  });

  // thead
  $.each($(tbl).find("thead tr"), function (iTr, tr) {
    var trData = {
      id: getString($(tr).attr("id")),
      tds: [],
    };

    $.each($(tr).find("th"), function (iTh, th) {
      trData.tds.push({
        text: getTableCellText(th),
        width: $(th).outerWidth() || null,
        style: getTdStyle($(th).attr("style")),
        id: getString($(th).attr("id")),
      });
    });

    tableHead.push(trData);
  });

  // Tfoot
  $.each($(tbl).find("tfoot tr"), function (iTr, tr) {
    var trData = { id: $(tr).attr("id"), tds: [] };

    $.each($(tr).find("td"), function (iTd, td) {
      trData.tds.push({
        text: getTableCellText(td),
        id: $(td).attr("id"),
        style: getTdStyle($(td).attr("style")),
        obj: JSON.parse($(td).attr("ref-obj")),
      });
    });

    tableFoot.push(trData);
  });

  var tableBody = $.map(tableBody, function (tr) {
    var tds = [...tr.tds];

    var res = {
      tr: tr,
      tds: tds,
    };

    tr.tds = getCustomerPageData(
      Others,
      res.tds,
      res.tr.options
    );
    tr.options = res.tr.options || {};

    return tr;
  });

  return JSON.stringify({
    "head": tableHead,
    "body": tableBody,
    "foot": tableFoot,
    "other": Others,
  });
};


var getTableCellText = function (td) {
  if ($(td).hasClass("cell-with-dropdown")) {
    return $(td).find(".cell-text").html();
  }
  return $(td).text().trim();
};

var getTableCellDropDown = function (td) {
  var drop = {};

  if ($(td).hasClass("cell-with-dropdown")) {
    var dd = $(td).find(".cell-dd");
    if (dd.length > 0) {
      drop = JSON.parse(dd.attr("ref-dd"));

      if (drop.options) {
        drop.options.map(function (val, i) {
          drop.options[i] = val;
        });
      }

      drop.selectedText = drop.selectedText;
    }
  }

  return drop;
};

var getCellAttrClass = function (td) {
  var cls = $(td).attr("class") || "";

  if (!$(td).hasClass("cell-with-dropdown")) {
    cls += " cell-with-dropdown";
  }

  return cls;
};

var getTdStyle = function (style) {
  if (style) {
    return toObjectFromStyle(style);
  }

  return {};
};

var getCustomerPageData = function (tableOptions, tds, tdOptions) {
  var res = [...tds];

  if (
    tableOptions &&
    tableOptions.rule &&
    tableOptions.rule.dependentCol &&
    tableOptions.rule.dependentCol.depCol &&
    tableOptions.rule.dependentCol.mainCol &&
    tdOptions &&
    tdOptions.depPrice
  ) {
    res[tableOptions.rule.dependentCol.depCol].text = getString(tdOptions.depPrice);
  }

  return res;
};

var getString = function (val) {
  if (val !== undefined) {
    return val.toString();
  }

  return "";
}

var toObjectFromStyle = function (string) {
  var arr = string.split(";");
  var rv = {};
  for (var i = 0; i < arr.length; ++i) {
    if (arr[i]) {
      var split = arr[i].split(":");

      if (split.length > 1) {
        rv[split[0].trim()] = split[1].trim();
      }
    }
  }

  return rv;
};

var setTableData = function (index, html) {
  var element = $('div.arithmetic-table-proposal > table').eq(index);
  element.html(html);
}

var getMultiChoiceList = function (index) {
  var refList = $('div.multi-choice-options').eq(index).attr('ref-list');
  var decodedString = refList.replaceAll("&quot;", '"').replaceAll('\\\\"', '\\"')
  return JSON.parse(decodedString);
}

var getObject = function (val) {
  if (val != undefined) {
    return val;
  }
  return {};
}

var replaceText = function (text, withoutSign) {
  if (text == undefined || text == null || text == "") {
    return "";
  }

  var val = text.toString().trim();
  val = val.replaceAll("$", "");
  val = val.replaceAll("[a-zA-Z]", "");
  val = val.replaceAll("#", "");

  if (withoutSign == true) {
    val = val.replace("-", "");
    val = val.replace("+", "");
  }

  return val.replaceAll(",", "");
};

var isValidVal = function (val) {
  return (
    val != undefined &&
    val != null &&
    val != "" &&
    !isNaN(parseFloat(val)) &&
    isFinite(parseFloat(val))
  );
};


var scaleContent = function (scale) {
  document.body.style.margin = '0';
  document.body.style.padding = '0';

  var viewportmeta = document.createElement('meta');
  viewportmeta.setAttribute('name', 'viewport');
  viewportmeta.setAttribute('content', 'width=100, initial-scale=' + scale + ', minimum-scale=0.5 ,maximum-scale=2.0');
  document.getElementsByTagName('head')[0].appendChild(viewportmeta);
}

// Handle orientation changes
var handleOrientationChange = function() {
  if (window.flutter_inappwebview) {
    window.flutter_inappwebview.callHandler('onOrientationChange');
  }
}

// Listen for orientation changes
window.addEventListener('orientationchange', function() {
  setTimeout(handleOrientationChange, 200); // Small delay for orientation to complete
});

var arrayHaveValues = function (array) {
  return (array != undefined && array.includes(0));
}

var haveValue = function (val) {
  return (val != undefined && val != null);
}

var formatAmount = async function (val) {
  var result = await window.flutter_inappwebview.callHandler('formatAmount', val);
  return result;
}

var setTableCellText = function (td, val) {
  if ($(td).hasClass("cell-with-dropdown")) {
    $(td).find(".cell-text").text(val);
    return;
  }

  $(td).text(val);
};

/**
   *
   * @get Sum For Old template
   */
var getSum = function (table, index) {
  var sum = 0;
  $.each($(table).find("tbody tr"), function (iTr, tr) {
    var tdTxt = parseFloat(
      replaceText(
        getTableCellText($(tr).find("td:eq(" + index + ")"))
      )
    );
    if (isValidVal(tdTxt)) {
      sum += tdTxt;
    }
  });

  return sum;
};

/**
 *
 * @get Column  Percent
 */
var getColPercent = function (tbl, option, tr) {
  var sum = getSum(tbl, option.field),
    total = 0;

  if (!haveValue(option.cell)) {
    return 0;
  }

  if (option.cell > -1) {
    var per = parseFloat(
      replaceText(tr.cells[option.cell].textContent) || 0
    );

    if (isNaN(per)) {
      per = 0;
    }

    return parseFloat((replaceText(sum) / 100) * per);
  }

  return 0;
};

/**
 *
 * @get Cell Percent
 */
var getCelPercent = function (tbl, option, tr) {
  var total = "0.00";

  if (
    haveValue(option.field) &&
    haveValue(option.field.row) &&
    haveValue(option.field.row)
  ) {

    var mainTr = $(tbl).find("tfoot tr:eq(" + option.field.row + ")");

    if (!haveValue(option.cell)) {
      return 0;
    }

    if (option.cell > -1) {
      var f = mainTr.find("td:eq(" + option.field.cell + ")").text();
      var sum = parseFloat(replaceText(f) || 0);
      var per = parseFloat(
        replaceText(
          $(tr)
            .find("td:eq(" + option.cell + ")")
            .text()
        ) || 0
      );

      if (isNaN(per)) {
        per = 0;
      }

      total = parseFloat((sum / 100) * per);
    }
  }

  return total;
};

/**
 * @getCellSub
 */
var getCellSub = function (tbl, option) {

  var sub = option.subs || [];

  if (!Array.isArray(sub)) {
    return 0;
  }

  if (sub.length == 0) {
    return 0;
  }

  var vals = [];

  for (var i = 0; i < sub.length; i++) {
    vals.push(
      $(tbl)
        .find("tfoot tr:eq(" + sub[i].row + ")")
        .find("td:eq(" + sub[i].cell + ")")
        .text()
    );
  }

  var t = []; // replaceText(vals[0]);

  for (var i = 0; i < vals.length; i++) {
    t.push(replaceText(vals[i]) || 0);
  }

  t = eval(t.join(" - "));
  return t;
};

/**
 * @getCellMul
 */
var getCellMul = function (tr, obj) {
  var totl = 0;

  if (
    haveValue(obj) &&
    haveValue(obj.first) &&
    haveValue(obj.second)
  ) {
    totl =
      parseFloat(
        replaceText(
          getTableCellText(
            $(tr).find("td:eq(" + obj.first + ")")
          )
        ) || 0
      ) *
      parseFloat(
        replaceText(
          getTableCellText(
            $(tr).find("td:eq(" + obj.second + ")")
          )
        ) || 0
      );
  }

  if (isValidVal(totl)) {
    return totl;
  }

  return totl;
};

/**
 *
 * @get Multi Cel Calculation For Page 16
 */
var multiCalculation = function (table, obj) {
  var text = "",
    footer = [];

  $.each($(table).find("tfoot tr"), function (i, tr) {
    var row = {
      ele: $(tr),
      tds: [],
    };

    $.each($(tr).find("td"), function (i, td) {
      row.tds.push({
        text: $(td).text().trim(),
        td: $(td),
      });
    });

    footer.push(row);
  });

  if (
    haveValue(obj.first.opreation) &&
    haveValue(
      footer[obj.first.cell1.row].tds[obj.first.cell1.col].text
    ) &&
    haveValue(
      footer[obj.first.cell2.row].tds[obj.first.cell2.col].text
    )
  ) {
    text =
      replaceText(
        footer[obj.first.cell1.row].tds[obj.first.cell1.col].text
      ) || 0;
    text += " " + obj.first.opreation + " ";
    text +=
      replaceText(
        footer[obj.first.cell2.row].tds[obj.first.cell2.col].text
      ) || 0;
  }

  $.map(obj.extraCols, function (item) {
    if (
      haveValue(footer[item.cell.row].tds[item.cell.col].text) &&
      haveValue(item.opreation)
    ) {
      var val =
        replaceText(footer[item.cell.row].tds[item.cell.col].text) || "0";
      if (haveValue(replaceText(val, true))) {
        text += " " + item.opreation + " " + val;
      }
    }
  });

  return eval(text);
};

/**
 * @getCellAddition
 */
var getCellAddition = function (table, fields) {
  var sum = 0;
  $.map(fields, function (td) {
    var val = getTableCellText(
      $(table)
        .find("tfoot tr:eq(" + td.row + ")")
        .find("td:eq(" + td.cell + ")")
    );
    val = parseFloat(replaceText(val)) || 0;

    if (isValidVal(val)) {
      sum += val;
    }
  });

  return sum;
};

var updateTdValue = function (td, val) {
  setTableCellText(td, val);
};

var setFooterCalculations = async function (table) {
  for (const tr of $(table).find("tfoot tr")) {
    for (const td of $(tr).find("td")) {
      var obj = JSON.parse($(td).attr("ref-obj"));

      if (obj && haveValue(obj.operation)) {

        if (obj.operation.toLowerCase() == "sum") {
          var result = await formatAmount(getSum(table, obj.field));
          updateTdValue(td, result);
        }

        if (obj.operation == "percent") {
          updateTdValue(td, await formatAmount(getColPercent(table, obj, tr)));
        }

        if (obj.operation == "percent_cell") {
          updateTdValue(td, await formatAmount(getCelPercent(table, obj, tr)));
        }

        if (obj.operation == "sub") {
          var result = await formatAmount(getCellSub(table, obj, tr));
          updateTdValue(td, result);
        }

        if (obj.operation == "cell_addition") {
          updateTdValue(td, await formatAmount(getCellAddition(table, obj.additions)));
        }

        if (obj.operation == "cell_mul") {
          updateTdValue(td, await formatAmount(getCellMul(tr, obj.mul)));
        }

        if (obj.operation == "multi_cal") {
          updateTdValue(td, await formatAmount(multiCalculation(table, obj, tr)));
        }
      }
    }
  }
};


var updateCalculation = function (table) {
  var ref = getObject($(table).attr("ref"));

  if (arrayHaveValues(ref)) {
    ref.pop();
  }
  setFooterCalculations(table);
};

var tableSetBtn = function (table, obj) {
  $.each($(table).find("tbody tr"), function (i, tr) {
    var addBtn =
      '<div class="click-select-btn-subscribers btn-group" contenteditable="false">' +
      '<a ref="yes" style="float:left;"  class="btn btn-yes  btn-xs btn-default btn-subs pointer-event-auto">Yes</a>' +
      '<a ref="no"  style="float:left;"  class="btn btn-no btn-xs btn-default btn-primary btn-subs selected-marked pointer-event-auto">No</a>' +
      "</div> ";

    if (
      $(tr).find("td:eq(" + obj.mainCol + ") .click-select-btn-subscribers")
        .length == 0
    ) {
      $(tr)
        .find("td:eq(" + obj.mainCol + ")")
        .css("position", "relative")
        .append(addBtn);
    }

    var dVal = getString(
      getTableCellText($(tr).find("td:eq(" + obj.mainCol + ")"))
    );

    if (dVal.toLowerCase() == "yes") {
      $(tr)
        .find("td:eq(" + obj.mainCol + ")")
        .find(".click-select-btn-subscribers a")
        .removeClass("btn-primary");
      $(tr)
        .find("td:eq(" + obj.mainCol + ")")
        .find(".click-select-btn-subscribers a.btn-yes")
        .addClass("btn-primary");
    }

    if (dVal.toLowerCase() != "yes") {
      setTableCellText(
        $(tr).find("td:eq(" + obj.depCol + ")"),
        ""
      );
    }
  });


  setFooterCalculations(table);
};

var manageYesNoClick = function (ref, mainCol, depCols) {
  $(ref).parent().find("a").removeClass("btn-primary");

  $(ref).addClass("btn-primary");

  var span = $(ref).closest("td").find("span"),
    tr = $(ref).closest("tr");

  $(span).text($(ref).text());

  var options = JSON.parse($(tr).attr("options"));

  /**
   * @if btn text [YES]
   ***/
  if (
    $(ref).text().toLowerCase() == "yes" &&
    options &&
    haveValue(options.depPrice)
  ) {
    setTableCellText(
      $(tr).find("td:eq(" + depCols + ")"),
      options.depPrice
    );
  }

  /**
   * @if btn text [NO]
   ***/
  if ($(ref).text().toLowerCase() != "yes") {
    setTableCellText($(tr).find("td:eq(" + depCols + ")"), "");
  }

  /**
   * @update calculations
   ***/
  updateCalculation($(tr).closest("table"), mainCol, depCols);
};

var bindYesNoOption = function (table, obj) {

  $(table).off("click", ".click-select-btn-subscribers.btn-group a");

  tableSetBtn(table, obj);

  $(table).on("click", ".click-select-btn-subscribers.btn-group a", function (
    e
  ) {
    e.preventDefault();
    e.stopPropagation();
    manageYesNoClick(this, obj.mainCol, obj.depCol);
  });
};

var showYesNoButtons = function (table) {
  $.each(table, function (i, tbl) {
    var rule = JSON.parse($(tbl).attr("ref-rule"));

    if (haveValue(rule) &&
      haveValue(rule.dependentCol) &&
      haveValue(rule.dependentCol.mainCol) &&
      haveValue(rule.dependentCol.depCol)) {
      bindYesNoOption(tbl, rule.dependentCol);
    }
  });
};

var setTableCalculations = function () {
  $(".arithmetic-table-proposal table").each((i, ele) => {
    setFooterCalculations($(ele));
  });
}

var setUpYesNoToggles = function () {
  $(".arithmetic-table-proposal table").each((i, ele) => {
    showYesNoButtons($(ele));
  });
}

var setGridSeparators = function () {
  var importImage = $("#templateBody").find(
    ".import-image"
  );

  if (importImage.find(".img-section").length > 0) {
    importImage.find(".image-sep").remove();
    for (var i = 0; i < importImage.find(".img-section").length; i++) {
      if (i % 4 == 0 && i > 0) {
        importImage
          .find(".img-section")
          .eq(i - 1)
          .after('<div class="image-sep"></div>');
      }
    }
  }
}

var appendImage = function (crossIcon, container, textArea) {
  var div = $('<div class="img-section" />')
    .append(crossIcon)
    .append(container)
    .append(textArea);

  var importImage = $("#templateBody").find(".import-image");

  importImage.append(div);

  setTimeout(function () {
    setGridSeparators();
  }, 100);
}

var bindImageRemoveListener = function () {
  var deleteElement = $("div.image-actions");
  deleteElement.off("click");
  setTimeout(function () {
    deleteElement.click(async function (event) {
      var element = $(this).closest(".img-section");
      var src = element.find("div.image-actions-mobile").next("div").find("img").attr("src");
      var result = await window.flutter_inappwebview.callHandler('deleteImage', src);
      if (result) {
        element.remove();
        setGridSeparators();
      }
    });
  }, 100);
}

var reAssignContentEditable = function () {
  var tags = ".images-page-heading, td";
  $(".section.template-section")
    .find(tags)
    .attr("contentEditable", true);
  blockText();
};

var unFocus = function () {
    $('*').blur();
}

var hidePageEnding = function () {
    $('body > div:first').addClass('create-estimation-job');
}

// Detect if pasted content is from PDF or web
var detectPasteSource = function(clipboardData) {
  var html = clipboardData ? clipboardData.getData('text/html') : '';
  
  if (!html) return 'text';
  
  // If contains any non-PDF tags = web content
  if (/<(div|article|section|nav|ul|li|img|table|form|button|a|head|meta)/i.test(html)) {
    return 'html';
  }
  
  // Only basic tags = PDF
  return 'pdf';
}

