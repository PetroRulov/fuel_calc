// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).
//import "../css/app.css"

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "./vendor/some-package.js"
//
// Alternatively, you can `npm install some-package` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

function hideAllOther(nodes, thisId) {
    for (var i = 0; i < nodes.length; i++) {
        if (nodes[i].id != thisId) {
            nodes[i].style.display = "none";
        }
    }
}

window.displayOrHide = function displayOrHide(elementId) {
    event.stopPropagation();
    var hideable = document.querySelectorAll(".hideable");
    hideAllOther(hideable, elementId);

    var elem = document.getElementById(elementId);
    if (elem.style.display != "block") {
        elem.style.display = "block";
    } else {
        elem.style.display = "none";
    }
}

window.remove = function remove(parentId, elemId) {
    var parent = document.getElementById(parentId);
    parent.removeChild(document.getElementById(elemId));
}

window.appendRoute = function appendRoute(imgSrc) {
    var routesList = document.getElementById("routes_list");
    console.log(routesList)
    var newLi = document.createElement('li');
    var newId = `route_${routesList.children.length}`
    console.log(newId)
    newLi.id = newId;


    var byLabel = document.createElement("LABEL");
	byLabel.innerHTML = "FLY by:";
	byLabel.setAttribute("class", "bold-label label-inline");
	byLabel.setAttribute("style", "margin-left: 2.0rem;");

    var bySelect = document.createElement('select');
    bySelect.name = "routes[][by]";
    bySelect.style['margin-left'] = '2.0rem';
    bySelect.required = true;
    bySelect.autocomplete = 'off';

    let byApolloOption = document.createElement('option');
    byApolloOption.value = "Apollo_11";
    byApolloOption.selected = true;
    byApolloOption.text = "Apollo_11";

    let byMarsOption = document.createElement('option');
    byMarsOption.value = "Mars_Mission";
    byMarsOption.selected = false;
    byMarsOption.text = "Mars_Mission";

    let byPassengerOption = document.createElement('option');
    byPassengerOption.value = "Passenger_Ship";
    byPassengerOption.selected = false;
    byPassengerOption.text = "Passenger_Ship";
    
    bySelect.appendChild(byApolloOption)
    bySelect.appendChild(byMarsOption)
    bySelect.appendChild(byPassengerOption)


	var launchLabel = document.createElement("LABEL");
	launchLabel.innerHTML = "LAUNCH from:";
	launchLabel.setAttribute("class", "bold-label label-inline");
	launchLabel.setAttribute("style", "margin-left: 2.0rem;");

    var launchSelect = document.createElement('select');
    launchSelect.name = "routes[][launch]";
    launchSelect.style['margin-left'] = '2.0rem';
    launchSelect.required = true;
    launchSelect.autocomplete = 'off';

    let launchEarthOption = document.createElement('option');
    launchEarthOption.value = "Earth";
    launchEarthOption.selected = true;
    launchEarthOption.text = "Earth";

    let launchMarsOption = document.createElement('option');
    launchMarsOption.value = "Mars";
    launchMarsOption.selected = false;
    launchMarsOption.text = "Mars";

    let launchMoonOption = document.createElement('option');
    launchMoonOption.value = "Moon";
    launchMoonOption.selected = false;
    launchMoonOption.text = "Moon";

    launchSelect.appendChild(launchEarthOption)
    launchSelect.appendChild(launchMarsOption)
    launchSelect.appendChild(launchMoonOption)


    var landingLabel = document.createElement("LABEL");
	landingLabel.innerHTML = "LANDING on:";
	landingLabel.setAttribute("class", "bold-label label-inline");
	landingLabel.setAttribute("style", "margin-left: 2.0rem;");

    var landingSelect = document.createElement('select');
    landingSelect.name = "routes[][landing]";
    landingSelect.style['margin-left'] = '2.0rem';
    landingSelect.required = true;
    landingSelect.autocomplete = 'off';

    let landingEarthOption = document.createElement('option');
    landingEarthOption.value = "Earth";
    landingEarthOption.selected = true;
    landingEarthOption.text = "Earth";

    let landingMarsOption = document.createElement('option');
    landingMarsOption.value = "Mars";
    landingMarsOption.selected = false;
    landingMarsOption.text = "Mars";

    let landingMoonOption = document.createElement('option');
    landingMoonOption.value = "Moon";
    landingMoonOption.selected = false;
    landingMoonOption.text = "Moon";

    landingSelect.appendChild(landingEarthOption)
    landingSelect.appendChild(landingMarsOption)
    landingSelect.appendChild(landingMoonOption)

    var newImg = document.createElement('img');
    newImg.classList.add('intext-icon');
    newImg.style['margin-left'] = '2.0rem';
    newImg.onclick = function(){remove('routes_list', newId)};
    newImg.src = imgSrc;
    newLi.appendChild(byLabel);
    newLi.appendChild(bySelect);
	newLi.appendChild(launchLabel);
    newLi.appendChild(launchSelect);
	newLi.appendChild(landingLabel);
    newLi.appendChild(landingSelect);
    newLi.appendChild(newImg);
    routesList.insertBefore(newLi, document.getElementById('new_route'));
};
