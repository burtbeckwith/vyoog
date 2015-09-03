<html>
    <head>
        <title>Vyoog Login</title>
        <g:javascript src="mail/jquery.js"/>
        <link href="../css/bootstrap.css" type="text/css"        rel="stylesheet" />
    <body>
        <div style="background: gray;color: white;height: 50px;font-size: 18px"><center>Vyoog Mail</center></div>
        <br/><br/><br/><br/><br/>
        <div class="row">
            <div class="col-md-4"></div>
            <div class="col-md-4">
                <div class="panel panel-info">
                    <div class="panel-heading">Login</div>
                    <div class="panel-body">
                        <center><div style="color:red" id="mailMessage">${flash.message}</div>            </center>
                        <br/><br/>
                        <g:form controller="Mail" action="mailAuth">
                            <div class="row">
                                <div class="col-md-1"></div><div class="col-md-4">Email Address</div><div class="col-md-6"><g:textField name="emailAddress" id="emailAddress" class="form-control input-sm" placeholder="Email Address"/></div><div class="col-md-4"></div>
                            </div>
                            <br/>
                            <div class="row">
                                <div class="col-md-1"></div><div class="col-md-4">Password</div><div class="col-md-6">  <g:passwordField name="password" id="password" placeholder="password" class="form-control input-sm" placeholder="password"/></div><div class="col-md-4"></div>
                            </div>
                            <br/>
                            <div class="row">
                                <div class="col-md-2"></div>
                                <g:actionSubmit class="btn btn-info btn-sm" value="Login" action="mailAuth" />
                            </div>
                        </g:form>
                        </br>
                    </div>
                </div>
            </div>
            <div class="col-md-4"></div>
        </div>
    </body>
</html>
