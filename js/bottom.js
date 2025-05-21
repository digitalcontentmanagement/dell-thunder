//Start of Tooltip
/***********************************************
* Cool DHTML tooltip script- (c) Dynamic Drive DHTML code library (www.dynamicdrive.com)
* Please keep this notice intact
* Visit Dynamic Drive at http://www.dynamicdrive.com/ for full source code
***********************************************/

function create(htmlStr) {
    var frag = document.createDocumentFragment(),
        temp = document.createElement('div');
    temp.innerHTML = htmlStr;
    while (temp.firstChild) {
        frag.appendChild(temp.firstChild);
    }
    return frag;
}

var fragment = create("<div id='dhtmltooltip'></div>");
// You can use native DOM methods to insert the fragment:
document.body.insertBefore(fragment, document.body.childNodes[0]);

var offsetxpoint = -60 //Customize x offset of tooltip
var offsetypoint = 20 //Customize y offset of tooltip
var ie = document.all
var ns6 = document.getElementById && !document.all
var enabletip = false
if (ie || ns6)
    var tipobj = document.all ? document.all["dhtmltooltip"] : document.getElementById ? document.getElementById("dhtmltooltip") : ""
document.body.appendChild(tipobj)

function ietruebody() {
    return (document.compatMode && document.compatMode != "BackCompat") ? document.documentElement : document.body
}

function ddrivetip(thetext, thewidth, thecolor) {
    if (!thetext)
        return false;
    if (ns6 || ie) {
        if (typeof thewidth != "undefined") tipobj.style.width = thewidth;
        if (typeof thecolor != "undefined" && thecolor != "") tipobj.style.backgroundColor = thecolor
        tipobj.innerHTML = '<h1>HTML Preview</h1>' + thetext.replace(/<style type="text\/css">.*?<\/style>/g, ''); //Removing Style tag for harmony CSS injection
        //Start of InnerHTML Scripting Executor
        /*var scripts = [];

        ret = tipobj.childNodes;
        for (var i = 0; ret[i]; i++) {
        if (scripts && nodeName(ret[i], "script") && (!ret[i].type || ret[i].type.toLowerCase() === "text/javascript")) {
        scripts.push(ret[i].parentNode ? ret[i].parentNode.removeChild(ret[i]) : ret[i]);
        }
        }

        for (script in scripts) {
        evalScript(scripts[script]);
        }*/
        //End of InnerHTML Scripting Executor

        enabletip = true
        return false
    }
}

function ddriveimagetip(thetext, thewidth, thecolor) {
    if (!thetext)
        return false;
    if (ns6 || ie) {
        if (typeof thewidth != "undefined") tipobj.style.width = thewidth;
        if (typeof thecolor != "undefined" && thecolor != "") tipobj.style.backgroundColor = thecolor
        tipobj.innerHTML = "<h1>HTML Image Preview</h1><img src=\"" + thetext.trim() + "\" onerror=\"this.src='images/puzzle.png'\"/>";
        enabletip = true
        return false
    }
}

function positiontip(e) {
    if (enabletip) {
        var curX = (ns6) ? e.pageX : event.clientX + ietruebody().scrollLeft;
        var curY = (ns6) ? e.pageY : event.clientY + ietruebody().scrollTop;
        //Find out how close the mouse is to the corner of the window
        var rightedge = ie && !window.opera ? ietruebody().clientWidth - event.clientX - offsetxpoint : window.innerWidth - e.clientX - offsetxpoint - 20
        var bottomedge = ie && !window.opera ? ietruebody().clientHeight - event.clientY - offsetypoint : window.innerHeight - e.clientY - offsetypoint - 20

        var leftedge = (offsetxpoint < 0) ? offsetxpoint * (-1) : -1000

        //if the horizontal distance isn't enough to accomodate the width of the context menu
        if (rightedge < tipobj.offsetWidth)
        //move the horizontal position of the menu to the left by it's width
            tipobj.style.left = ie ? ietruebody().scrollLeft + event.clientX - tipobj.offsetWidth + "px" : window.pageXOffset + e.clientX - tipobj.offsetWidth + "px"
        else if (curX < leftedge)
            tipobj.style.left = "5px"
        else
        //position the horizontal position of the menu where the mouse is positioned
            tipobj.style.left = curX + offsetxpoint + "px"

        //same concept with the vertical position
        if (bottomedge < tipobj.offsetHeight)
            tipobj.style.top = ie ? ietruebody().scrollTop + event.clientY - tipobj.offsetHeight - offsetypoint + "px" : window.pageYOffset + e.clientY - tipobj.offsetHeight - offsetypoint + "px"
        else
            tipobj.style.top = curY + offsetypoint + "px"
        tipobj.style.visibility = "visible";
        tipobj.style.display = "block";//Turning on display CSS for the first time mouseover. It was set none to discard an additional space at the bottom.
    }
}

function hideddrivetip() {
    if (ns6 || ie) {
        enabletip = false;
        tipobj.style.visibility = "hidden";
        tipobj.style.left = "-1000px";
        tipobj.style.backgroundColor = '';
        tipobj.style.width = '';
    }
}

document.onmousemove = positiontip
//End of Tooltip

//Start of InnerHTML Scripting Executor
/*function nodeName(elem, name) {
return elem.nodeName && elem.nodeName.toUpperCase() === name.toUpperCase();
}
function evalScript(elem) {
data = (elem.text || elem.textContent || elem.innerHTML || "");

var head = document.getElementsByTagName("head")[0] || document.documentElement,
script = document.createElement("script");
script.type = "text/javascript";
script.appendChild(document.createTextNode(data));
head.insertBefore(script, head.firstChild);
head.removeChild(script);

if (elem.parentNode) {
elem.parentNode.removeChild(elem);
}
}*/
//End of InnerHTML Scripting Executor

//Start of autofocusing
$(function () { $('[autofocus]').focus() });
//End of autofocusing

//Start of creating Market options
//Reading cookie to default the selection for Default Profile
var cookie = readCookie("default_region_thunder");
selectOptions("default_region_thunder", cookie);

//Start of creating Template options
//Reading cookie to default the selection for Template Options
var cookie_template = readCookie("template_export");
if (document.getElementById("template_export")) {
    selectOptions("template_export", cookie_template);
    exportOption(); //Hide or Show DIV during load
}

//Start of SKU Info: Region
var sku_region = document.getElementById("sku_region");
if (sku_region && cookie != '') {
    sku_region.innerHTML = (cookie != 'global') ? cookie.toUpperCase() : "Global";
}
//End of SKU Info: Region

magicXML.transformAndReplace('#markets_loader', 'content/data/definitions/locales.xml', 'xslt/markets.xslt', [{ name: 'region', value: cookie}]);
//End of creating Market options

//Start of Dynamic XML loader
function CategoryLoader(id, xml, xsl, parameter, v, ctrlid) {
    if (v.length > 3) {
        magicXML.transformAndReplace(id, xml, xsl, [{ name: parameter, value: v }, { name: 'region', value: cookie}]);
        var control = document.getElementById(ctrlid);
        if (control) {
            //http://ewbi.blogs.com/develops/2006/07/onchange_handle.html
            if (typeof (control.onchange) == "function") {
                control.onchange();
            }
        }
    }
}

//Start of Enter event on SKU control
$('#sku').on('keyup', function (e) {
    var skucontrol = document.getElementById("sku");
    var skutype = document.getElementsByName("sku_type");
    var skunote = document.getElementById("sku_note");
    if (e.which == 13 && skucontrol.value.length > 3) {
        if (skucontrol) {
            if (skutype) {
                for (var i = 0; i < skutype.length; i++) {
                    skutype[i].disabled = false;
                    skutype[i].previousSibling.className = "radio";
                    skutype[i].previousSibling.onmousedown = Custom.pushed; //From custom-form-elements.js
                    skutype[i].previousSibling.onmouseup = Custom.check; //From custom-form-elements.js
                }
            }
            var defaultText = skunote.innerText || skunote.textContent; var loadingText = "Loading Products...";
            skunote.innerText = loadingText;
            skunote.textContent = loadingText;
            CategoryLoader('#category_loader', 'content/data/definitions/products.xml', 'xslt/product_category.xslt', 'skuid', skucontrol.value, 'category');
            skunote.innerText = defaultText;
            skunote.textContent = defaultText;
            skunote.style.visibility = "hidden";
        }
    }
    else {
        skucontrol.value = skucontrol.value.replace(/[^a-zA-Z0-9\-]/g, '');
		jQuery('#sku').on('input propertychange paste', function() {
            var cat = document.getElementById("category");
            var scc = document.getElementById("subclass");
            if (skutype) {
                for (var i = 0; i < skutype.length; i++) {
                    skutype[i].disabled = true;
                    skutype[i].checked = false;
                    skutype[i].previousSibling.className = "radio disabled";
                    skutype[i].previousSibling.style.backgroundPosition = "0 0";
                    skutype[i].previousSibling.style.color = "#404040";
                    skutype[i].previousSibling.onmousedown = "";
                    skutype[i].previousSibling.onmouseup = "";
                }
            }
            if (cat) {
                cat.disabled = true;
                cat.selectedIndex = 0; //reset to first item for Category
            }
            if (scc) {
                scc.disabled = true;
                scc.selectedIndex = 0; //reset to first item for Subclass
            }
            skunote.style.visibility = "hidden";
		});
        
		if(skucontrol.value.length > 3) {
            skunote.style.visibility = "visible";
        }
    }
});
//End of Enter event on SKU control

function SubclassLoader(id, xml, xsl, parameter, v, parameter2, v2, ctrlid, ctrlv) {
    if (v.selectedIndex > 0) {
        magicXML.transformAndReplace(id, xml, xsl, [{ name: parameter, value: v.value }, { name: parameter2, value: v2}]);
    }
    else {
        document.getElementById(ctrlid).disabled = true;
        selectOptions(ctrlid, ctrlv); //reset to first item for Subclass
    }
}
//End of Dynamic XML loader

//Start of Generic Content
var g_XmlData; //Convert Content Studio CSV data into XML format
var g_CSVFileName;

function GenerateGenericContent(id) {
    if (document.forms[id]) {

        var sku = document.forms[id].sku.value;
        var skutype = document.forms[id].sku_type;
        var cat = document.forms[id].category;
        var scc = document.forms[id].subclass;
        var mkt = document.forms[id].markets;
		var csv = document.forms[id].file_upload;

        if (sku == null || skutype == null || cat == null || scc == null || mkt == null || csv == null)
            return;

        if (sku == '') {
            alert("No SKU was entered.");
            return;
        }

        var skutype_value;
        for (var i = 0; i < skutype.length; i++) {
            if (skutype[i].checked) {
                skutype_value = skutype[i].value;
            }
        }
        if (!skutype_value) {
            alert("No SKU type was selected or enabled.\n\nPlease select either Customer Kit or Spare Parts.");
            return;
        }

        if (cat.selectedIndex == 0 || cat.disabled) {
            alert("No product category was selected or enabled.");
            return;
        }

        if (scc.selectedIndex == 0 || cat.disabled) {
            alert("No product subclass was selected or enabled.");
            return;
        }

        if (mkt.selectedIndex == -1) {
            alert("No market was selected.");
            return;
        }

		if(csv.value === ""){
			alert("No CSV file was selected or due to recent changes on market selection, please reselect.");
			return;
		}

        /*if (document.getElementById("results-not-found") && document.getElementById("flash-screen")) {
        document.getElementById("results-not-found").style.display = "block";
        document.getElementById("flash-screen").style.display = "none";
        }
        if (document.getElementById("placeholder")) {
        document.getElementById("placeholder").style.display = "hidden";
        }*/

        var foldername = scc.value.substring(scc.value.indexOf("_") + 1, scc.value.length);

        var subclasscode = scc.value.substring(0, scc.value.indexOf("_")).replace(/[^0-9]/g, "");

        var xmlPath = 'content/data/products/' + cat.value + '/' + foldername + '/english.xml';

        var xmlImagePath = 'content/data/products/' + cat.value + '/imagebase.xml';

        if (UrlExists(xmlPath)) {

            try {

                overlay();
                progressive("Fetching content...");

                magicXML.transformAndReplace('#generic-content', xmlPath, 'xslt/generic_content.xslt', [{ name: 'region', value: cookie }, { name: 'skuid', value: sku }, { name: 'skutype', value: skutype_value}]);
                
                //Start of Imagebase
                var imglib = document.getElementById("image-library");
                imglib.style.display = "block";

                if (UrlExists(xmlImagePath))
                    magicXML.transformAndReplace('#album', xmlImagePath, 'xslt/imagebase.xslt', [{ name: 'categoryid', value: cat.value }, { name: 'foldername', value: foldername}]);
                else {
                    var album = document.getElementById("album");
                    album.innerHTML = "<span class=\"message\">No image available for this product.</span>";
                }
                //End of Imagebase
            }
            catch (error) {
                switch (error.name) {
                    case "RangeError":
                        alert("The required content XML files were not found.\n\nPlease contact your tool developer."); break;
                    default:
			{
				console.log(error.message);
                        	alert("Generic content editor error encountered. Please contact your tool developer.");
			}
                }
                return;
            }

            //Start of Counting Words
            wordcount("placeholder", "counter");
            //End of Counting Words

            //Start of SKU Info: No of Market
            var sku_mkt = document.getElementById("sku_mkt");
            if (sku_mkt) {
                /*edits = (getSelectValues(mkt).toString().match(/,/g) || []).length + 1;*/
                selectedmkt = $('#markets option:selected').length;
                sku_mkt.innerHTML = selectedmkt;
                sku_mkt.setAttribute("title", selectedmkt + " market(s)");
            }
            //End of SKU Info: No of Market

            //Start of SKU Info: Subclass
            var sku_scc = document.getElementById("sku_scc");
            if (sku_scc) {
                sku_scc.innerHTML = subclasscode;
            }
            //End of SKU Info: Subclass

            //Start of Auto resizing
            $(function () {
                $("input.unique").autoGrowInput({ minWidth: 10, comfortZone: 10 });
            });
            //End of Auto resizing

            try {
				progressive("Generating Content Studio Template...");
                //Start of Content Studio Template
				$("#csvfilename").text(g_CSVFileName);
				$("#csvfilename").prop("title", g_CSVFileName);
                magicXML.transformAndReplace('#csd-template-holder', xmlPath, 'xslt/template_csd.xslt', [{ name: 'region', value: cookie }, { name: 'skuid', value: sku }, { name: 'skutype', value: skutype_value }, { name: 'categoryid', value: cat.value }, { name: 'subclass', value: subclasscode }, { name: 'markets', value: getSelectValues(mkt).toString() }, { name: 'foldername', value: foldername}, { name: 'csvdata', value: g_XmlData}]);
                //End of Content Studio Template

                progressive("Generating PRC Template...");
                //Start of PRC Template
                magicXML.transformAndReplace('#prc-template-holder', xmlPath, 'xslt/template_prc.xslt', [{ name: 'region', value: cookie }, { name: 'skuid', value: sku }, { name: 'skutype', value: skutype_value }, { name: 'categoryid', value: cat.value }, { name: 'subclass', value: subclasscode }, { name: 'markets', value: getSelectValues(mkt).toString() }, { name: 'foldername', value: foldername}]);
                //End of PRC Template

                progressive("Generating Harmony Template...");
                //Start of Harmony Template
                magicXML.transformAndReplace('#hmy-template-holder', xmlPath, 'xslt/template_hmy.xslt', [{ name: 'region', value: cookie }, { name: 'skuid', value: sku }, { name: 'skutype', value: skutype_value }, { name: 'categoryid', value: cat.value }, { name: 'subclass', value: subclasscode }, { name: 'markets', value: getSelectValues(mkt).toString() }, { name: 'foldername', value: foldername}]);
                //End of Harmony Template

                var template = document.getElementById("template-export");
                if (template)
                    template.style.display = "block";

                progressive("Completed");
                overlay();

				alert("Your generic content is ready!");
								
				var theTbl = document.getElementById('csd-template');
				var theTblH = theTbl.getElementsByTagName('th');
				var trs = document.querySelectorAll('#csd-template tbody tr');
				var sku_input = $('#sku').val().trim().toUpperCase();

				for(var c=0;c<theTblH.length;c++)
				{
					if(theTblH[c].innerHTML.toString().trim().toLowerCase() == "manufacturerpn")
					{
						for(var r = 0; r < trs.length; r++) 
						{
							if(trs[r].cells[c].innerHTML.trim().toUpperCase()!=sku_input)
							{
								$('<div id="notification"><div class="title">Caution</div><div class="body"><img src="images/caution.png" width="64" height="64" align="middle" hspace="15" vspace="5" title="Caution"/>The entered SKU <b>' + sku_input + '</b> was found mismatch with either one or all of the <b>Manufacturer Part Number(s)</b> on the imported Content Studio CSV template. Please ignore this message if you have confirmed correct CSV file was imported.</div></div>')
									.insertBefore('#footer_container')
									.delay(14000)
									.fadeOut(function() {
									  $(this).remove(); 
								});
								return;
							}			
						}
					}
				}
				
            } catch (error) {
                switch (error.name) {
                    case "RangeError":
                        alert("Unable to create template table for data export.\n\nPlease check the generic content XML file(s) available for the selected market(s) with its respective language(s) in order to export data.\n\n"); break;
                    default:
                        alert("Unable to create template table for data export.");
                }
                return;
            }
        }
        else {
            alert("No generic content source was found!");
        }
    }
}
//End of Generic Content

//Start of Resetting all controls
function Reinstate(id) {

    var form = document.forms[id];

    if (form) {

        var sku = form.sku;
        var skutype = form.sku_type;
        var cat = form.category;
        var scc = form.subclass;
        var mkt = form.markets;
		var csv = form.file_upload;
        var sku_scc = document.getElementById("sku_scc");
        var sku_mkt = document.getElementById("sku_mkt");
        var sku_note = document.getElementById("sku_note");
        var word_count = document.getElementById("counter");
        var selectall = document.getElementById("selectall");

        if (selectall) { selectall.innerHTML = "Select All"; }
        if (word_count) {word_count.innerHTML = 0; }
        if (sku_scc) { sku_scc.innerHTML = '-'; }
        if (sku_mkt) { sku_mkt.innerHTML = '0'; sku_mkt.setAttribute("title", "0 market(s)"); }

        if (sku == null || skutype == null || sku_note == null || cat == null || scc == null || mkt == null || csv == null)
            return;

        if (sku.length != "")
            sku.value = "";

        /*if (!skutype[0].checked) {
            $(function () {
                $("input[name='sku_type']:radio:first").prop("checked", true).trigger('change');
            });
            skutype[1].previousSibling.style.color = "#404040";
        }*/

        if (skutype) {
            for (var i = 0; i < skutype.length; i++) {
                skutype[i].disabled = true;
                skutype[i].checked = false;
                skutype[i].previousSibling.className = "radio disabled";
                skutype[i].previousSibling.style.backgroundPosition = "0 0";
                skutype[i].previousSibling.style.color = "#404040";
                skutype[i].previousSibling.onmousedown = "";
                skutype[i].previousSibling.onmouseup = "";
            }
        }

        if (sku.value.length < 3) {
            sku_note.style.visibility = "hidden";
        }

        if (cat.selectedIndex > 0 || !cat.disabled) {
            cat.selectedIndex = 0;
            cat.disabled = true;
        }

        if (scc.selectedIndex > 0 || !scc.disabled) {
            scc.selectedIndex = 0;
            scc.disabled = true;
        }

        if (mkt.selectedIndex > -1 && mkt.options.length > 1) {
            mkt.selectedIndex = -1;
        }

		if(csv.value.length >= 0){
			csv.value = "";
			csv.disabled = true;
			$("label[for='file_upload']").prop("class","custom-file-upload tooltip");
		}
		
        $('[autofocus]').focus();
    }
}

$(document).ready(function() {
  if (!$("#markets option:selected").length)
  {
	$('#file_upload').prop("disabled",true);
	$("label[for='file_upload']").prop("class","custom-file-upload tooltip");
	$('#selectall').text('Select All');
  }
  else
  {
	$('#file_upload').prop("disabled",false);
	$("label[for='file_upload']").prop("class","custom-file-upload-enabled tooltip");
	$('#selectall').text('Deselect All');
  }	
});
//End of Resetting all controls

//Start of Select All
$('#selectall').click(function () {
    var desel = 'Deselect All'; var sel = "Select All"; var lbl = desel;
    if ($.trim($(this).text()) == sel) {
        $('#markets option').prop('selected', true);
		$('#file_upload').prop("disabled",false);
		$("label[for='file_upload']").prop("class","custom-file-upload-enabled tooltip");
    } else {
        $('#markets option').prop('selected', false);
        lbl = sel;
		$('#file_upload').prop("disabled",true);
		$("label[for='file_upload']").prop("class","custom-file-upload tooltip");
    }
    $(this).text(lbl);
	$('#file_upload').val('');//Clearing file upload
});
//End of Select All

//Start of Markets Drop Down List
$("#markets").change(function () {
	$('#file_upload').val('');//Clearing file upload
   var option_all = $("#markets option:selected").map(function (){
       return $(this).val();
   }).get().join(',');
   if(option_all === ""){
		$('#file_upload').prop("disabled",true);
		$("label[for='file_upload']").prop("class","custom-file-upload tooltip");
		$('#selectall').text('Select All');
	}else{
		$('#file_upload').prop("disabled",false);
		$("label[for='file_upload']").prop("class","custom-file-upload-enabled tooltip");
		$('#selectall').text('Deselect All');
	}		
});
//End of Markets Drop Dwon List

//Start of Validation Input Box
function isNumber(evt) {
    evt = (evt) ? evt : window.event;
    var charCode = (evt.which) ? evt.which : evt.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
        return false;
    }
    return true;
}

function isNumberorDecimalNumber(evt) {
    var charCode = (evt.which) ? evt.which : evt.keyCode;
    if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57))
        return false;
    return true;
}
//End of Validation Input Box

//Start of Expand and Collapse
$('.expander').simpleexpand();
//End of Expand and Collapse

//Start of Tooltipster
$('.tooltip').tooltipster();
//End of Tooltipster

//Start of file upload
var allKeyPresent; // Flag

function validateCSVData(results){

	var selected_markets = $("#selected_markets").text().split(',');
	var temp = [];
	var data = results.data;	
	var container_col_no = 0; //Find the Container column order 
	var id_col_no = 0; //Find the Id column order 
	var key_col_no = 0; // Find the Key column order
	var csv_profiles = [];
	var uuid = [];
	var match_profiles = []; 
	var missed_profiles = []; 
	var counter=0;

	//Clearing empty value
	for(r=0; r < selected_markets.length; r++)
	{
		if(selected_markets[r].trim()!='')	
			temp[counter] = selected_markets[r];
			counter++;
	}
	selected_markets = temp;

	if(selected_markets.length > 0)
	{
		for(r=0; r < data.length; r++){
			var row = data[r];
			var cells = row;

			for(c=0; c < cells.length; c++){
				if(r == 0 && cells[c].toLowerCase() == 'container')//header row
					container_col_no = c;

				if(r > 0 && c == container_col_no)
				{
					csv_profiles[r - 1] = cells[c];
				}

				if(r == 0 && cells[c].toLowerCase() == 'id')//header row
					id_col_no = c;

				if(r > 0 && c == id_col_no)
				{
					uuid[r - 1] = cells[c];
				}
			}
		}
		
		counter=0;
		for(r=0; r < uuid.length; r++)
		{
			if(!validator.isUUID(uuid[r], 4))
			{
				$("#file_upload").val("");
				alert("The Id column on CSV file has found invalid UUID format or not version 4.\n\nPlease contact your tool's developer to explain further.");
				return;
			}
		}

		counter=0;
		for(r=0; r < csv_profiles.length; r++)
		{
			for(m=0; m < selected_markets.length; m++)
			{
				if(csv_profiles[r] == selected_markets[m])
				{
					match_profiles[counter] = selected_markets[m];
					counter++;
					break;
				}
			}
		}

		var uniqueMatch_Profiles = [];
		$.each(match_profiles, function(i, el){
			if($.inArray(el, uniqueMatch_Profiles) === -1) uniqueMatch_Profiles.push(el);
		});

		match_profiles = uniqueMatch_Profiles;//Unifying the match profile list
		
		if(selected_markets.length > match_profiles.length)
		{
			$("#file_upload").val("");
			
			missed_profiles = selected_markets;
			for(r=0; r < match_profiles.length; r++)
			{
				for(m=0; m < selected_markets.length; m++)
				{
					if(match_profiles[r]==selected_markets[m])
					{
						missed_profiles[m]=null;// empty the matched profile
						break;
					}																		
				}
			}
			var missing_list="";counter=1;
			for(r=0;r < missed_profiles.length;r++)
			{
				if(missed_profiles[r]!=null)
				{
					missing_list = missing_list + ("\n"+ counter + "] " + missed_profiles[r]);
					counter++;
				}					
			}
			alert("The CSV file has found missing market(s), please either recheck your uploaded CSV file or the selected market(s) on tool.\n" + missing_list + "\n\n");
		}
		else
		{
			/* Start of preparing CSV data XML */
			var markup = '<csvdata>'; contentypename_col_no = 0; id_col_no = 0; key_col_no = 0; container_col_no = 0; manufacturerpn_col_no = 0;
			for(r=0; r < data.length; r++){
				var row = data[r];
				var cells = row;
				for(c=0; c < cells.length; c++){
					if(r == 0 && cells[c].toLowerCase() == 'contentypename')//header contentypename row
						contentypename_col_no = c;
					if(r == 0 && cells[c].toLowerCase() == 'id')//header id row
						id_col_no = c;
					if(r == 0 && cells[c].toLowerCase() == 'key')//header key row
						key_col_no = c;
					if(r == 0 && cells[c].toLowerCase() == 'container')//header container row
						container_col_no = c;
					if(r == 0 && cells[c].toLowerCase() == 'manufacturerpn')//header manufacturerpn row
						manufacturerpn_col_no = c;

					if(r > 0 && (c == contentypename_col_no || c == id_col_no || c == key_col_no || c == container_col_no || c == manufacturerpn_col_no))
					{
						markup+= '<row contenttypename="' + cells[contentypename_col_no] + '" id="' + cells[id_col_no] + '" key="' + cells[key_col_no] + '" container="' + cells[container_col_no] + '" manufacturerpn="' + cells[manufacturerpn_col_no] + '"/>';
						break;
					}
				}
			}
			markup+= '</csvdata>';			
			g_XmlData = markup;
			//console.log(g_XmlData);
			/* End of preparing CSV data XML */

			$('<div id="notification"><div class="title">Notification</div><div class="body"><img src="images/csv.png" width="64" height="64" align="middle" hspace="15" vspace="5" title="CSV format"/>You have just imported <b>' + g_CSVFileName + '</b> template file and made ready to be populated with its generic content.</div></div>')
				.insertBefore('#footer_container')
				.delay(10000)
				.fadeOut(function() {
				  $(this).remove(); 
			});
		}
	}
	else
	{
		$("#file_upload").val("");
		alert("Invalid market(s) were selected for Content Studio.");
	}
}

function validateCSVFile(row, parser)
{
	var fileName = $("#file_upload").val().split("\\");	
	var columnName="";
	var isCSV = (/[^.]+$/.exec(fileName).toString().toLowerCase() === "csv")? true : false;

	if(!allKeyPresent && isCSV)
	{	
		parser.pause(); // pause the parser
		var first_row_data = row.data[0];
	
		if (!('ContentTypeName' in first_row_data))
			columnName = "\n- ContentTypeName";
		if (!('Id' in first_row_data))
			columnName += "\n- Id";
		if (!('Key' in first_row_data))
			columnName += "\n- Key";
		if (!('Container' in first_row_data))
			columnName += "\n- Container";
		/*if (!('Update' in first_row_data))
			columnName += "\n- Update";
		if (!('PublishStatus' in first_row_data))
			columnName += "\n- PublishStatus";*/
		if (!('ManufacturerPn' in first_row_data))
			columnName += "\n- ManufacturerPn";
		/*if (!('ShortDescOverride' in first_row_data))
			columnName += "\n- ShortDescOverride";*/
		/*if (!('ShortDescOverrideFlag' in first_row_data))
			columnName += "\n- ShortDescOverrideFlag";*/
		/*if (!('LongDescOverride' in first_row_data))
			columnName += "\n- LongDescOverride";*/
		/*if (!('LongDescOverrideFlag' in first_row_data))
			columnName += "\n- LongDescOverrideFlag";*/
		/*if (!('KSPContentOverride' in first_row_data))
			columnName += "\n- KSPContentOverride";*/
		/*if (!('KSPContentOverrideFlag' in first_row_data))
			columnName += "\n- KSPContentOverrideFlag";*/

		if (columnName==="") { // Now check object keys, if it match

			allKeyPresent = true;
			g_CSVFileName = fileName[fileName.length-1];
			// Do your data processing here
			
			magicXML.transformAndReplace("#selected_markets", "content/data/definitions/locales.xml", "xslt/selected_markets.xslt", [{ name: 'region', value: cookie }, { name: 'markets', value: getSelectValues(document.forms["control-panel"].markets).toString() }]); 

			$('#file_upload').parse({config: {complete: validateCSVData, skipEmptyLines : true}, complete: function(){}});
						
			parser.resume();		
		} else{
		
			allKeyPresent = false;
			//some key is missing and clearing upload file, abort parsing
			$("#file_upload").val("");		
			alert("Invalid Content Studio CSV format. The mandatory column(s) is/are missing:\n" + columnName + "\n\nPlease reselect.\n\n");		
			parser.abort();
		}
	}else if(!isCSV){
		$("#file_upload").val("");	
		alert("Invalid file type selected. Only CSV file type allowed.");
		parser.abort();
	}
}

function fileUpload()
{	
	allKeyPresent = false;

	$('#file_upload').parse({		
		config: {header : true, skipEmptyLines : false, step: validateCSVFile},
		step: function(row, parser){}
	});

}
//End of file upload
