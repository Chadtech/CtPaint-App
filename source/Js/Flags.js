module.exports = {
    make: function(mixins) {
        var localWork = localStorage.getItem("local work");

        var buf = new Uint32Array(1);
        window.crypto.getRandomValues(buf);
        var milliseconds = new Date().getMilliseconds()
        var seed = (buf[0] * 1000) + milliseconds;

        return {
            windowHeight: window.innerHeight,
            windowWidth: window.innerWidth,
            seed: seed,
            isMac: window.navigator.userAgent.indexOf("Mac") !== -1,
            isChrome: window.navigator.userAgent.indexOf("Chrome") !== -1,
            user: mixins.user,
            init: mixins.manifest.initMsg,
            localWork: JSON.parse(localWork),
            mountPath: mixins.manifest.mountPath,
        }; 
    }
}