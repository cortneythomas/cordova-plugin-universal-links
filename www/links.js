const exec = require("cordova/exec");

const PLUGIN_NAME = "UniversalLinks";
const DEFAULT_EVENT_NAME = "didLaunchAppFromLink";

// Plugin methods on the native side that can be called from JavaScript
const pluginNativeMethod = {
  SUBSCRIBE: "jsSubscribeForEvent",
  UNSUBSCRIBE: "jsUnsubscribeFromEvent",
};

const UniversalLinks = {
  echo: function (phrase, callback) {
    exec(callback, null, PLUGIN_NAME, "echo", [phrase]);
  },
  subscribe: function (eventName, callback) {
    console.log('cortney eventname in subscribe', eventName)
    if (!callback) {
      console.warn(
        "Universal Links: no callback provided for subscribe method. Cannot subscribe to events without callback."
      );
      return;
    }

    if (!eventName) {
      eventName = DEFAULT_EVENT_NAME;
    }

    const innerCallback = function (msg) {
      callback(msg.data);
    };

    exec(innerCallback, null, PLUGIN_NAME, pluginNativeMethod.SUBSCRIBE, [
      eventName,
    ]);
  },
  unsubscribe: function (eventName) {
    console.log('cortney eventname in unsubscribe', eventName)
    if (!eventName) {
      eventName = DEFAULT_EVENT_NAME;
    }

    exec(null, null, PLUGIN_NAME, pluginNativeMethod.UNSUBSCRIBE, [eventName]);
  },
};

module.exports = UniversalLinks;
