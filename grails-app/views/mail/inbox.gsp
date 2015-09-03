<!--
  To change this license header, choose License Headers in Project Properties.
  To change this template file, choose Tools | Templates
  and open the template in the editor.
-->

<%@ page contentType="text/html;charset=UTF-8" %>

<html>
    <head>
        <link href="../css/bootstrap.css" type="text/css"        rel="stylesheet" />
        <g:javascript src="mail/jquery.js"/>
        <g:javascript src="mail/bootstrap.min.js"/>
        <g:javascript src="mail/mail.js"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>${session.mailUser.emailAddress}</title>
        <style>
            #circle {
            width: 13px;
            height: 13px;
            -webkit-border-radius: 25px;
            -moz-border-radius: 25px;
            border-radius: 25px; 
            background:red;
            }
            #newMail{
            -webkit-box-shadow: -3px -1px 25px 0px rgba(0,0,0,1);
            -moz-box-shadow: -3px -1px 25px 0px rgba(0,0,0,1);
            box-shadow: -3px -1px 25px 0px rgba(0,0,0,1);
            }
            .vr {
            left:220px;
            background: #e0e0e0;
            width: 1px;            
            display:block;
            position: absolute;
            top:110px;
            bottom: 0;
            right: 0;
            height: 100%;
            }
            body,html{
            overflow-x:hidden;
            }
            @font-face {
            font-family: 'Glyphicons Halflings';

            src: url('../fonts/glyphicons-halflings-regular.eot');
            src: url('../fonts/glyphicons-halflings-regular.eot?#iefix') format('embedded-opentype'), url('../fonts/glyphicons-halflings-regular.woff2') format('woff2'), url('../fonts/glyphicons-halflings-regular.woff') format('woff'), url('../fonts/glyphicons-halflings-regular.ttf') format('truetype'), url('../fonts/glyphicons-halflings-regular.svg#glyphicons_halflingsregular') format('svg');
            }

        </style>
    </head>
    <body onload="loadInbox(),backgroundChange(),notificationCount()" background="../images/background3.jpg">
        <div style="background: gray;color: white;height: 50px;font-size: 18px"><center>Vyoog Mail</center></div>
        <br/>
        <div class="row">
            <div class="col-md-9"></div>
            <div class="col-md-3" style="color:skyblue;"> 
                <span class="glyphicon glyphicon-user" aria-hidden="true"></span><span id="circle" style="color: white;font-size: 10;padding-left: 1px;width:100%;font-weight: bold;"><span id="circle1" style="padding-left:5px">${notification}</span><span style="color:red">0</span></span>  
                <span class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"> ${session.mailUser.emailAddress}<span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="dashboard"><span class="glyphicon glyphicon-dashboard" aria-hidden="true"></span> Dashboard</a></li>
                        <li><a href="inbox"><span class="glyphicon glyphicon-envelope" aria-hidden="true"></span> Inbox</a></li>
                        <li><a href="logout">Logout</a></li>
                    </ul>
                </span>
            </div>
        </div>
        <hr>

        <div class="vr">&nbsp;</div>
        <div class="row">
            <div class="col-md-2">
                <div style="padding-left: 30px;">
                    <div class="btn btn-info btn-sm" onclick="newMailBoxOpen()">Compose Mail</div>
                    <br><br>
                    <g:remoteLink action="loadInboxMail" style="color: #31B0D5" update="mailContentBox">Inbox</g:remoteLink>
                        <br><br>
                        <span style="cursor: pointer;color: #31B0D5;" onclick="clientFolderView2('Drafts')">Drafts</span>
                        <br><br>
                        <span style="cursor: pointer;color: #31B0D5;" onclick="clientFolderView3('sent')">Sent Mail</span>
                        <br><br>
                        <span style="cursor: pointer;color: #31B0D5;" onclick="clientFolderView3('Trash')">Trash</span>
                    </div> 
                    <hr style="width: 110%;">
                    <center><span style="color: #F52A61">Client Requirements</span></center>
                    <br/>
                <g:each in="${folder}">

                    <div class="row">
                        <div class="col-md-2"></div>
                        <div class="col-md-8 btn btn-info btn-warning btn-xs" onclick="clientFolderView2('client/${it.folderName}')" style="cursor: pointer">                     
                            <div class="row">                                                                        
                                <div class="col-md-7">
                                    ${it.folderName}
                                </div>
                                <div class="col-md-3">
                                    ${it.unreadCount} / ${it.totalMail} 
                                </div>
                                <div class="col-md-2"></div>
                            </div>

                        </div>
                        <div class="col-md-2"></div>
                    </div>
                    <br/>
                </g:each>
            </div>
            <div class="col-md-10" id="mailContentBox" ><input type="hidden" id='statusInbox' style='color:white' value="1"></div>
        </div>
        <div id="message" style="position: fixed;bottom: 0px;right: 10px;">
        </div>        
    </body>
</html>