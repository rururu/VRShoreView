// Support Cesium GUI

let defaultAction;

function addToolbarMenu (options, toolbarID, id) {
  const menu = document.createElement("select");
  menu.id = id;
  menu.className = "cesium-button";
  menu.onchange = function () {
	//window.Sandcastle.reset();
	const item = options[menu.selectedIndex];
	if (item && typeof item.onselect === "function") {
	  item.onselect();
	}
  };
  document.getElementById(toolbarID || "toolbar").appendChild(menu);

  if (!defaultAction && typeof options[0].onselect === "function") {
	defaultAction = options[0].onselect;
  }

  for (let i = 0, len = options.length; i < len; ++i) {
	const option = document.createElement("option");
	option.textContent = options[i].text;
	option.value = options[i].value;
	menu.appendChild(option);
  }
}

function updateToolbarMenu (options, toolbarID, id) {
  const menu0 = document.getElementById(id);
  const menu = document.createElement("select");
  menu.id = id;
  menu.className = "cesium-button";
  menu.onchange = function () {
	//window.Sandcastle.reset();
	const item = options[menu.selectedIndex];
	if (item && typeof item.onselect === "function") {
	  item.onselect();
	}
  };
  
  document.getElementById(toolbarID || "toolbar").replaceChild(menu, menu0);

  if (!defaultAction && typeof options[0].onselect === "function") {
	defaultAction = options[0].onselect;
  }

  for (let i = 0, len = options.length; i < len; ++i) {
	const option = document.createElement("option");
	option.textContent = options[i].text;
	option.value = options[i].value;
	menu.appendChild(option);
  }
}

function addToggleButton (text, checked, onchange, toolbarID) {
  //window.Sandcastle.declare(onchange);
  const input = document.createElement("input");
  input.checked = checked;
  input.type = "checkbox";
  input.style.pointerEvents = "none";
  const label = document.createElement("label");
  label.appendChild(input);
  label.appendChild(document.createTextNode(text));
  label.style.pointerEvents = "none";
  const button = document.createElement("button");
  button.type = "button";
  button.className = "cesium-button";
  button.appendChild(label);

  button.onclick = function () {
	//window.Sandcastle.reset();
	//window.Sandcastle.highlight(onchange);
	input.checked = !input.checked;
	onchange(input.checked);
  };

  document.getElementById(toolbarID || "toolbar").appendChild(button);
}

function addToolbarButton (text, onclick, toolbarID, id) {
  //window.Sandcastle.declare(onclick);
  const button = document.createElement("button");
  button.type = "button";
  button.className = "cesium-button";
  button.onclick = function () {
	//window.Sandcastle.reset();
	//window.Sandcastle.highlight(onclick);
	onclick();
  };
  button.textContent = text;
  button.id = id;
  document.getElementById(toolbarID || "toolbar").appendChild(button);
}

function addHeader(text, toolbarID) {
  const header = document.createElement("span");
  header.innerHTML = "<strong>"+text+"</strong>";
  document.getElementById(toolbarID || "toolbar").appendChild(header);
}

function addToolbarNumber (min, value, max, onchange, toolbarID, id) {
  //window.Sandcastle.declare(onclick);
  const input = document.createElement("input");
  input.type = "number";
  input.min = min;
  input.value = value;
  input.max = max;
  input.className = "cesium-number";
  input.oninput = function () {
	onchange(this.value);
  };
  input.onchange = function () {
	onchange(this.value);
  };
  input.id = id;
  document.getElementById(toolbarID || "toolbar").appendChild(input);
}


