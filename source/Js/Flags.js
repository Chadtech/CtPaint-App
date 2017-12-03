module.exports = {
    make: function(mixins) {
        var localWork = localStorage.getItem("local work");
        return {
            windowHeight: window.innerHeight,
            windowWidth: window.innerWidth,
            seed: Math.round(Math.random() * 999999999999),
            isMac: window.navigator.userAgent.indexOf("Mac") !== -1,
            isChrome: window.navigator.userAgent.indexOf("Chrome") !== -1,
            user: mixins.user,
            init: mixins.manifest.initMsg,
            localWork: JSON.parse(localWork),
            mountPath: mixins.manifest.mountPath,
        }; 
    }
}