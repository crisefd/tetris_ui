/**  We need to import the CSS so that webpack will load it.
The MiniCssExtractPlugin is used to separate it out into
its own CSS file. */
import css from "../css/app.css"

// Polyfills
import "mdn-polyfills/Object.assign"
import "mdn-polyfills/CustomEvent"
import "mdn-polyfills/String.prototype.startsWith"
import "mdn-polyfills/Array.from"
import "mdn-polyfills/Array.prototype.find"
import "mdn-polyfills/NodeList.prototype.forEach"
import "mdn-polyfills/Element.prototype.closest"
import "mdn-polyfills/Element.prototype.matches"
import "mdn-polyfills/Node.prototype.remove"
import "child-replace-with-polyfill"
import "url-search-params-polyfill"
import "formdata-polyfill"
import "classlist-polyfill"
import "@webcomponents/template"
import "shim-keyboard-event-key"
import "core-js/features/set"

// Liveview
import {Socket} from "phoenix";
import LiveSocket from "phoenix_live_view";

const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
const liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}});
liveSocket.connect();


// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
window.liveSocket = liveSocket;