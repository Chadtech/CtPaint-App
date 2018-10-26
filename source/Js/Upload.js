module.exports = function (toElm) {
    var fileUploader = document.createElement("input");
    fileUploader.type = "file";

    var upload = makeUploader(toElm, fileUploader);
    fileUploader.addEventListener("change", upload);

    return function () {
        fileUploader.click();
    }
}


function makeUploader(toElm, fileUploader) {
    return function (event) {
        var reader = new FileReader();

        reader.onload = function () {
            toElm("file read", reader.result);
            fileUploader.value = "";
        };

        var imageIndex = ["image/png", "image/jpeg"].indexOf(
            fileUploader.files[0].type
        );

        if (imageIndex !== -1) {
            reader.readAsDataURL(fileUploader.files[0]);
        } else {
            toElm("file not image", null);
            fileUploader.value = "";
        }


    }
}