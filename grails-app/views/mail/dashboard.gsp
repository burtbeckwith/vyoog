<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Dashboard</title>
        <link href="../css/bootstrap.css" type="text/css"        rel="stylesheet" />
        <g:javascript src="mail/jquery.js"/>
        <g:javascript src="mail/mail.js"/>
        <g:javascript src="mail/bootstrap.min.js"/>
        <style>
            .vr {
            left:200px;
            background: white;
            width: 1px;            
            display:block;
            position: absolute;
            top:50px;
            bottom: 0;
            right: 0;
            min-height: 100%;
            }
            @font-face {
            font-family: 'Glyphicons Halflings';
            src: url('../fonts/glyphicons-halflings-regular.eot');
            src: url('../fonts/glyphicons-halflings-regular.eot?#iefix') format('embedded-opentype'), url('../fonts/glyphicons-halflings-regular.woff2') format('woff2'), url('../fonts/glyphicons-halflings-regular.woff') format('woff'), url('../fonts/glyphicons-halflings-regular.ttf') format('truetype'), url('../fonts/glyphicons-halflings-regular.svg#glyphicons_halflingsregular') format('svg');
            }
            #circle {
            width: 13px;
            height: 13px;
            -webkit-border-radius: 25px;
            -moz-border-radius: 25px;
            border-radius: 25px; 
            background:red;
            }
        </style>
        
    </head>
    <body style="background: #DDDEDE" id="changeDashboard">     

        <div class="vr">&nbsp;</div>
        <div style="background: gray;color: white;height: 50px;font-size: 18px"><center>Vyoog Mail</center></div>
        <br>
        <div style="color:skyblue;padding-left:83%;"> 
            <span class="glyphicon glyphicon-user" aria-hidden="true"></span><span id="circle" style="color: white;font-size: 10;padding-left: 1px;width:100%;font-weight: bold;"><span id="circle1" style="padding-left:5px">${notification}</span><span style="color:red">0</span></span>  
            <span class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"> ${session.mailUser.emailAddress}<span class="caret"></span></a>
                <ul class="dropdown-menu">
                    <li><a href="dashboard">Dashboard</a></li>
                    <li><a href="inbox">Inbox</a></li>
                    <li><a href="logout">Logout</a></li>
                </ul>
            </span>
        </div>
        <br>
        <div class="row">
            <div class="col-md-2 col-lg-2 col-sm-2 col-xs-2 col-lg-2" style="font-size: 11px;">
                <div style="padding-left: 10px;padding-right: 10px">
                    <div class="panel panel-info" style="">
                        <div class="panel-heading" style="color: white;background: #58C3EF">
                            Notifications
                        </div>
                        <div class="panel-body">
                            Normal Mail view <span class="glyphicon glyphicon-envelope" aria-hidden="true"></span><a href="inbox"> inbox</a>
                            <br/>
                            <br/>
                            Go to dashboard <span class="glyphicon glyphicon-dashboard" aria-hidden="true"></span><a href="dashboard"> dashboard</a>
                            <br/><br/>
                            <g:each in="${dashboard}" var="it" status="i">                                
                                <g:if test="${it.unReadCount !=0}">
                                    ${it.folderName} unread messages ${it.unReadCount}</br>
                                </g:if>
                                <g:else>
                                    <span style="font-size: 12px;cursor: pointer;color:#58C3EF" onclick="clientFolderView2('client/${it.folderName}')">${it.folderName}</span><br/>
                                </g:else>
                            </g:each>

                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-10 col-lg-10 col-sm-10 col-xs-10 col-lg-10" id="mailContentBox">
                <input id="dashboardVal" type="hidden" value="display" />
                <div class="row">
                    <g:each in="${dashboard}" var="it" status="i">                       
                        <div class="col-md-1 col-lg-1 col-sm-1 col-xs-1 col-lg-1" style="background:${it.color};height: 15%;color: white">                
                            <span style="position: absolute;top: 40%;left: 35%"><center>${it.unReadCount}/${it.messageCount}</center></span>
                            <span style="font-size: 9px;position: absolute;bottom: 0%;">
                                <g:if test="${it.unReadCount!=0}">
                                    ${it.unReadCount} UnreadMessages
                                </g:if>
                                <g:else>
                                    No New Mails
                                </g:else>
                            </span>
                        </div>
                        <div class="col-md-2 col-lg-2 col-sm-2 col-xs-2 col-lg-2" style="background: white;height: 15%;color: gray;">                
                            
                                <br><br><g:if test="${it.unReadCount!=0}"> <span class="glyphicon glyphicon-envelope"  aria-hidden="true"></span></g:if> <span style="position: absolute;bottom: 40%;left: 0%;width: 100%;"><center>${it.folderName}</center></span></center>
                            <span style="position: absolute;bottom: 1%;right: 5%;font-size: 12px;cursor: pointer;color:skyblue" onclick="clientFolderView2('client/${it.folderName}')">Click Here</span>
                        </div>                       
                        <div class="col-md-1 col-lg-1 col-sm-1 col-xs-1 col-lg-1"></div>
                        <g:if test="${(i+1)%3==0}">  
                            <div class="col-md-1 col-lg-1 col-sm-1 col-xs-1 col-lg-1"></div>
                        </div>
                        <br/>
                        <div class="row">
                        </g:if>
                    </g:each>
                </div>
            </div>
            <div id="message" style="position: absolute;bottom: 10px;right: 10px;">
            </div>
    </body>
</html>
