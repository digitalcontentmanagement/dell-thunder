var div = document.createElement("div");
div.innerHTML = "<!--[if lt IE 9]><i></i><![endif]-->";
var isIeLessThan9 = (div.getElementsByTagName("i").length == 1);

//Generating Column Name for MS Excel
function colName(n) {
    var ordA = 'a'.charCodeAt(0);
    var ordZ = 'z'.charCodeAt(0);
    var len = ordZ - ordA + 1;

    var s = "";
    while (n >= 0) {
        s = String.fromCharCode(n % len + ordA) + s;
        n = Math.floor(n / len) - 1;
    }
    return s.toUpperCase();
}


//Start of Exporting CSV
function exportTableToCSV(templateType, templateFileName, templateSheetName) {//templateSheetName is not used
	 templateFileName = document.getElementById('sku').value.toString().concat("-",templateFileName);
     var htmlTableID = document.getElementById(templateType.toString().concat("-template"));
     var htmlTbody;

     if (htmlTableID)
		  htmlTbody = htmlTableID.getElementsByTagName("tbody")[0].getElementsByTagName("tr");

     //Ensure template table is built
     if (htmlTableID && htmlTbody.length > 0) {
	 
		 //alert("Creating a copy of Content Studio CSV template.\n\nPlease wait for a moment until its notification prompts.\n\n");
		 
		 var $rows = $(htmlTableID).find('tr:has(td),tr:has(th)'),
    
		 // Temporary delimiter characters unlikely to be typed by keyboard
		 // This is to avoid accidentally splitting the actual contents
		 tmpColDelim = String.fromCharCode(11), // vertical tab character
		 tmpRowDelim = String.fromCharCode(0), // null character
    
		 // actual delimiter characters for CSV format
		 colDelim = '","',
		 rowDelim = '"\r\n"',
    
		 // Grab text from table into CSV formatted string
		 csv = '"' + $rows.map(function (i, row) {
			 var $row = $(row), $cols = $row.find('td,th');
    
				 return $cols.map(function (j, col) {
				 var $col = $(col), text = $col.text().replace(/\s+/g, " ").replace(/^\s+|\s+$/g, "").trim();
    
				 return text.replace(/"/g, '""').replace(/\s+/g, " ").replace(/^\s+|\s+$/g, "").trim(); // escape double quotes
    
		 }).get().join(tmpColDelim);
    
		 }).get().join(tmpRowDelim)
		 .split(tmpRowDelim).join(rowDelim)
		 .split(tmpColDelim).join(colDelim) + '"',
		 // Data URI
		 csvData = 'data:application/csv;charset=utf-8,\uFEFF' + encodeURIComponent(csv);
         
		 //console.log(csv);
         var answer = confirm("Content Studio CSV template file is successfully created. Do you want to download?\n\nNote: Please do not manually edit the exported CSV file.");
		 if(answer)
		 {
			 if (window.navigator.msSaveBlob) { // IE 10+
	 			window.navigator.msSaveOrOpenBlob(new Blob(['\uFEFF' + decodeURIComponent(csv)], {type: "text/plain;charset=utf-8;"}), templateFileName + ".csv");
			 }
			 else {
     			$(".csd_export").attr({ 'download': templateFileName + ".csv", 'href': csvData, 'target': '_blank' }); 
   			 }
		 }
		 else
			return false;
	 }
    else {
	     //alert("Unable to export generic content to either one or all of the templates.");
         return;
    }
}
//End of Exporting CSV

if (isIeLessThan9)      // If Internet Explorer below version 9 
{
    function exportTemplate(templateType, templateFileName, templateSheetName) {
		templateFileName = document.getElementById('sku').value.toString().concat("-",templateFileName);

        if (typeof (window.ActiveXObject) == "undefined" || !("ActiveXObject" in window)) {
            alert("ActiveX Object not supported on your browser. Please contact your tool developer.\n\n Or use Internet Explorer 9 or above or other compatible browser.\n\n");
        } else {

            var htmlTableID = document.getElementById(templateType.toString().concat("-template"));
            var htmlTbody;

            if (htmlTableID)
                htmlTbody = htmlTableID.getElementsByTagName("tbody")[0].getElementsByTagName("tr");

            //Ensure template table is built
            if (htmlTableID && htmlTbody.length > 0) {
                var cookies = readCookie("template_export");
                var thunderFolder = (cookies == 'local') ? "c:\\Thunder\\Generic-Content\\" : "\\\\intranet.dell.com\\DavWWWRoot\\marketing\\contentoperations\\DCSContentOps\\Operations\\snp-and-euc-operations-teams\\DellThunder\\downloads\\Thunder\\Generic-Content\\";
                var templateFolder = thunderFolder.concat("Templates\\");
                templateFileName = templateFileName.concat((templateType == "prc") ? ".xlsx" : ((cookies == 'local')? ".xls" : ".xlsx") );
                var templateFilePath = templateFolder.concat(templateFileName);

                var excel, workBook, workSheet;

                try {
                    excel = new ActiveXObject("Excel.Application");
                }
                catch (error) {
                    switch (error.name) {
                        case "Error":
                            alert(error + ("\n\nPlease ensure the following setting is enabled.\n\nTools > Internet Options >  Security > Local intranet > Custome Level > Initialize and script ActiveX controls not marked as safe for scripting.\n\nRestart your browser to take effect.\n\n")); break;
                        default:
                            alert("Unable to initiate template.");
                    }
                    return;
                }

                excel.Visible = false;
                excel.DisplayAlerts = false;

                try {
                    workBook = excel.WorkBooks.open(templateFilePath);
                }
                catch (error) {
                    switch (error.name) {
                        case "SyntaxError":
                            alert(error + ("\n\nPlease download it from the tool's downloads\/templates folder and save it to the following folder: ".concat(templateFolder, ".\n\n"))); break;
                        default:
                            alert("Unable to initiate template.");
                    }
                    return;
                }

                //alert("Creating a copy of ".concat((templateType == "prc") ? "PRC" : "Harmony", " template.\n\nPlease wait for a moment until its notification prompts.\n\n"));

                workSheet = workBook.Worksheets(templateSheetName);

                var htmlTableData = "";
                var htmlTableRows = htmlTableID.rows.length;
                var htmlTbodyRows = htmlTbody.length;
                var htmlTbodyCols = htmlTbody[0].getElementsByTagName("td").length;
                var htmlTheadRows = htmlTableRows - htmlTbodyRows;
                var htmlTbodyThisRow = 0;

                for (var r = 0; r < htmlTbodyRows; r++) {
                    htmlTbodyThisRow = ++htmlTheadRows;
                    for (var c = 0; c < htmlTbodyCols; c++) {
                        htmlTableData = htmlTbody[r].getElementsByTagName("td")[c].textContent || htmlTbody[r].getElementsByTagName("td")[c].innerText;
                        //Preserve whitespace https: //msdn.microsoft.com/en-us/library/aa468566.aspx
                        if (htmlTableData)//in case null value
                            htmlTableData = htmlTableData.replace(/\s+/g, " ").replace(/^\s+|\s+$/g, ""); //.replace(/^\s|\s$/g, "");
                        workSheet.Cells(htmlTbodyThisRow, c + 1).value = htmlTableData.toString();
                        //horizontal alignment of the enumeration * (1 - General, 2 - left - center - right, 5 - Fill - Justify , 7 - Center Across 8 - Distributed)
                        workSheet.Cells(htmlTbodyThisRow, c + 1).HorizontalAlignment = 2;
                        //vertical alignment enumeration * (1 - upper - middle, 3 - by 4 - Justify 5 - scattered aligned)
                        workSheet.Cells(htmlTbodyThisRow, c + 1).VerticalAlignment = 1;
                        workSheet.Cells(htmlTbodyThisRow, c + 1).WrapText = false;
                    }
                }
                var WinNetwork = new ActiveXObject("WScript.Network"); //Retrieve Windows Object for User Name
                var UserName = WinNetwork.UserName.toLowerCase();
                try {
                    // initialize ActiveXObject and create an object of Scripting.FileSystemObject.  
                    var fso = new ActiveXObject("Scripting.FileSystemObject");

                    try {
                        fso.CreateFolder(thunderFolder.concat("Saved-Copy\\", UserName));
                    } catch (error) {
                        //Catch when user name folder has created.
                    }
                    workBook.SaveAs(thunderFolder.concat("Saved-Copy\\", UserName, "\\", templateFileName));
                    workBook.Close(true, templateFilePath);
                    excel.Application.Quit();
                    excel = null;
                } catch (error) {
                    alert("Unable to save to template file(s). Please ensure all files are closed.");
                    return;
                }
                if (cookies == 'local')
                    alert("Successfully populated at the location of ".concat(thunderFolder.concat("Saved-Copy\\", UserName, "\\"), ".\n\n"));
                else {
                    try {
                        var downloadPath = "Downloads/Thunder/Generic-Content/Saved-Copy/" + UserName + "/" + templateFileName;
                        if (UrlExists(downloadPath)) {
                            if (templateType=='hmy')
                                alert("Note: You may need to resave harmony template from .XLSX to .XLS file extension.\n\n");
                            window.location = downloadPath;
                        }
                        else
                            alert("Unable to download your template. Please ensure you are running your tool from HTTP web server.");
                    }
                    catch (error) {
                        alert("Unable to download your template. Please check your connection.");
                    }
                }
            }
            else {
                //alert("Unable to export generic content to either one or all of the templates.");
                return;
            }
        }
    }
}
else //other browser not tested on IE 11
{
    //Start of OpenXML for Excel
    var spreadsheetToSave = null;

    (function (root) {  // root = global
        "use strict";

        var XAttribute = Ltxml.XAttribute;
        var XCData = Ltxml.XCData;
        var XComment = Ltxml.XComment;
        var XContainer = Ltxml.XContainer;
        var XDeclaration = Ltxml.XDeclaration;
        var XDocument = Ltxml.XDocument;
        var XElement = Ltxml.XElement;
        var XName = Ltxml.XName;
        var XNamespace = Ltxml.XNamespace;
        var XNode = Ltxml.XNode;
        var XObject = Ltxml.XObject;
        var XProcessingInstruction = Ltxml.XProcessingInstruction;
        var XText = Ltxml.XText;
        var XEntity = Ltxml.XEntity;
        var cast = Ltxml.cast;
        var castInt = Ltxml.castInt;

        var S = openXml.S;
        var R = openXml.R;

        var templateSpreadsheet;

        //PRC - dell_PRC_upload_v2.0.xlsx
        var templatePRC = "UEsDBBQABgAIAAAAIQBVZ9a6lQEAAGEGAAATAAgCW0NvbnRlbnRfVHlwZXNdLnhtbCCiBAIooAAC" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACs" +
"lctOwzAQRfdI/EPkLWrcskAINWXBYwlIlA8w9rSxGj/kmb7+nolLK4TaRlW7SZTYc8+dGWcyfFy5" +
"plhAQht8JQZlXxTgdTDWTyvxNX7t3YsCSXmjmuChEmtA8Ti6vhqO1xGw4GiPlaiJ4oOUqGtwCssQ" +
"wfPKJCSniB/TVEalZ2oK8rbfv5M6eAJPPWo1xGj4DBM1b6h4WfHrjZNv60XxtNnXoiqhYmysVsRG" +
"5cKbf5BemEysBhP03LF0iTGBMlgDkGvKmCwT0ycQcWIo5F5mggZPg/5mVXJkNoa1jXjDqR8gtCuH" +
"szoctzga110Njn9Oasm5t8beud/JGig+VKI35bi4ctXIZUiz7xBm5XGXp9Y+96B0yvptYY7w82aU" +
"+Ta4sJE2vyzc4YP4EIPM1/MtZJkOINK6Abx02bNoF7lWCcwn8ecxvbiBv9odPnRw7VeLl275VvcY" +
"nkfGRwoReSolOL0J2xHQRvciC0EiC7shsO+s74g80s7uOrQz04A5la3nSMGdjd/I7IHL/IMY/QAA" +
"AP//AwBQSwMEFAAGAAgAAAAhABNevmUCAQAA3wIAAAsACAJfcmVscy8ucmVscyCiBAIooAACAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACskk1L" +
"AzEQhu+C/yHMvTvbKiLSbC9F6E1k/QExmf1gN5mQpLr990ZBdKG2Hnqcr3eeeZn1ZrKjeKMQe3YS" +
"lkUJgpxm07tWwkv9uLgHEZNyRo3sSMKBImyq66v1M40q5aHY9T6KrOKihC4l/4AYdUdWxYI9uVxp" +
"OFiVchha9EoPqiVcleUdht8aUM00xc5ICDtzA6I++Lz5vDY3Ta9py3pvyaUjK5CmRM6QWfiQ2ULq" +
"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" +
"AAAAAA8ADwDuAwAAKTIAAAAA";

        //Harmony - ProductDetails.xlsx (Needs to convert back to its original extension .xls manually)
        var templateHmy = "UEsDBBQABgAIAAAAIQDz+U7LmQEAAOkGAAATAAgCW0NvbnRlbnRfVHlwZXNdLnhtbCCiBAIooAAC" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADE" +
"VclOwzAQvSPxD5GvqHHLASHUtAcKR0ACPsDY08ZqvMgzLe3fM3EpQqiLolbikiix5y0z8ctwvHJN" +
"sYSENvhKDMq+KMDrYKyfVeL97bF3Kwok5Y1qgodKrAHFeHR5MXxbR8CCqz1WoiaKd1KirsEpLEME" +
"zyvTkJwifkwzGZWeqxnI637/RurgCTz1qMUQo+EEpmrRUPGw4tcbJR/Wi+J+s6+lqoSKsbFaEQuV" +
"S2/+kPTCdGo1mKAXjqFLjAmUwRqAXFPGZJkxvQIRG0Mhd3ImaLAb6berkiuzMKxtxCu2voehXdnv" +
"an/d8mDd8W5w/SSpT/beCnvmeSdroHhRiZ6U4+bKVSM/Q5p/hDAvD6vs2vs8g9Ip67eNOcCfN6PM" +
"t8GZhbT+MnBHHdf/pIP4MIHM19NbkWGOGEdaN4DnHn8GPcZcqwTmlfiYzs4u4Df2ER06uDY98Nyf" +
"3hb3ED1H10sKETkdE3QfwjaK2upeZCBIZOEnjHaduR9GjtaTpw5tdhswXbn1Aim4k+k3MDvIZf5R" +
"jb4AAAD//wMAUEsDBBQABgAIAAAAIQATXr5lAgEAAN8CAAALAAgCX3JlbHMvLnJlbHMgogQCKKAA" +
"AgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"rJJNSwMxEIbvgv8hzL072yoi0mwvRehNZP0BMZn9YDeZkKS6/fdGQXShth56nK93nnmZ9Wayo3ij" +
"EHt2EpZFCYKcZtO7VsJL/bi4BxGTckaN7EjCgSJsquur9TONKuWh2PU+iqziooQuJf+AGHVHVsWC" +
"PblcaThYlXIYWvRKD6olXJXlHYbfGlDNNMXOSAg7cwOiPvi8+bw2N02vact6b8mlIyuQpkTOkFn4" +
"kNlC6vM1olahpSTBsH7K6YjK+yJjAx4nWv2f6O9r0VJSRiWFmgOd5vnsOAW0vKRFcxN/3JlGfOcw" +
"vDIPp1huL8mi9zGxPWPOV883Es7esvoAAAD//wMAUEsDBBQABgAIAAAAIQBKqaZh+gAAAEcDAAAa" +
"AAgBeGwvX3JlbHMvd29ya2Jvb2sueG1sLnJlbHMgogQBKKAAAQAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAC8ks1qxDAMhO+FvoPRvXGS/lDKOnsphb222wcwsRKHTWxjqT95+5qU7jawpJfQoyQ0" +
"8zHMZvs59OIdI3XeKSiyHAS62pvOtQpe909X9yCItTO69w4VjEiwrS4vNs/Ya05PZLtAIqk4UmCZ" +
"w4OUVFscNGU+oEuXxsdBcxpjK4OuD7pFWeb5nYy/NaCaaYqdURB35hrEfgzJ+W9t3zRdjY++fhvQ" +
"8RkLyYkLk6COLbKCafxeFlkCBXmeoVyT4cPHA1lEPnEcVySnS7kEU/wzzGIyt2vCkNURzQvHVD46" +
"pTNbLyVzsyoMj33q+rErNM0/9nJW/+oLAAD//wMAUEsDBBQABgAIAAAAIQDwtwCrPQIAAIIEAAAP" +
"AAAAeGwvd29ya2Jvb2sueG1spFRdb9owFH2ftP/gWX0tIRnQNSKpGDANCa1o69oXJGScC7HwR2Y7" +
"Dfz73STQ0fHSaS+xr3197vE51xne7ZUkz2CdMDqhYadLCWhuMqG3Cf358OX6EyXOM50xaTQk9ACO" +
"3qXv3w0rY3drY3YEAbRLaO59EQeB4zko5jqmAI07G2MV8xjabeAKCyxzOYBXMoi63UGgmNC0RYjt" +
"WzDMZiM4TAwvFWjfgliQzCN9l4vCndAUfwucYnZXFtfcqAIh1kIKf2hAKVE8nm21sWwt8dr7sH9C" +
"xukFtBLcGmc2voNQQUvy4r5hNwjD9srpcCMkPLayE1YU35iqq0hKJHN+mgkPWUIHGJoKXi3Ysvhc" +
"Com7Ya8XdWmQvlixsCSDDSulf0ATTvCYGPWiaFBn4qVG0oPVzMPYaI8aHtX/X70a7HFu0B3yHX6V" +
"wgI2RS1bOsQv4zFbuwXzOSmtTOg4XgoNvijXy6qqrDF+uQUNVvAVb3mtomVmKi0NtszSgyrQZHDL" +
"MxfYpcX/4APjtSABKtKybud/q5MO6x5/FFC5PzrXIdk/CY0EE3r7Ed/M4RQNMKianSeR+RzFv43q" +
"hHbtK4ht7hN6M+j2m/Jn6M3DwCrNSHTTEAtrspL7CXgmJPZ2szervafExgIndpaFNdL5qTlSLuun" +
"8JIenaVHTeFTNWwYNCKr+w9rn0VHBvP78Wg+XY3vJ9MfND0if7gaXUUxfm5uhsHZGdTwNR5nkmNX" +
"1kPDutcfRA3d4PT7SH8DAAD//wMAUEsDBBQABgAIAAAAIQBLzfVYUQMAAKkLAAANAAAAeGwvc3R5" +
"bGVzLnhtbMxW227aQBB9r9R/sPbd8QWbALIdhRBLkdKoUqjU18Vewyp7sewlhVb99876gk1oEkqp" +
"1BfsGXbPnJk5s97gasOZ8UyKkkoRIufCRgYRiUypWIboyzw2R8goFRYpZlKQEG1Jia6ijx+CUm0Z" +
"eVwRogyAEGWIVkrlE8sqkxXhuLyQORHwTyYLjhWYxdIq84LgtNSbOLNc2x5aHFOBaoQJT44B4bh4" +
"WudmInmOFV1QRtW2wkIGTyZ3SyELvGBAdeN4OGmxK+MAntOkkKXM1AXAWTLLaEIOWY6tsQVIUZBJ" +
"oUojkWuhQuQDtI4weRLym4j1X1DAZlUUlN+NZ8zAYyMrCgTmpLavC4qZdlkarcaMggU43t2RYU7Z" +
"toZxDyDOtH2kgRPJZGFQkZINSUM0cvZzmOOV5Fj73qbUz+o8uFXRSohLGdt1YqCLDo4oAEUoUogY" +
"DKN5n29z0IIA8dYVq9a9s3pZ4K3j+sdvKCWjqWaxvNmvnFv1afHSPfQq7B5drYeKWvWADBeySGEs" +
"O7W1rihgJFNQ+4IuV/qpZA6/C6kUaDgKUoqXUmCmJVaD7O+EcYbJDZFaweQdtLphpkM0EY5aX3H5" +
"51T+u2SPqg30p23PUevrTr7fyFYCZ25QIxqQYEIYe9Ri+ZrtdKgPuE1miDWPubqDswE+GPoga19B" +
"w81rrb3a0Frso9XYPdjLk2CNTbbDf42UA/waUi4yOlLgb3cbOM/ZVp/g+gBvLNjTWdNqGLUNmfxp" +
"JAh75kiA2OYE5e8X+pVIJ7AenIe1N+708VorvJehHtZ8QYq4ujn0WnJSg/oEjq7b2wRaNYN+e0Oy" +
"NyI7sRv6yx+iB50L6+W5WFOmqPjNeABmuukGrro+KH2jqUZxFwUan5IMr5ma7/4MUff+iaR0zaH6" +
"zarP9FmqCiJE3fu9/oY4Qy1rslH3JRz68DTWBQ3Rj9vp5Xh2G7vmyJ6OTG9AfHPsT2em791MZ7N4" +
"bLv2zc/eBesvrlfVNRBGy/EmJYNLWNEk25B/7Hwh6hk1/epbCrT73Mfu0L72HduMB7ZjekM8MkfD" +
"gW/GvuPOht701o/9Hnf/NO6ObTlOfYfV5P2JopwwKtpetR3qe6FJYL6RhNV2wuru2NEvAAAA//8D" +
"AFBLAwQUAAYACAAAACEAE8QsE8IAAABCAQAAIwAAAHhsL3dvcmtzaGVldHMvX3JlbHMvc2hlZXQy" +
"LnhtbC5yZWxzhI/BasMwEETvhfyD2HskO4dQiiVfSiHXJv0ARV7bovZKaLcl+fvo2IRCjsNj3jBd" +
"f1kX9YuFYyILrW5AIYU0RJosfJ0+tq+gWDwNfkmEFq7I0LvNS/eJi5da4jlmVtVCbGEWyW/GcJhx" +
"9axTRqpkTGX1UmOZTPbh209odk2zN+WvA9ydUx0GC+UwtKBO11yXn7vTOMaA7yn8rEjyz4TJJZJg" +
"OaJIPchV7cuEYkHrR/aYd/ocCYzrzN1zdwMAAP//AwBQSwMEFAAGAAgAAAAhANU4Oz3wAAAAXQIA" +
"ACMAAAB4bC93b3Jrc2hlZXRzL19yZWxzL3NoZWV0MS54bWwucmVsc6ySwUoDMRCG74LvEOZusqkg" +
"Is32UoRetT5AzM7uhm4mIYnVvr1TBHVLxUtvmfnJNx/DLFcfYRJ7zMVHMqBlAwLJxc7TYOBl+3hz" +
"D6JUS52dIqGBAxZYtddXyyecbOVPZfSpCKZQMTDWmh6UKm7EYIuMCYmTPuZgK5d5UMm6nR1QLZrm" +
"TuXfDGhnTLHpDORNdwtie0g8+X927HvvcB3dW0CqZ0YoF8MxKsy0ecBqQMrvppbsCuq8xuKSGvsw" +
"rbN95x3PRLqvXlE/uZb8/stJX9IpZU8V8zPWyl7zDZ1k6qTW8tXTUVLNjqL9BAAA//8DAFBLAwQU" +
"AAYACAAAACEASZfoziYHAACrJgAAGAAAAHhsL3dvcmtzaGVldHMvc2hlZXQyLnhtbJSa32/bOAzH" +
"3w+4/8Hw+xrLP9MgydCuK67Ahh1ud9vjwXWcxqhj5Wxnbf/7I500EukICF/apl+alCjpI1rR/OPr" +
"tvZ+lW1X6Wbhq6vA98qm0KuqeVr4//x9/2Hqe12fN6u81k258N/Kzv+4/P23+Ytun7tNWfYeeGi6" +
"hb/p+91sMumKTbnNuyu9KxtQ1rrd5j18bJ8m3a4t89Xw0LaehEGQTrZ51fgHD7P2Eh96va6K8k4X" +
"+23Z9AcnbVnnPbS/21S77t3btrjE3TZvn/e7D4Xe7sDFY1VX/dvg1Pe2xezhqdFt/lhDv19VnBfv" +
"vocPI/fbqmh1p9f9FbibHBo67vP15HoCnpbzVQU9wLR7bble+Ddqdptl/mQ5HxL0oypfOutvD/P9" +
"qPUzCg+rhR+g6WRkez/k+8/WW5XrfF/3f+mXP8rqadPD4IZXWQJdwJ7MVm93ZVdACsHTVYi+Cl1D" +
"QPjpbSucCpCB/HX4/VKt+s3wfBwm2VSF4KXYd73e/jwqx+cPT4bHJ+H38ckwvDJPPpZdf19he855" +
"mRyaMfTrLu/z5bzVLx5MDbDudjlONDUDz2d7Ac1H0xu0Xfix70GUDlL9a5lE88kvyFdxNLk9YxKf" +
"TCYQ8xQYgl0cGGxPIa8zFtIWlZqejxYJooHtKZpKWTRbjNT5YJChi7tmZzPk2bTFKDwfDCbNxcHA" +
"9tSzkPfMFiPTEjJoqSAY2JpgpvHDVLq1xcgxQzJBMLA9BZsmbMxsUQWOaAjkSxcC2JoZEvEJSVXH" +
"hLwWhANbEy4MWO/Q08InkzY0TSLDp2Abuny1g7HVy2u+0tEXixubttG4IsqAsYlr0neYOMpWIzPS" +
"NJ4ELooAJDZr+hiQyo5VqCSAQeNTD0cEtcXEQRglQQwam5Vopv+xfwQyBgo0oRLKKJskKh51kMqO" +
"5agkqEFjM2Vivv6Z7OqjhDeKMCXmCGCygwFKwhw0NpvgKKkEOso1SyXUURQ7o3VxjjuOjoYS7qCx" +
"GUw+lkS10EtrCwlvQpso13xXJKpSDuCEomqGECXkW+PgiwPd0Jd2VIKdkOwRnANEjVwDKeFOaJNF" +
"jYoblPkGEjk2ECyNL68WCWBG5SKpc1x5ldAntOkzHeWVsClwFFahBD5obOGO78xUTlwplcAntPEy" +
"5RUIVR1bVihhDxpbDODsYbKDdpGEOmhsFVl8FAdfbFG6yv9IQh80tnrKuT74YnETx5YZSSCExlZ/" +
"OWYHX7y/jrkbiV6uCISSUVz0xfvr2LAjCYzQ2Mozp8Lgi8d1vUtKYBTZuJmOhpegKnBNZAmNIsob" +
"/vpqq65yPZLACI2txHIYUTl1wCiSwAiNTcSUw4HJrpxKcBTZOLoeBSSwUo4uxhIaobEp9vgiIapS" +
"DhzEEgyhsYUDNmuIar0hkVokluAHja0xHB18UNnVQwl4YvqGzOs8lEfViGPuxKIDHgKedDSWZ6qg" +
"1AG8WAIeNLYyzIE3+GLASx3AiyX8QWPztsknki0mrvRK8BMT/KQcP1TOXGtTgp+YvIjx6p2oSrlO" +
"CCX0iQl9ePFFVBU4CtpEQh80Pg3hlJ/AEFUFjqOmREIfNDYB+RgSVQWOSZpI8IPGhq9skhIxdh27" +
"StiT2OyZjg5eCZkCxytmIoEOGpvFbx2THc58Bl+8unNAJxEdMNNXL75TDr5Y3MyVYAl0EvIKxtck" +
"UVXgWJOJBDtobBI8mrG2ah2Akf0ykUAHjU/xRhPIFq2SmoaTICexkRPyPYuosWNzTiXEQeNT9/hW" +
"RUTrcI9+MyHhTUqqnYxXH1S2vgKiESXASW3gcKISMXasw1QCHDQ20zPjb7NMdhAnlRAHjQ1R+YIg" +
"qgoc23AqQQ0aW13ka4LJjl0qFX2hRSobvg+jq1N7rANhOmckjEltioScpUSNHZtiKmEMGpuMjuLZ" +
"auwoM1IJZNDYTJnRoqBvVY6AmYQyaGzKDI4ZoqrAsQwzCWfQ2PSQr0KiKuU4XckkmEFja1HwnDLZ" +
"lVMJaTJCmtHRIJWVYxlmEtKgsVXb8O96bdV19on3NS4+TkZjE2/K1wWTHdVMJgENGlsR+fbEZNe3" +
"56Kvz0k5M/4Cncp8aRyuyxyulew2cJ+prwq4KrPWTX+4UuP1bzu47NPoT7o5XorCqy0ruIjyI68r" +
"+I3XjLxC7/HijMJbPEQ6Pl9XXe97eV3rl9s6b54Pt1c2+uWh2e37r2XX5U8QBlco/PNz2+qW/PO/" +
"w42gcHYDN4KWc7xDta9ztfzy7dPNl8//fvp29/n7fHL693xCWwH3XFiLl/MdRPyat08VNL8u19D6" +
"YLgN1B7uBh0+9Ho3tOpR93C5Z/hzAze2SrhTE1zB7Fpr3b9/gLSgz+9lv995uq3gKtGQnYW/023f" +
"5hVkAFIIGc7ru12FF5a8dlatFn77sFKY1YPr+8EnJKt6an5W/ebYyPcLTqdrZsv/AQAA//8DAFBL" +
"AwQUAAYACAAAACEAg6/q440GAADjGwAAEwAAAHhsL3RoZW1lL3RoZW1lMS54bWzsWc1uGzcQvhfo" +
"OxB7TyzZkmMZkQNLluI2cWLYSoocqRW1y5i7XJCUHd2K5FigQNG06KVAbz0UbQMkQC/p07hN0aZA" +
"XqFDciWRFhXbiYH+xQZsiftxOJyfjzPcq9ceZAwdEiEpz5tR9XIlQiSP+YDmSTO60+teWouQVDgf" +
"YMZz0ozGREbXNt5/7ypeVynJCIL5uVzHzShVqlhfWpIxDGN5mRckh2dDLjKs4KtIlgYCH4HcjC0t" +
"VyqrSxmmeYRynIHY28MhjQnqaZHRxkR4h8HXXEk9EDOxr0UTb4bBDg6qGiHHss0EOsSsGcE6A37U" +
"Iw9UhBiWCh40o4r5iZY2ri7h9XISUwvmOvO65qecV04YHCybNUXSny5a7dYaV7am8g2AqXlcp9Np" +
"d6pTeQaA4xh2anVxZda6a9XWRKYDsh/nZbcr9UrNxzvyV+Z0brRarXqj1MUKNSD7sTaHX6us1jaX" +
"PbwBWXx9Dl9rbbbbqx7egCx+dQ7fvdJYrfl4A0oZzQ/m0Nqh3W4pfQoZcrYdhK8BfK1SwmcoiIZp" +
"dOklhjxXi2Itw/e56AJAAxlWNEdqXJAhjiGK2zjrC4ojVOCcSxioLFe6lRX4q39r5lNNL4/XCXbm" +
"2aFYzg1pTZCMBS1UM/oQpEYO5NXz7189f4pePX9y/PDZ8cOfjh89On74o5XlTdzGeeJOfPntZ39+" +
"/TH64+k3Lx9/EcZLF//rD5/88vPnYSDk12z/L7588tuzJy+++vT37x4H4JsC9114j2ZEolvkCO3x" +
"DPZmDONrTvrifDN6KabeDJyC7IDojko94K0xZiFci/jGuyuAWkLA66P7nq77qRgpGlj5Rpp5wB3O" +
"WYuLoAFu6LUcC/dGeRJeXIxc3B7Gh6G12zj3XNsZFcCpELLztm+nxFNzl+Fc4YTkRCH9jB8QEph2" +
"j1LPrjs0FlzyoUL3KGphGjRJj/a9QJpN2qYZ+GUcUhBc7dlm5y5qcRba9RY59JGQEJgFlO8R5pnx" +
"Oh4pnIVE9nDGXIPfxCoNKbk/FrGL60gFnk4I46gzIFKG5twWsF/H6TcwsFnQ7TtsnPlIoehBSOZN" +
"zLmL3OIH7RRnRVBnmqcu9gN5ACGK0S5XIfgO9zNEfwc/4Hyhu+9S4rn7dCK4QxNPpVmA6CcjEfDl" +
"dcL9fByzISaGZYDwPR7PaP46UmcUWP0Eqdffkbo9lU6S+iYcgKHU2j5B5Ytw/0IC38KjfJdAzsyT" +
"6Dv+fsff0X+evxfl8sWz9oyogcNndbqp2rOFRfuQMravxozclKZul3A8DbowaBoK01VOm7gihY9l" +
"i+DhEoHNHCS4+oiqdD/FBZT4VdOCJrIUnUhUcAmVvxk2zTA5Idu0txQKe9Op1nUPY5lDYrXDB3Z4" +
"xe1Vp2JM55qYfniy0IoWcNbFVq683WJVq9VCs/lbqxrVDCl6W5tuGXw4vzUYnFoT6h4E1RJYeRWu" +
"DLTu0A1hRgba7raPn7hFL32hLpIpHpDSR3rf8z6qGidNYmUSRgEf6b7zFB85qzW02LdY7SxOcper" +
"LVhu4r238dKk2Z55SeftiXRkuZucLEdHzahRX65HKMZFMxpCmw0fswK8LnWpiVkCd1WxEjbsT01m" +
"E64zbzbCYVmFmxNr97kNezxQCKm2sExtaJhHZQiw3FwKGP2X62DWi9qAjfQ30GJlDYLhb9MC7Oi7" +
"lgyHJFaus50RcytiACWV8pEiYj8dHKE+G4k9DO7XoQr7GVAJ9yGGEfQXuNrT1jaPfHIuk869UDM4" +
"O45ZkeKSbnWKTjLZwk0eT3Uw36y2Rj3YW1B3s7nzb8Wk/AVtxQ3j/9lW9HkCFxQrA+2BGG6WBUY6" +
"X5sRFyrlwEJFSuOugGs1wx0QLXA9DI8hqOB+2/wX5FD/tzlnZZi0hj5T7dEECQrnkUoFIbtASyb6" +
"ThFWLc8uK5KVgkxEOerKwqrdJ4eE9TQHruqzPUIphLphk5IGDO5k/PnfywzqJ7rI+adWPjaZz1se" +
"6OrAllh2/hlrkZpD+s5R0AiefaammtLBaw72cx61lrHmdrxcP/NRW8A1E9wuK4iJmIqY2Zcl+kDt" +
"8T3gVgTvPmx5hSCqL9nCA2mCtPTYh8LJDtpg0qJswVJWtxdeRsENeVnpTteFLH2TSvecxp4WZ/5y" +
"Xi6+vvo8n7FLC3u2divdgKkhaU+mqC6PJo2McYx5y+a+COP9++DoLXjlMGJK2pcJD+BSEboM+9IC" +
"kt8610zd+AsAAP//AwBQSwMEFAAGAAgAAAAhAHMMJmmcBAAALQ8AABgAAAB4bC93b3Jrc2hlZXRz" +
"L3NoZWV0MS54bWykl1tz4jYUx9870+/g8fv6is1lgB0CoZs2abab3aTtS0fYAjSxLa8kQvj2PfIF" +
"bFnDeGdfsIC/fjo3HUvTj+9pYrxhxgnNZqZrOaaBs4jGJNvNzG9f1x9GpsEFymKU0AzPzBPm5sf5" +
"r79Mj5S98j3GwgBCxmfmXoh8Yts82uMUcYvmOIN/tpSlSMBXtrN5zjCKi0lpYnuOE9opIplZEias" +
"D4NutyTCKxodUpyJEsJwggTYz/ck5zXtPe7Fixk6gq+1PQ0TV+U/Z5476NiXkohRTrfCimhql6Z1" +
"vRzb45afadTH0RSx10P+AcA5OLchCRGnwl3TSKPJ3S6jDG0SyMi7O0BRw0rUxfe3E0jzaUwgtrIg" +
"DIa3M3PhTha/uaY9nxapeyb4yBtjQ6DNE05wJHAMFWQasjI2lL5K4R385ACSFwKJRJEgb3iJkwTI" +
"HhTX93IRTy5gn1dojuvV1kUtfWZGjLfokIgv9PgJk91ewLKeNQwgCDIWk/i0wjyC8oC1rYIb0QQg" +
"8GmkRJY5xBC9l8aSWOxn5thyB07oAYKLk4xqKM05TwA7iwnwPJYTXEed4ZvGBnOxJtIc04gOXND0" +
"pVK3aKAsaPCsaJ6OdoUwqAjwrAmuFQwd3224APgrCHC1MAKeNWJkeaPADZphuM4IKwY867CMNGG5" +
"YsWwIsDzQhi6ztiX6axycd0IaFCFI+MLYmj9GMKFrlcWxCUlbmgNvGA4UiLaM8VunSE5qD370RS5" +
"dY5kUisIhLpXVLw6N3JwCa0uwT1d8upcyUFFHGsrpi+wzpwHg9rE4U8RoQbKfXophvaG6LtD64Lw" +
"YVBvj/BnTPPrniMHtbNjaxQEg3DUrvW+NtZNyW90JWiD3c3TF3juS43GBMNLvfUFnYs/9EeX+u/0" +
"WL9o+WVvLhr/Cgk0nzJ6NODdDXHiOZInC3figxna3g49WmoXUjwzYZtA8+XwvnmbO1P7DV4iUaW4" +
"KRXweVa4bcWyVEAwz4qgrVh1Fa4/aGtuuxpFse4qQsVYeNtKd5qmhIq1nzQSr23KXVcyHLclv2so" +
"flvyh4YyakvuNRTF6QcNZdim/KmhKAl41FDCNuWzhqJI/tJQlIW+aCiKuU8aiuL0Vw1FCd03DUVJ" +
"wLOGoqTxRUNRiuFvjUSpun80EqXq/u1KPCUui2ovNovXV1ZaVLuxqfGUyCx0+1HJ5EKzIz0lNgvN" +
"jgxUmzV7MlDt0WzK4LKWDV2rPrOWbSyGZraESwlNCAwxHCfzPVyhBIngBLulmSjPxoY45XDezCho" +
"q3uYbIty9jMqpsqbjRHRgzzPuvJ43vqrmp8QLkwDJQk93iQoey37554e77L8IB4w52gHy8j8wY+3" +
"jFHW+rE8hd94k5swCPwQlpE3t0OC3Pn943Jxf/vf8nF1+zS1zz9P7bYh4L1iNHgMiz4gtiPgQYK3" +
"xYFcvuxYeWp3ikO7oHlh2IYKODEXwz3cEzH0dccC8ZZSUX+RUQTmExaH3KCMwCG/uPrNzJwywRCB" +
"ILAJgVsHu4uLO0uJWhcMiA/ZZS9E7Cuj5OUEkAneoehUXfgu88sryfmiO/8fAAD//wMAUEsDBBQA" +
"BgAIAAAAIQAUmErMNgUAAEQVAAAUAAAAeGwvc2hhcmVkU3RyaW5ncy54bWyEGNty4jb0vTP9Bw1P" +
"2YcN2W27m3YIO2BCQiAsg0m2zYtHawtQYyRXkkOSr+8RJpjRkZyXxJyLzv0idb49b3LyxJTmUly0" +
"Pp2etQgTqcy4WF207hbDj+ctog0VGc2lYBetF6Zb37q//tLR2hDgFfqitTam+Kvd1umabag+lQUT" +
"gFlKtaEGfqpVWxeK0UyvGTObvP357OxLe0O5aJFUlsKA3POvLVIK/l/JohrS7Wje7ZhuLGYkHt91" +
"2qbbaVtQBZ5QsSrpirlwJpK72AOMei7wJF5LZT6QBUvXZMB0qnhhwBEuXWyyJvRSJfhsAA7n7kHc" +
"JKMFUk0nlz59p99dSiETDARz40uXUj95gEA5HHkcMxi7wIwmGAjsV30Pex9JB9sxUOR+4HSCpLNk" +
"gM7MWNLDrhNJdO2y23AgILBj4JyZUgkyElWueiI/o+kjpBiQpHmZMe3KuptPCDCTmZJZmRoiBbld" +
"KhJzg9LyB1WKCvPiHjGggus1+QgZJjZUPbr4KwZ1JADfK7VRnAbx8ZabV6ZyKNYgTXUY0uFSrPJK" +
"iT7LV7zcuAfUBA1SaqKAKTXBkAufnjXBnQAXZmQMfSiTDepMpdrSBnviLcsYLujizelxAX3ItXao" +
"oAfakAS8ccA3OONAM4SopygbRobmfBdW+4UMGOZs0xiQQWl2Gk6ZWVcxR7lpXcP4aifE7ybrnEqK" +
"3011OCIqaIZSD4UrNtTgIpnIlOaMRDJDbtihmnrrwY1+DXadOy6LAvo4OYmkMDQ1bVvQH9ygxkw9" +
"8ZQRKA+y53BJIqoZiU2ZcWzEQkKcwAYYe3JJvm8FzMw1L1DqMAo9hSVTumHJpxD2nuZlA3rH/Lnx" +
"6N8asb83Yv9oxH5pxH5txJ43Yv9sdtbZO956Bx88vXJ2ULUKHbSrQgedUqGDHq3QwXBU6GAsKzRK" +
"BBjEIzQf61ocKebrrUvun/54/tpBj1YXlvuAOrn92w1bYZI+ZtdJhAY9AyBacgDYw+wimWF2kTyg" +
"nQ6Ujx48Ks18y4MXeDlw2VPQE21oRe5R6V+a3Mxc9hsK4wamye4/06gJ7ochUMCXXQbcA46aPBDt" +
"I+0SXSnGoL29j7eEaMu4Zc88lcANA9GnQl/RV54DfgadtlyVHjOiNYcuHzwhkrnc/OQ0TNFTKyYM" +
"Fw0kM2lTO2xkLEuzJr2l4qk9JeCq6NUu/HNWlDlPw2SVqdD136yGz7D5R9QBsZeng9P+qZU3CGk2" +
"KZ/Z5qcs1cpmw24NceMc5/KJPlZ+3H26BK51u98u0cGR8OHJOKgi77aN93Kg9N5e8OXHti1fEU7Q" +
"zc5eadCdpG5wgUW4Jnh3y/VufUfbqXdlO+qwvpXtaEXeR8j1eU1Rh9mlmUixIie3j3ArbbiQQo+c" +
"oQkwY6oMF5eNKGqrRz59qz1XIcuHAuTEwq6yHj48BWq+qp94mPCUONpCbYfx8UzDroauJHzK4cFz" +
"JGffqjyirhvy8trGbgx/PHyjBhVHIvP6b9wQr7GEFxWPHDyOa7OqHu9j+ifsv1ua0xft1W+K5mwt" +
"a8q25IEBL76MQkbh5K05bRp7dIyvwjrGcEukcAXw5cYCPQXUohZrygMaLn6ExS0o31J0aQSz7tGK" +
"Usu6Z4K9lrCZIdu0h+9AHS5oeObAnfOml+Db7tv+sVfGVeBRJjjTdvlllxZvoqkymaOmMC815Inl" +
"qb5cOfrR09Vf10mESiPmmyLnSw4PALZ8YdeAQ72FDOy4IheKZty+49kL24E/WJ1wBo62/ww38m14" +
"Be3+DwAA//8DAFBLAwQUAAYACAAAACEAlzJrIBIDAAD1DAAAGwAAAHhsL2RyYXdpbmdzL3ZtbERy" +
"YXdpbmcxLnZtbOyX3W/aMBDA3yftf7DSB16g5IOP4hKkrtPetknbpD1MUxUSQ9w6vig2IfSv39kO" +
"FKa26wQvlYoEsX0fvjv/MMe0KQTBt1S0jr1VJalKc1YkqlfwtAIFC91LoaB1Ibz371pNeE4TFgue" +
"MuoeDzbNC2xYkzLhzXCfKVCVJyUTyQZWmtSUNTr2WMa1FRs5z4qkPJCQLNFJ7AVe37roH/iYTWvn" +
"Um9KRngWezeNj68bHfqhR1KAKlP8nsVeGIx8v2s/PYI+StzZ6GBYpEx0HntFVzh55XSFezSsDQ53" +
"0hXcMXILXCq9Eei14JpVLjKCoRhHZFklGWdS21ThLva02TAFKVmqTZyxV+Fom89eArts9jNRgR/5" +
"HnGGZwfpuSA6JSiuOUiazBWIlWaXJqkiqZZc9gRbaBoEQakv2xUNJQ3Oh7iw5pnOaRCOzsdmmjO+" +
"zDUdja3wvsdlxhoaWG81V3zOBdcbmvMsY/KyUNBbV0nZs1FQbWw7ZMGFSEFAFXtcLuBDkt4tK1jJ" +
"jPy68H/bauMhS8V0ARlWIllp2NXXGOOZoXX4uLlFwBQaa5vBmoC01W03nAvcDWs9V+mqYshCW+Pd" +
"yfx1ChIkezg7jTDOoSFtUU16GTcHhZXtJUJTE2rHMEjINOP1VtHYoZwvJTW17symfZRavWm/pq1b" +
"N2/otTBofESkydf5LXr/YYH4ArrFjEwb+hlq9pPr/JoJoVzOZvk7gvzI8pVMc6hcYCTskiDqEr9r" +
"RjgYBF0y7JLxtN/QfUV0d4X5fMKKzz4lQjGrsF1xSTb0G6xnvpGYwXbxGhkr5Cww6+3YiOx0l537" +
"rrZsP8l1cCTXYRhZVp8gOwwuzsM9sodjB/oW7fAN7VeENtIcItQO7QFyPsKZeVoSTwt3eAK4oyPh" +
"Hkwmz8E9jA7YjiaHbEdvbL8itvGKNje1YxsnQdBe36e/twfHoz0YH4l2FLke44l7ezJ66EaGw4Nu" +
"ZPA41geNx9kCXwx/W17YaWz137qLf3UXeNuGu+7CXL1DhBafF6fHNPofTPv4X2f2BwAA//8DAFBL" +
"AwQUAAYACAAAACEAmCVM324BAACVAgAAEQAIAWRvY1Byb3BzL2NvcmUueG1sIKIEASigAAEAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAfJJfS8MwFMXfBb9DybNtmv2RUboOVMYeNhGdKL5ISO62" +
"sCYpSVzXb2/abrUT8TE5Jz/OuTfp7Cjz4ADGCq2miEQxCkAxzYXaTtHreh5OUGAdVZzmWsEUVWDR" +
"LLu+SlmRMG3gyegCjBNgA09SNmHFFO2cKxKMLduBpDbyDuXFjTaSOn80W1xQtqdbwIM4vsUSHOXU" +
"UVwDw6IjohOSsw5ZfJm8AXCGIQcJyllMIoJ/vA6MtH8+aJSeUwpXFb7TKW6fzVkrdu6jFZ2xLMuo" +
"HDYxfH6C31fLl6ZqKFQ9KwYoSzlLmAHqtMmsgwN8OthDnqe4J9RD3ENVasNt9qiDZ7DOCOb8LmyK" +
"+2LtzKl1K7+ZjQB+V2VLIW+ChWb7YAFq29h/OXyGpnIbBHjgSyRt5bPyNrx/WM9R5nsMw3gUxpM1" +
"mSSjQRKPP+qoF+/rUu2FPMX4l0jGISEeuiYeN0rGpEc8A7Im9+VHyr4BAAD//wMAUEsDBBQABgAI" +
"AAAAIQDDj7BYNwEAAOgEAAAnAAAAeGwvcHJpbnRlclNldHRpbmdzL3ByaW50ZXJTZXR0aW5nczEu" +
"YmlucmJwZ/BhMGXQZXAD0kFA2gyInRgUGPIZ8oCkE1g0ACjjxxAC5IFUGzIYMBgx6DGAACMLg8gd" +
"Bh4W5u8MLIwMjGAxoCgDO0MEE4gfwcQEF4VKUp0C2cqMxdRHS6bvYWBkZPqPcINPakVuYlG2QoiZ" +
"iRE2dzi5+5jquvkE6ZrpOink5yk4+QQFBPmFAIUNDYz0khgYzJgYGFAMUQhiqGCIB4YHAjgwNDD9" +
"r/9fzwAMSRYGAQZeBhEGNiCLnYEbSMPCCKSejYGVgROskZP5MMP+Y0wMxZagUFMD6gLFhBZQzpHB" +
"DqgF5BdQSP5ncGDYwBLBpAM2JgIoBGTAjfxIqyAmx1ygq9jJcg8XUBcMDyYPgdyCHHuDzW30cw9y" +
"KDAKwAKFBRo+AxFG64qQ4wbVBaC8AwAAAP//AwBQSwMEFAAGAAgAAAAhAA6BlJ8zAgAAMwUAABAA" +
"AAB4bC9jb21tZW50czEueG1sxJTBattAEIbvhb7DsOfWsnMoJlgKadJAIKWFJIcex9LYq3p3Z9lZ" +
"OVGfviPJTkgPIYdCQIjd0cyvnW9+aXX26B3sKUnLoTSL2dwAhZqbNmxLc3939XlpQDKGBh0HKk1P" +
"Ys6qjx9WNXtPIQuoQJDS2JzjaVFIbcmjzDhS0CcbTh6zbtO2kJgIG7FE2bviZD7/Unhsg6lW2GXL" +
"SY6L6pKcgwv2scuUdJEiJ8x6wlUxpT5l3ug5sUGL7hP8wmzbhL/xOeuQrsqH4960kp82kGhTmq8L" +
"A5PqdVMa7V8sRprW1SrToxYkvX7qTf7AHl1plqYYVBwnaENDj6SVy8UQTFcc8pR0h5Y9DsEN+tb1" +
"U/RkCBSjWh7YnUrEWsEqHKG0J1PVllkI8MA9NeC4RkegYyHYJPaQLYHTVmYAd1brANNQoE2u2zCS" +
"At7A9e2PsUZAxwAOw7bDrSqwc/xADax7fdyFnHrVudIUzyrThg2DEI0vuWHedVGUiU5tBqtCYRQK" +
"opi4FAes/yC9eD+k1e1oVoWmdlVGeouJm67O0JDUqY2Dj0CbPYYDetL+76Xr0OmUHIlo7xhgOYfa" +
"YsJaXSiacsueoOGHIFmd7EF6yeQFagyBM2hJo1MaIY71i5MXAm+Ed/kCnm5e8eNavfSfPVl9x7Sj" +
"rN8VDDPWts/X3OURZ1QY24TRqiPDdvbGhr69oxvO1+tE+xaz2l067zH1w5exox4kUi2v9HD09vTL" +
"OO6k+gsAAP//AwBQSwMEFAAGAAgAAAAhABakXLs/AQAAjgIAABMACAFkb2NQcm9wcy9jdXN0b20u" +
"eG1sIKIEASigAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAtJLRSsMwFIbvBd8h5D5L2rWu" +
"GW2HazcRRESn91maboE0KU06HeK7m6JzE7xSvAz/4eM7/0k6e2kU2InOSqMzGIwIBEJzU0m9yeDj" +
"aokSCKxjumLKaJHBvbBwlp+fpXedaUXnpLDAI7TN4Na5doqx5VvRMDvysfZJbbqGOf/sNtjUteSi" +
"NLxvhHY4JOQC894606D2Cwc/eNOd+y2yMnyws0+rfet18/QTvgd142SVwdcyLsoyJjEKF7RAAQnm" +
"iI7pBJGEkHAeFkt6uXiDoB2GQwg0a/zqK+l6e/V4XXrizk1V+2xdl4d1RYmIKKpJQFCUsADRKJqg" +
"dZxwzqOwDhKe4uN8ig82f/QaH7xKoVShmLXSt8ucP+Q3wVsD7oU3lXyI7L+4RKcuD/36hq2FGpo/" +
"3fvnDvDxI+XvAAAA//8DAFBLAwQUAAYACAAAACEAwZmm+8cBAADSAwAAEAAIAWRvY1Byb3BzL2Fw" +
"cC54bWwgogQBKKAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACcU11v2yAUfZ+0/2Dx3uC0" +
"3TRFmKqyM/UhW6Im7R4nhq9jFAwIrqNkv37YVlJn7SZtb/fj6HA4HNjdodHJHnxQ1mRkOklJAkba" +
"UpltRp42n68+kSSgMKXQ1kBGjhDIHX//jq28deBRQUgihQkZqRHdjNIga2hEmMS1iZvK+kZgbP2W" +
"2qpSEgor2wYM0us0/UjhgGBKKK/cmZAMjLM9/i9paWWnLzxvji4K5uzeOa2kwHhL/kVJb4OtMJkf" +
"JGhGx0sW1a1Btl7hkaeMjlu2lkJDHol5JXQARl8G7AFEZ9pKKB842+NsDxKtT4L6GW27JckPEaCT" +
"k5G98EoYjLI62ND0tXYBPf9m/S7UABgYjYBh2Jdj7LhWt/y6B8Tir8CB66tooEwehdnCvxwxffuI" +
"TuNw13j2pQsbhRrCsloJj2+YcjM2pZc2WDKojA9YthILQKH0hc6zKQtrd637w26Z3y/m3/NlMV+/" +
"8rF/mij3N4G5bZwwR16A1knXtAg+Ft5Z32eH0ROELZTZhSe3sYVAOOXhcsjWtfBQxgid83IesIcY" +
"Ba87krzuXqI8YV4vuvQ+D1+UTz9M0ps0BnM0Y/TlM/JfAAAA//8DAFBLAwQUAAYACAAAACEAcT7Z" +
"regAAADQBgAAJwAAAHhsL3ByaW50ZXJTZXR0aW5ncy9wcmludGVyU2V0dGluZ3MyLmJpbophiGFI" +
"ZChlKGYoYChiyGMoAZJFDEYMBgyGQJkgIMuZQZfBCcgzAmJMwMgiwn6H4Qur8HUGBkYgfMWVz5EC" +
"pPkZIphAfAYGZiD2YUgFmlwCJIsYFBgsgNiQQR9oogJDBZhtCCQzgbaTBkCmM+HRog6SY2N1AFEg" +
"dfjUkmg1VLkEmBZQB0EGBhCGAB1GHUYbYLhFMEUwIdMbWDawZAHFiQIg74GBBoMfQz4wdFIZNMlz" +
"JpouapuHz1Eafvl5qRQ4m1L9VAmwYWQIE8OVBXxA/zAy2AwbX1E/X4+mmqEYAqDiFwAAAP//AwBQ" +
"SwECLQAUAAYACAAAACEA8/lOy5kBAADpBgAAEwAAAAAAAAAAAAAAAAAAAAAAW0NvbnRlbnRfVHlw" +
"ZXNdLnhtbFBLAQItABQABgAIAAAAIQATXr5lAgEAAN8CAAALAAAAAAAAAAAAAAAAANIDAABfcmVs" +
"cy8ucmVsc1BLAQItABQABgAIAAAAIQBKqaZh+gAAAEcDAAAaAAAAAAAAAAAAAAAAAAUHAAB4bC9f" +
"cmVscy93b3JrYm9vay54bWwucmVsc1BLAQItABQABgAIAAAAIQDwtwCrPQIAAIIEAAAPAAAAAAAA" +
"AAAAAAAAAD8JAAB4bC93b3JrYm9vay54bWxQSwECLQAUAAYACAAAACEAS831WFEDAACpCwAADQAA" +
"AAAAAAAAAAAAAACpCwAAeGwvc3R5bGVzLnhtbFBLAQItABQABgAIAAAAIQATxCwTwgAAAEIBAAAj" +
"AAAAAAAAAAAAAAAAACUPAAB4bC93b3Jrc2hlZXRzL19yZWxzL3NoZWV0Mi54bWwucmVsc1BLAQIt" +
"ABQABgAIAAAAIQDVODs98AAAAF0CAAAjAAAAAAAAAAAAAAAAACgQAAB4bC93b3Jrc2hlZXRzL19y" +
"ZWxzL3NoZWV0MS54bWwucmVsc1BLAQItABQABgAIAAAAIQBJl+jOJgcAAKsmAAAYAAAAAAAAAAAA" +
"AAAAAFkRAAB4bC93b3Jrc2hlZXRzL3NoZWV0Mi54bWxQSwECLQAUAAYACAAAACEAg6/q440GAADj" +
"GwAAEwAAAAAAAAAAAAAAAAC1GAAAeGwvdGhlbWUvdGhlbWUxLnhtbFBLAQItABQABgAIAAAAIQBz" +
"DCZpnAQAAC0PAAAYAAAAAAAAAAAAAAAAAHMfAAB4bC93b3Jrc2hlZXRzL3NoZWV0MS54bWxQSwEC" +
"LQAUAAYACAAAACEAFJhKzDYFAABEFQAAFAAAAAAAAAAAAAAAAABFJAAAeGwvc2hhcmVkU3RyaW5n" +
"cy54bWxQSwECLQAUAAYACAAAACEAlzJrIBIDAAD1DAAAGwAAAAAAAAAAAAAAAACtKQAAeGwvZHJh" +
"d2luZ3Mvdm1sRHJhd2luZzEudm1sUEsBAi0AFAAGAAgAAAAhAJglTN9uAQAAlQIAABEAAAAAAAAA" +
"AAAAAAAA+CwAAGRvY1Byb3BzL2NvcmUueG1sUEsBAi0AFAAGAAgAAAAhAMOPsFg3AQAA6AQAACcA" +
"AAAAAAAAAAAAAAAAnS8AAHhsL3ByaW50ZXJTZXR0aW5ncy9wcmludGVyU2V0dGluZ3MxLmJpblBL" +
"AQItABQABgAIAAAAIQAOgZSfMwIAADMFAAAQAAAAAAAAAAAAAAAAABkxAAB4bC9jb21tZW50czEu" +
"eG1sUEsBAi0AFAAGAAgAAAAhABakXLs/AQAAjgIAABMAAAAAAAAAAAAAAAAAejMAAGRvY1Byb3Bz" +
"L2N1c3RvbS54bWxQSwECLQAUAAYACAAAACEAwZmm+8cBAADSAwAAEAAAAAAAAAAAAAAAAADyNQAA" +
"ZG9jUHJvcHMvYXBwLnhtbFBLAQItABQABgAIAAAAIQBxPtmt6AAAANAGAAAnAAAAAAAAAAAAAAAA" +
"AO84AAB4bC9wcmludGVyU2V0dGluZ3MvcHJpbnRlclNldHRpbmdzMi5iaW5QSwUGAAAAABIAEgDa" +
"BAAAHDoAAAAA";

        root.modifyTemplate = function (templateType, templateFileName, templateSheetName) {

			templateFileName = document.getElementById('sku').value.toString().concat("-",templateFileName);

            var htmlTableID = document.getElementById(templateType.toString().concat("-template"));
            var htmlTbody;

            if (htmlTableID)
                htmlTbody = htmlTableID.getElementsByTagName("tbody")[0].getElementsByTagName("tr");

            //Ensure template table is built
            if (htmlTableID && htmlTbody.length > 0) {

                switch (templateType) {
                    case "prc": templateSpreadsheet = templatePRC; break;
                    case "hmy": templateSpreadsheet = templateHmy; break;
                    default: return;
                }

                var xlsx = new openXml.OpenXmlPackage(templateSpreadsheet);
                var workbookPart = xlsx.workbookPart();
                var wbXDoc = workbookPart.getXDocument();
                var sheetElement = wbXDoc.root
                .element(S.sheets)
                .elements(S.sheet)
                .firstOrDefault(function (sh) {
                    return sh.attribute("name").value === templateSheetName;
                });
                if (sheetElement) {

                    //alert("Creating a copy of ".concat((templateType == "prc") ? "PRC" : "Harmony", " template.\n\nPlease wait for a moment until its notification prompts.\n\n"));

                    var id = sheetElement.attribute(R.id).value;
                    var worksheetPart = workbookPart.getPartById(id);
                    var wsXDoc = worksheetPart.getXDocument();
                    var table = wsXDoc.descendants(S.sheetData).firstOrDefault();
                    var newRow = []; var newCol = [];

                    var htmlTableData = "";
                    var htmlTableRows = htmlTableID.rows.length;
                    var htmlTbodyRows = htmlTbody.length;
                    var htmlTbodyCols = htmlTbody[0].getElementsByTagName("td").length;
                    var htmlTheadRows = htmlTableRows - htmlTbodyRows;
                    var htmlTbodyThisRow = 0;

                    for (var r = 0; r < htmlTbodyRows; r++) {
                        htmlTbodyThisRow = ++htmlTheadRows;
                        newRow[r] = new XElement(S.row, new XAttribute("r", htmlTbodyThisRow));
                        for (var c = 0; c < htmlTbodyCols; c++) {
                            htmlTableData = htmlTbody[r].getElementsByTagName("td")[c].textContent || htmlTbody[r].getElementsByTagName("td")[c].innerText;
                            //Preserve whitespace https: //msdn.microsoft.com/en-us/library/aa468566.aspx
                            if (htmlTableData)//in case null value
                                htmlTableData = htmlTableData.replace(/\s+/g, " ").replace(/^\s+|\s+$/g, ""); //.replace(/^\s|\s$/g, "");
                            newCol[c] = (htmlTableData) ? new XElement(S.c, new XAttribute("r", colName(c).toString().concat(htmlTbodyThisRow.toString())), new XAttribute("t", "inlineStr"), new XElement(S._is, new XElement(S.t, htmlTableData))) : null;
                            newRow[r].add(newCol[c]);
                        }
                    }
                    table.add(newRow);
                }
                spreadsheetToSave = xlsx.saveToBlob();
            }
            else {
                //alert("Unable to export generic content to either one or all of the templates.");
                return;
            }
        }

        root.exportTemplate = function (templateType, templateFileName, templateSheetName) {
			templateFileName = document.getElementById('sku').value.toString().concat("-",templateFileName);

			var answer;
            modifyTemplate(templateType, templateFileName, templateSheetName);
            if (spreadsheetToSave === null) {
                //alert("Template failed to export.");
                return;
            }
            else {
                switch (templateType) {
                    case "prc": answer = confirm("PRC template file is successfully created. Do you want to download?"); break;
                    case "hmy": answer = confirm("Harmony template file is successfully created. Do you want to download?\n\nNote: You may need to resave from .XLSX to .XLS file extension afterwards.\n\n"); break;
                    default: return;
                }
				if(answer)
				{				
					saveAs(spreadsheetToSave, templateFileName + ".xlsx");
					spreadsheetToSave = null;
				}
            }
        }

    } (this));
    //End of OpenXML for Excel
}

//$.noConflict();
$(function () {
    $("#rerun")
      .button()
      .click(function () {
		  $(".csd_export span").click(function(e) {
			if(navigator.appName == 'Microsoft Internet Explorer' ||  !!(navigator.userAgent.match(/Trident/) || navigator.userAgent.match(/rv:11/)) || (typeof $.browser !== "undefined" && $.browser.msie == 1))
			{
				e.preventDefault();
			}
			else
			{
				e.stopPropagation();
			}
		  }).trigger("click");
          exportTemplate('prc', 'prc-v2.0-template', 'Products');
          exportTemplate('hmy', 'hmy-template', 'ProductDetails');
      })
      .next()
        .button({
            text: false,
            icons: {
                primary: "ui-icon-triangle-1-s"
            }
        })
        .click(function () {
            var menu = $(this).parent().next().show().position({
                my: "left top",
                at: "left bottom",
                of: this
            });
            $(document).one("click", function () {
                menu.hide();
            });
            return false;
        })
        .parent()
          .buttonset()
          .next()
            .hide()
            .menu();
});