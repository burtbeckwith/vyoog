function deleteMail(folderName, messageId) {
    $.ajax({
        url: "deleteMail",
        type: "post",
        data: {messageId: messageId, folderName: folderName},
        dataType: 'text',
        success: function (data) {
            if (folderName === "inbox")
                loadInbox();
            else
                clientFolderView2(folderName);
        }
    });
}
function reply(a) {
    newMailBoxOpen();
    var ccVal;
    var fromVal = $("#fromDiv" + a).text();
    var toVal = $("#toDiv" + a).text();
    toVal = toVal.replace(/(\r\n|\n|\r)/gm, "");
    toVal = toVal.replace(/ /g, '');
    var subjectVal = $("#subjectDiv" + a).text();
    var messageVal = $("#messageDiv" + a).text();
    var dateVal = $("#dateDiv" + a).text();
    $("#to").val(fromVal);
    $("#subject").val("RE:" + subjectVal);
    if ($("#ccDiv" + a).text() !== "")
    {
        ccVal = $("#ccDiv" + a).text();
        ccVal = ccVal.replace(/(\r\n|\n|\r)/gm, "");
        ccVal = ccVal.replace(/ /g, '');
        $("#messageMail").append("\n \n\n\n____________ Original Message ____________ \n<br/>From: " + fromVal + "\nTo: " + toVal + "\nCC: " + ccVal + "\nSent: " + dateVal + "\nSubject: " + subjectVal + "\n\n" + messageVal);
    }
    else
        $("#messageMail").append("\n \n\n\n____________ Original Message ____________ \n<br/>From: " + fromVal + "\nTo: " + toVal + "\nSent: " + dateVal + "\nSubject: " + subjectVal + "\n\n" + messageVal);
}
function closeCCBCC(a) {
    var b = "#" + a + "Div";
    $(b).remove();
}
function addCCBCC(a) {
    if (a === "cc")
        $("#ccbcc").append("<div class='row' id='ccDiv'><div class='col-md-2'><h6>CC</h6></div><div class='col-md-9'><input class='form-control input-sm' style='height:25px;' type='text' id='cc' placeholder='CC' /></div><div class='col-md-1'><span onclick=closeCCBCC('cc') style='cursor:pointer' class='glyphicon glyphicon-remove-circle' aria-hidden='true'></span></div></div>");
    else
        $("#ccbcc").append("<div class='row' id='bccDiv'><div class='col-md-2'><h6>BCC</h6></div><div class='col-md-9'><input class='form-control input-sm' style='height:25px;' type='text' id='bcc' placeholder='BCC' /></div><div class='col-md-1'><span style='cursor:pointer' onclick=closeCCBCC('bcc') class='glyphicon glyphicon-remove-circle' aria-hidden='true'></span></div></div>");
}

function readUpdate(a, b) {
    $.ajax({
        url: "readUpdate",
        type: "post",
        data: {messageId: a, folderName: b},
        dataType: 'text',
        success: function (data) {
            $("#fontBold0").css("font-color", "red");
            $("#fontBold0").css("font-weight", "normal");
        }
    });
}
function forward(a) {
    newMailBoxOpen();
    var ccVal;
    var fromVal = $("#fromDiv" + a).text();
    var toVal = $("#toDiv" + a).text();
    toVal = toVal.replace(/(\r\n|\n|\r)/gm, "");
    toVal = toVal.replace(/ /g, '');
    var subjectVal = $("#subjectDiv" + a).text();
    var messageVal = $("#messageDiv" + a).text();
    var dateVal = $("#dateDiv" + a).text();
    $("#subject").val("Fwd: " + subjectVal);
    if ($("#ccDiv" + a).text() !== "")
    {
        ccVal = $("#ccDiv" + a).text();
        ccVal = ccVal.replace(/(\r\n|\n|\r)/gm, "");
        ccVal = ccVal.replace(/ /g, '');
        $("#messageMail").append("\n \n\n\n____________ Forwarded Message ____________ \n<br/>From: " + fromVal + "\nTo: " + toVal + "\nCC: " + ccVal + "\nSent: " + dateVal + "\nSubject: " + subjectVal + "\n\n" + messageVal);
    }
    else
        $("#messageMail").append("\n \n\n\n____________ Forwarded Message ____________ \n<br/>From: " + fromVal + "\nTo: " + toVal + "\nSent: " + dateVal + "\nSubject: " + subjectVal + "\n\n" + messageVal);
}
function replyToAll(a) {
    newMailBoxOpen();
    var ccVal;
    var fromVal = $("#fromDiv" + a).text();
    var toVal = $("#toDiv" + a).text();
    toVal = toVal.replace(/(\r\n|\n|\r)/gm, "");
    toVal = toVal.replace(/ /g, '');
    var subjectVal = $("#subjectDiv" + a).text();
    var messageVal = $("#messageDiv" + a).text();
    var dateVal = $("#dateDiv" + a).text();
    $("#subject").val("Re: " + subjectVal);
    $("#to").val(fromVal);
    if ($("#ccDiv" + a).text() !== "")
    {
        $("#ccbcc").append("<div class='row' id='ccDiv'><div class='col-md-2'><h6>CC</h6></div><div class='col-md-9'><input class='form-control input-sm' style='height:25px;' type='text' id='cc' placeholder='CC' /></div><div class='col-md-1'><span onclick=closeCCBCC('cc') style='cursor:pointer' class='glyphicon glyphicon-remove-circle' aria-hidden='true'></span></div></div>");
        ccVal = $("#ccDiv" + a).text();
        ccVal = ccVal.replace(/ /g, '');
        var res = ccVal.substring(1, ccVal.length - 3);

        $("#cc").val(ccVal.substring(1, ccVal.length - 3));

        $("#messageMail").append("\n \n\n\n____________ Original Message ____________ \n<br/>From: " + fromVal + "\nTo: " + toVal + "\nCC: " + $("#cc").val() + "\nSent: " + dateVal + "\nSubject: " + subjectVal + "\n\n" + messageVal);
    }
    else
        $("#messageMail").append("\n \n\n\n____________ Original Message ____________ \n<br/>From: " + fromVal + "\nTo: " + toVal + "\nSent: " + dateVal + "\nSubject: " + subjectVal + "\n\n" + messageVal);
}
function newMailBoxOpen() {
    $("#message").html("<div id='newMail' style='width: 440px;'><div class='panel panel-info'> <div class='panel-heading' style='color: white;background: skyblue'>New Mail<span style='position: absolute;right: 10px;cursor: pointer;' onclick='newMailClose()'>X</span></div> <div class='panel-body'><center><span style='color:red' id='mailvalidate'></span></center>  <div class='row'>     <div class='col-md-2'><h6>To</h6></div>     <div class='col-md-10'><input id='to' type='text' class='form-control input-sm' placeholder='To Address'/></div>   </div> <span style='font-size:10;padding-left:18%'>Add <span style='color:#31B0D5;cursor:pointer;' onclick=addCCBCC('cc');>CC</span> <span style='color:#31B0D5;cursor:pointer;' onclick=addCCBCC('bcc');>BCC</span></span><span id='ccbcc'></span><span style='font-size:10;padding-left: 90;color: gray;'>Note : using ',' for multiple mail address</span><div class='row'>     <div class='col-md-2'><h6>Subject</h6></div>     <div class='col-md-10'><input id='subject' type='text' placeholder='Subject' class='form-control input-sm'/><br/></div>   </div>   <hr>   <div class='row'><div class='col-md-2'><h6>Message</h6></div><div class='col-md-10'><textarea id='messageMail' class='form-control input-sm' placeholder='Message'  style='height: 200px;'></textarea></div></div><br><span class='btn-danger btn-sm' style='cursor: pointer;' onclick='sendMail()'>Send<span></div></div></div>");
}
function newMailBoxOpenAttach() {
    $("#message").html("<div id='newMail' style='width: 440px;'><div class='panel panel-info'> <div class='panel-heading' style='color: white;background: skyblue'>New Mail<span style='position: absolute;right: 10px;cursor: pointer;' onclick='newMailClose()'>X</span></div> <div class='panel-body'><center><span style='color:red' id='mailvalidate'></span></center>  <div class='row'>     <div class='col-md-2'><h6>To</h6></div>     <div class='col-md-10'><input id='to' type='text' class='form-control input-sm' placeholder='To Address'/></div>   </div> <span style='font-size:10;padding-left:18%'>Add <span style='color:#31B0D5;cursor:pointer;' onclick=addCCBCC('cc');>CC</span> <span style='color:#31B0D5;cursor:pointer;' onclick=addCCBCC('bcc');>BCC</span></span><span id='ccbcc'></span><span style='font-size:10;padding-left: 90;color: gray;'>Note : using ',' for multiple mail address</span><div class='row'>     <div class='col-md-2'><h6>Subject</h6></div>     <div class='col-md-10'><input id='subject' type='text' placeholder='Subject' class='form-control input-sm'/><br/></div>   </div>   <hr>   <div class='row'><div class='col-md-2'><h6>Message</h6></div><div class='col-md-10'><textarea id='messageMail' class='form-control input-sm' placeholder='Message'  style='height: 143px;'></textarea></div></div><br><span class='btn-danger btn-sm' style='cursor: pointer;' onclick='sendMail()'>Send<span></div></div></div>");
    addCCBCC("cc");
    $("#cc").val("support@mail.myvyooog.com");    
}
function sendMail() {
    var mailValidate = /@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
    var toMail = $('#to').val();
    var toMailSplit = toMail.split(',');
    var countMail = 0;
    for (i = 0; i < toMailSplit.length; i++)
    {
        if (mailValidate.test(toMailSplit[i]))
            countMail++;
    }
    if (countMail === toMailSplit.length) {
        $('input[type="submit"]').prop('disabled', true);
        $.ajax({
            url: "/VyoogErp3/mail/sendMail",
            type: "post",
            data: {emailAddress: $('#to').val(), cc: $('#cc').val(), bcc: $('#bcc').val(), subject: $('#subject').val(), message: $('#messageMail').val()},
            dataType: 'text',
            success: function (data) {
                newMailClose();
                $("body").append("<div id='tempalertmessage' style='position: fixed;left:600px;top:100px;width: 300px;'><p style='padding-left: 70px 'class='bg-primary'>Mail send SuccessFully</p></div>");
            }
        });
        setTimeout(function () {
            $("#tempalertmessage").html("");
        }, 5000);
    }
    else
    {
        $("#mailvalidate").html("Incorrect Email Address");
    }
}

function mailMove(a, b, c) {

    if (a === "newFolder")
        a = 'client/' + $("#newFolderName" + b).val();
    $.ajax({
        url: "mailMove",
        type: "post",
        dataType: 'text',
        data: {messageId: b, folderName: a, fromFolder: c},
        success: function (data) {
            if (c.substring(0, 6) === "client")
                clientFolderView2(data);
            else
                clientFolderView3(data);
        }
    });
}
function notificationCount() {
    $.ajax({
        url: "notificationCount",
        type: "post",
        dataType: 'text',
        success: function (data) {
            $("#circle1").html(data);
            document.title = "Mail(" + data + ")";
        }
    });
}
window.setInterval(function () {
    //   loadInbox()
    // notificationCount();
}, 5000);
function backgroundChange() {
    var min = 1;
    var max = 7;
    var random = Math.floor(Math.random() * (max - min + 1)) + min;
    $('body').css({"background-image": "url(../images/background" + random + ".jpg)", "background-repeat": "fixed"});

}
function clientFolder(folderName) {

    $.ajax({
        url: "loadMail",
        type: "post",
        dataType: 'text',
        data: {clientFolderName: folderName},
        success: function (data) {
            $("#mailContentBox").html(data);
        }
    });
}
function test(method) {
    alert(test);
    var link = "erpViewOpen?action=" + method + "&value=businessPartnerNameField:tttt,businessPartnerCodeField:test";
    window.open(link, '_blank');

}
function clientFolderView3(folderName) {
    $.ajax({
        url: "loadMailView3",
        type: "post",
        dataType: 'text',
        data: {clientFolderName: folderName},
        success: function (data) {
            $("#mailContentBox").html(data);
        }
    });
}
function newMailBoxOpenAttachment(toMail, Attachment, subject) {
    $("#message").html("<div id='newMail' style='height: 450px;width: 440px;'><div class='panel panel-info'> <div class='panel-heading' style='color: white;background: skyblue'>New Mail<span style='position: absolute;right: 10px;cursor: pointer;' onclick='newMailClose()'>x</span></div> <div class='panel-body' style='height: 400px;'><center><span style='color:red' id='mailvalidate'></span></center>  <div class='row'>     <div class='col-md-2'><h6>To</h6></div>     <div class='col-md-10'><input id='to' type='text' class='form-control input-sm' placeholder='To Address'/></div>   </div>   <br/>   <div class='row'>     <div class='col-md-2'><h6>Subject</h6></div>     <div class='col-md-10'><input id='subject' type='text' placeholder='Subject' class='form-control input-sm'/></div>   </div>  <br/> <div class='row'><div class='col-md-2'><h6>Attachments</h6></div><div class='col-md-10'><input class='form-control input-sm' type='text' id='attachmentfile'/></div>     </div><hr>   <div class='row'>     <div class='col-md-2'><h6>Message</h6></div><div class='col-md-10'><textarea id='messageMail' class='form-control input-sm' placeholder='Message'  style='height: 150px;'></textarea></div></div><br><input type='submit' class='btn btn-danger btn-sm' style='cursor: pointer;' onclick='sendMail()' value='Send'></div></div></div>");
    $("#attachmentfile").val(Attachment);
    $("#to").val(toMail);
    $("#subject").val(subject);
}

function dashboard() {    
    var request = $.ajax({
        url: "dashboard",
        type: "post",
        dataType: 'text',
        success: function (data) {
            $("#changeDashboard").html(data);
        }
    });
    request.abort();
}
function newMailClose() {
    $("#message").html("");
}
function sendMailAttachment() {

    var mailValidate = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
    if (mailValidate.test($('#to').val())) {


        $('input[type="submit"]').prop('disabled', true);
        $.ajax({
            url: "sendMail",
            type: "post",
            data: {emailAddress: $('#to').val(), subject: $('#subject').val(), message: $('#messageMail').val(), attachment: $('#attachmentfile').val()},
            dataType: 'text',
            success: function (data) {
                newMailClose();
                $("body").append("<div id='tempalertmessage' style='position: fixed;left:600px;top:100px;width: 300px;'><p style='padding-left: 70px 'class='bg-primary'>Mail send SuccessFully</p></div>");
            }
        });
    }
}
function loadInbox() {


    $.ajax({
        url: "loadInboxMail",
        type: "post",
        dataType: 'text',
        success: function (data) {
            $("#mailContentBox").html(data);
        }
    });

}
function clientFolderView2(folderName) {
    if (folderName === "client/inbox")
        loadInbox();
    else
    {
        $.ajax({
            url: "loadMailView2",
            type: "post",
            dataType: 'text',
            data: {clientFolderName: folderName},
            success: function (data) {
                $("#mailContentBox").html(data);
            }
        });
    }
}
function readUpdate(a, b) {
    $.ajax({
        url: "readUpdate",
        type: "post",
        data: {messageId: a, folderName: b},
        dataType: 'text',
        success: function (data) {
            $("#font" + a).css("font-weight", "normal");
        }
    });
}
























function newWindow(method, value) {
    var link = "erpViewOpen?action=" + method + "&" + value;
    window.open(link, '_blank');

}
function readUpdate(a, b) {
    $.ajax({
        url: "readUpdate",
        type: "post",
        data: {messageId: a, folderName: b},
        dataType: 'text',
        success: function (data) {
            $("#font" + a).css("font-weight", "normal");
        }
    });
}