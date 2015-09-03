<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sample title</title>
    </head>
    <g:javascript src="mail/jquery.js"/>
    
    
    <script>
        function erpPageLoad(){


        var method = getUrlVars()["action"];
        var values = getUrlVars()["value"];        
        console.log("BBBB");
        $("#update").load("../"+method.toString()+"/create", function(responseTxt, statusTxt, xhr){

        if(statusTxt == "success"){        
        for (var i = 0; i < valueSplit.length; i++) {
        valueSplit[i] = valueSplit[i].replace(/_/gi," ");
        var pos = valueSplit[i].indexOf(':');        
        var divId=valueSplit[i].substring(0,pos);

        var changeVal=valueSplit[i].substring(pos+1,valueSplit[i].Length);                
        $("#"+divId).val(changeVal);
        } 
        }


        });
        console.log("SSSSS");
        $("#update").load("../"+method+"/create")


        var valueSplit= values.split(',');        


        }
        function getUrlVars()
        {
        var vars = [], hash;
        var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
        for(var i = 0; i < hashes.length; i++)
        {
        hash = hashes[i].split('=');
        vars.push(hash[0]);
        vars[hash[0]] = hash[1];
        }
        return vars;
        }
    </script>
    <body onload="erpPageLoad()" id="update">
        Loading
    </body>
</html>
