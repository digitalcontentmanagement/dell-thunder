//Start of dynamically call external sources
function loadjscssfile(tagname, filename, filetype) {
    if (filetype == "js") { //if filename is a external JavaScript file
        var fileref = document.createElement('script')
        fileref.setAttribute("type", "text/javascript")
        fileref.setAttribute("src", filename)
    }
    else if (filetype == "css") { //if filename is an external CSS file
        var fileref = document.createElement("link")
        fileref.setAttribute("rel", "stylesheet")
        fileref.setAttribute("type", "text/css")
        fileref.setAttribute("href", filename)
    }
    if (typeof fileref != "undefined")
        document.getElementsByTagName(tagname)[0].appendChild(fileref)
}
//End of dynamically call external sources

//Start of Cookie
var saveclass = null;

function saveValue(id, cookieValue) {
    var sel = document.getElementById(id);
    setCookie(id, cookieValue, 365);
}

function setCookie(cookieName, cookieValue, nDays) {
    var today = new Date();
    var expire = new Date();

    if (nDays == null || nDays == 0)
        nDays = 1;

    expire.setTime(today.getTime() + 3600000 * 24 * nDays);
    document.cookie = cookieName + "=" + escape(cookieValue) + ";expires=" + expire.toGMTString();
}

function readCookie(name) {
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    for (var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') c = c.substring(1, c.length);
        if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length, c.length);
    }
    return ''; //set to empty instead of null for XSLT
}
//End of Cookie

//Start of Query String
//helpers.getQueryStringParameter(param)
+function (window, document, undefined) {

    var h = {

        /// <summary>
        /// Fetches a query string value from the URL based on its name
        /// and returns its value.
        /// </summary>
        getQueryStringParameter: function (parameter) {
            // http://stackoverflow.com/questions/901115/how-can-i-get-query-string-values
            parameter = parameter.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
            var regexS = "[\\?&]" + parameter + "=([^&#]*)";
            var regex = new RegExp(regexS);
            var results = regex.exec(window.location.search);
            if (results == null)
                return "";
            else
                return decodeURIComponent(results[1].replace(/\+/g, " "));
        }

    };

    // throw 'h' into global scope to allow calling.
    window.helpers = h;

} (window, document);
//End of Query String

//Start of Select Options Control
function selectOptions(id, param) {
    var select = document.getElementById(id)
    for (var i = 0; i < select.options.length; i++) {
        if (select.options[i].value == param) {
            select.options[i].selected = true;
        }
    }
}
//End of Select Options Control

//Start of Word Count
if (typeof String.prototype.trim !== 'function') {
    String.prototype.trim = function () {
        return this.replace(/^\s+|\s+$/g, '');
    }
}

function get_text(el) {
    ret = "";
    var length = el.childNodes.length;
    for (var i = 0; i < length; i++) {
        var node = el.childNodes[i];
        //Check if nodeType belongs to comment, h1 and span then excluding them
        if (node.nodeType != 8 && node.nodeName.toLowerCase() != 'h1' && (!(node.nodeName.toLowerCase() == 'span' && node.getAttribute("name"))) && node.nodeName.toLowerCase() != 'select') {
            //Check if nodeType belongs to element node
            ret += node.nodeType != 1 ? node.nodeValue : get_text(node) + " ";
        }
    }
    return ret;
}

function wordcount(idToCount, idToDisplayCount) {
    if (document.getElementById(idToCount)) {
        var words = get_text(document.getElementById(idToCount)).toString().trim();
        var count = words.split(/\s+/).length;
        document.getElementById(idToDisplayCount).innerHTML = count;
    }
}
//End of Word Count


//Start of Input Text Autosize
(function ($) {

    // jQuery autoGrowInput plugin by James Padolsey
    // See related thread: http://stackoverflow.com/questions/931207/is-there-a-jquery-autogrow-plugin-for-text-fields

    $.fn.autoGrowInput = function (o) {

        o = $.extend({
            maxWidth: 1000,
            minWidth: 0,
            comfortZone: 70
        }, o);

        this.filter('input:text').each(function () {

            var minWidth = o.minWidth || $(this).width(),
            val = '',
            input = $(this),
            testSubject = $('<tester/>').css({
                position: 'absolute',
                top: -9999,
                left: -9999,
                width: 'auto',
                fontSize: input.css('fontSize'),
                fontFamily: input.css('fontFamily'),
                fontWeight: input.css('fontWeight'),
                letterSpacing: input.css('letterSpacing'),
                whiteSpace: 'nowrap'
            }),
            check = function () {

                if (val === (val = input.val())) { return; }

                // Enter new content into testSubject
                var escaped = val.replace(/&/g, '&amp;').replace(/\s/g, '&nbsp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
                testSubject.html(escaped);

                // Calculate new width + whether to change
                var testerWidth = testSubject.width(),
                    newWidth = (testerWidth + o.comfortZone) >= minWidth ? testerWidth + o.comfortZone : minWidth,
                    currentWidth = input.width(),
                    isValidWidthChange = (newWidth < currentWidth && newWidth >= minWidth)
                                         || (newWidth > minWidth && newWidth < o.maxWidth);

                // Animate width
                if (isValidWidthChange) {
                    input.width(newWidth);
                }

            };

            testSubject.insertAfter(input);

            $(this).bind('keyup keydown blur update', check);

            check();
        });

        return this;

    };

})(jQuery);
//End of Input Text Autosize

//Start of Multiple Select Value(s) Reader
// Return an array of the selected option values
// select is an HTML select element or object (Not ID)
function getSelectValues(select) {
    var result = [];
    var options = select && select.options;
    var opt;
    if (options) {
        for (var i = 0, iLen = options.length; i < iLen; i++) {
            opt = options[i];

            if (opt.selected) {
                result.push(opt.value || opt.text);
            }
        }
        return result;
    }
}
//End of Multiple Select Value(s) Reader

//Start of Associate Controls
function AssociateUpdate(id) {
    $("span[name='" + id + "']").html($("#" + id).val());
}

function AssociateDropdownlistUpdate(id) {
    $.each($("#" + id).find(":selected").data("value"), function (index, name) {

        $("span[name='" + id + "-" + name.lang + "']").html(name.value);

    });
}
//End of Associate Controls

//Start of checking if XML file exists
function UrlExists(url) {
    try {
        var http = new XMLHttpRequest();
        http.open('HEAD', url, false);
        http.send();
        return http.status != 404;
    } catch (error) {
        return;
    }
}
//End of checking if XML file exists


//Start of Loading spinner
var opts = {
    lines: 17 // The number of lines to draw
, length: 0 // The length of each line
, width: 11 // The line thickness
, radius: 41 // The radius of the inner circle
, scale: 0.5 // Scales overall size of the spinner
, corners: 0 // Corner roundness (0..1)
, color: '#FFF' // #rgb or #rrggbb or array of colors
, opacity: 0.15 // Opacity of the lines
, rotate: 0 // The rotation offset
, direction: 1 // 1: clockwise, -1: counterclockwise
, speed: 1.3 // Rounds per second
, trail: 48 // Afterglow percentage
, fps: 20 // Frames per second when using setTimeout() as a fallback for CSS
, zIndex: 2e9 // The z-index (defaults to 2000000000)
, className: 'spinner' // The CSS class to assign to the spinner
, top: '50%' // Top position relative to parent
, left: '50%' // Left position relative to parent
, shadow: false // Whether to render a shadow
, hwaccel: false // Whether to use hardware acceleration
, position: 'absolute' // Element positioning
}
/*var spinner = new Spinner().spin()
target.appendChild(spinner.el)*/
//End of Loading spinner

//Start of Modal Overlay
function overlay() {
    var el = document.getElementById("modal-layer");
    var target = document.getElementById("loader");
    el.style.display = (el.style.display == "block") ? "none" : "block";
    if (el.style.display == "block") {
        new Spinner(opts).spin(target);
		return true;
    }
    else {
        $(".spinner").remove();
		return false;
    }
}
function progressive(text) {
    var mdl = document.getElementById("text");
    mdl.innerText = text || "Initializing...";
    mdl.textContent = text || "Initializing...";
}
//End of Modal Overlay

//Start of Display
function exportOption(selectedValue) {
    var local = document.getElementById("local");
    var remote = document.getElementById("remote");
    var cookies = readCookie("template_export");

    if (local == null || remote == null)
        return;

    if (selectedValue == 'local' || cookies == 'local') {
        local.style.display = "block";
        remote.style.display = "none";
    }
    else {
        remote.style.display = "block";
        local.style.display = "none";
    }
}
//End if Display
