<html>    
    <body>
        <g:each in="${inboxMail}">
            <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">

                <div class="panel panel-default">
                    <div class="panel-heading" role="tab" id="headingTwo">
                        <h4 class="panel-title">
                            <a class="collapsed" id="font${it.messageObject}" role="button" onclick="readUpdate('${it.messageObject}','inbox')" data-toggle="collapse" data-parent="#accordion" href="#${it.messageObject}" aria-expanded="false" aria-controls="collapseTwo">
                                <g:if test="${it.read == "read"}">
                                    <div class="row">                                        
                                        <div class="col-md-2" style="font-size:11;">
                                            ${it.form.toString()}
                                        </div>
                                        <div class="col-md-4" style="font-size:11;">
                                            Subject : ${it.Subject}
                                        </div>
                                        <div class="col-md-3" style="font-size:11;">
                                            <g:if test="${it.Message.toString().indexOf("<br>") != -1}">
                                            ${raw(it.Message.toString().substring(0,(it.Message.toString().indexOf("<br>"))))}
                                        </g:if>
                                        <g:else>
                                            <g:if test="${raw(it.Message).toString().length() > 30}">                                            
                                            ${raw(it.Message.toString().substring(0,29))}....
                                        </g:if>
                                        <g:else>
                                            ${raw(it.Message)}
                                        </g:else>                                                                      
                                    </g:else>
                                </div>
                                <div class="col-md-2" style="font-size:11;">
                                    ${it.Date}
                                </div>
                                <div class="col-md-1" style="font-size:11;">
                                    <span style="color: red;cursor: pointer" onclick="deleteMail('${deleteMail}','${it.messageObject}')">x</span>
                                </div>
                            </div>
                        </g:if>
                        <g:else>
                            <span id="fontBold${it.messageObject}" style="font-weight: bold">

                                <div class="row">                                        
                                    <div class="col-md-2" style="font-size:11;">
                                        ${it.form.toString()}
                                    </div>
                                    <div class="col-md-4" style="font-size:11;">
                                        Subject : ${it.Subject}
                                    </div>
                                    <div class="col-md-3" style="font-size:11;">
                                        <g:if test="${it.Message.toString().indexOf("<br>") != -1}">
                                        ${raw(it.Message.toString().substring(0,(it.Message.toString().indexOf("<br>"))))}
                                    </g:if>
                                    <g:else>
                                        <g:if test="${raw(it.Message).toString().length() > 30}">                                            
                                        ${raw(it.Message.toString().substring(0,29))}....
                                    </g:if>
                                    <g:else>
                                        ${raw(it.Message)}
                                    </g:else>                                                                      
                                </g:else>
                            </div>
                            <div class="col-md-2" style="font-size:11;">
                                ${it.Date}
                            </div>
                            <div class="col-md-1" style="font-size:11;">
                                <span style="color: red;cursor: pointer" onclick="deleteMail('${deleteMail}','${it.messageObject}')">x</span>
                            </div>

                        </div>

                    </span>
                </g:else>
            </a>
        </h4>
    </div>
    <div id="${it.messageObject}" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTwo">
        <div class="panel-body" style="font-size: 11">
            <div class="row">
                <div class="col-md-1">From</div>
                <div class="col-md-10" id="fromDiv${it.messageObject}" style="color:#269ABC">${it.form.toString()}</div>
                <div class="col-md-1"></div>
            </div>

            <br/>
            <div class="row">
                <div class="col-md-1">To</div>
                <div class="col-md-10" id="toDiv${it.messageObject}" style="color:#269ABC">
                    <g:each in="${it.to}" var="to">
                        ${to}
                    </g:each>
                </div>
                <div class="col-md-1"></div>
            </div>

            <br/>
            <g:if test="${it.cc}">
                <div class="row">
                    <div class="col-md-1">CC</div>
                    <div class="col-md-10" id="ccDiv${it.messageObject}" style="color:#269ABC">
                        <g:each in="${it.cc}" var="cc">
                            ${cc},
                        </g:each>
                    </div>
                    <div class="col-md-1"></div>
                </div>

                <br/>
            </g:if>
            <div class="row">
                <div class="col-md-1">Subject</div>
                <div class="col-md-10" id="subjectDiv${it.messageObject}"><b>${it.Subject}</b></div>
                <div class="col-md-1"></div>
            </div>
            <br/>
            <div class="row">
                <div class="col-md-1">Message</div>
                <div class="col-md-10" id="messageDiv${it.messageObject}">${raw(it.Message)}</div>
                <div class="col-md-1"></div>
            </div>
            <br/>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-1" style="#269ABC"><a href="javascript:void(0)" onclick="reply('${it.messageObject}')">Reply</a></div>
                <div class="col-md-1" style="#269ABC"><a href="javascript:void(0)" onclick="replyToAll('${it.messageObject}')">Reply To All</a></div>
                <div class="col-md-1" style="#269ABC"><a href="javascript:void(0)" onclick="forward('${it.messageObject}')">Forward</a></div>
                <div class="col-md-1">

                    <a class="dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" id="clickMove" aria-expanded="false">Move<span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="javascript:void(0)" onclick="mailMove('inbox','${it.messageObject}','${folderName}')" style="font-size: 10">Inbox</a></li>
                            <g:each in="${folder}" var="ff">
                            <li><a href="javascript:void(0)"  onclick="mailMove('client/${ff.folderName}','${it.messageObject}','${folderName}')"style="font-size: 10"> ${ff.folderName}</a></li>
                            </g:each>
                        <li><input type="text" id="newFolderName${it.messageObject}" style="padding-top: 3px;width: 150px;height: 22px" class="form-control input-sm" placeholder="Enter new folder name"><button type="button"  onclick="mailMove('newFolder','${it.messageObject}','${folderName}')" class="btn btn-success btn-xs">create</button></li>
                    </ul>

                </div>
                <div class="col-md-5" style="#269ABC"><a href="javascript:void(0)" onclick="deleteMail('${folderName}','${it.messageObject}')">Delete</a></div>
                <div class="col-md-2" id="dateDiv${it.messageObject}">${it.Date}</div>
            </div>
        </div>
    </div>
</div>               
</div>
</g:each>
<br>
<input type="hidden" id='statusInbox' style='color:white' value="1">

</body>
</html>
