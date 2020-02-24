/**  We need to import the CSS so that webpack will load it.
The MiniCssExtractPlugin is used to separate it out into
its own CSS file. */
import css from "../css/app.css"

// Polyfills
import "mdn-polyfills/CustomEvent"
import "mdn-polyfills/String.prototype.startsWith"
import "mdn-polyfills/Array.from"
import "mdn-polyfills/NodeList.prototype.forEach"
import "mdn-polyfills/Element.prototype.closest"
import "mdn-polyfills/Element.prototype.matches"
import "child-replace-with-polyfill"
import "url-search-params-polyfill"
import "formdata-polyfill"
import "classlist-polyfill"
import "shim-keyboard-event-key"

// Liveview
import {Socket} from "phoenix";
import LiveSocket from "phoenix_live_view";

const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
const liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}});
liveSocket.connect();