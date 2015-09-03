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
                                        <div class="col-md-4" style="font-size:11;">
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
                                </div>
                            </g:if>
                            <g:else>
                                <b>
                                    <div class="row">                                        
                                        <div class="col-md-2" style="font-size:11;">
                                            ${it.form.toString()}
                                        </div>
                                        <div class="col-md-4" style="font-size:11;">
                                            Subject : ${it.Subject}
                                        </div>
                                        <div class="col-md-4" style="font-size:11;">
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
                                </div>
                            </b>
                        </g:else>
                    </a>
                </h4>
            </div>
            <div id="${it.messageObject}" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTwo">
                <div class="panel-body" style="font-size: 11">
                    <div class="row">
                        <div class="col-md-1">From</div>
                        <div class="col-md-10" style="color:#269ABC">${it.form.toString()}</div>
                        <div class="col-md-1"></div>
                    </div>
                    <br/>
                    <div class="row">
                        <div class="col-md-1">Subject</div>
                        <div class="col-md-10"><b>${it.Subject}</b></div>
                        <div class="col-md-1"></div>
                    </div>
                    <br/>
                    <div class="row">
                        <div class="col-md-1">Message</div>
                        <div class="col-md-10">${raw(it.Message)}</div>
                        <div class="col-md-1"></div>
                    </div>
                    <br/>
                    <div class="row">
                        <div class="col-md-1"></div>
                        <div class="col-md-1" style="#269ABC"><a href="">Reply</a></div>
                        <div class="col-md-1" style="#269ABC"><a href="">Forward</a></div>
                        <div class="col-md-7" style="#269ABC"><a href="">Delete</a></div>
                        <div class="col-md-2">${it.Date}</div>
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
