package vyoogmail

import javax.mail.Flags
import javax.mail.Folder
import javax.mail.Message
import javax.mail.Session
import javax.mail.Store
import javax.mail.internet.InternetAddress
import javax.mail.internet.MimeMessage
import javax.mail.internet.MimeMultipart
import javax.mail.search.FlagTerm

class MailController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def vyoogMailService

    def login(){
        if(session.mailUser)
        redirect(action:"dashboard")
    }

    def logout(){
        session.mailUser=null
        redirect(action:"login")
    }

    def mailAuth(){
        //mail login
        if(VyoogMailService.userLogin(params.emailAddress,params.password)=="Fail"){
            flash.message="Enter correct email address & Password"
            redirect(action: "login")
        }
        else
        {
            def sessionMailUser=[emailAddress:params.emailAddress,password:params.password,store:VyoogMailService.userLogin(params.emailAddress,params.password)]
            session.mailUser = sessionMailUser
            redirect(action: "dashboard")
        }
    }

    def dashboard(){
        //dashboard create dynamic folder and mail move
        if(session?.mailLoginPassword && session?.userName && !session.mailUser)
        {
            def userInstance = UserAccount?.findByUserName(session?.userName)
            def employmentInstance = Employment?.findByUserName(userInstance)

            if(VyoogMailService.userLogin(employmentInstance?.organizationalEmailID,session?.mailLoginPassword)=="Fail"){
                flash.message="Email Not configure in ERP Please Contact Administrator"
            }
            else
            {
                def sessionMailUser=[emailAddress:employmentInstance?.organizationalEmailID,password:session?.mailLoginPassword,store:VyoogMailService.userLogin(employmentInstance.organizationalEmailID,session?.mailLoginPassword)]
                session.mailUser = sessionMailUser
            }
        }
        if(session.mailUser)
        {
            inbox()
            def dashboard=[]
            def colorCode=["#58C3EF","#FC6A5D","#F8D347","#736F6E","#52D017","#F778A1"]
            int count=0
            Store store =  session?.mailUser?.store
            Folder[] f =  store.getFolder("client").list()
            Folder inbox = store.getFolder("inbox")
            inbox.open(Folder.READ_ONLY)
            def messages = [folderName:inbox.toString(),messageCount:inbox.getMessageCount(),unReadCount:inbox.search(new FlagTerm(new Flags(Flags.Flag.SEEN), false)).length,color:colorCode.get(count)]
            dashboard.add(messages)
            count++
            f.each{
                Folder nw = store.getFolder(it.toString())
                nw.open(Folder.READ_ONLY)
                def message = [folderName:nw.toString().substring(7,nw.toString().length()),messageCount:nw.getMessageCount(),unReadCount:nw.search(new FlagTerm(new Flags(Flags.Flag.SEEN), false)).length,color:colorCode.get(count)]
                dashboard.add(message)
                count++
                nw.close(true)
                if(colorCode.size()<=count) {
                    count=0
                }
            }
            [dashboard:dashboard]
        }
        else {
            redirect(action:"login")
        }
    }

    def inbox(){
        if(session.mailUser)
        {
            //ERP User Login for mail
//            def erpUserEmployment = Employment.findByOrganizationalEmailID(session?.mailUser?.emailAddress.toString())
//            session?.mailUser?.employment = erpUserEmployment
            boolean mailMoveApproval = false
            //ERP Folder setup for Mail Move
            def inboxMessageKeywords=[Sales_And_Marketing:["enquiry","invoice","order","invoise"],Market:["1","2"]]
            def mailUsers=[""]
            //folder create each mail in client
            Store store=  session?.mailUser?.store
            Folder[] allFolder = store.getDefaultFolder().list("*")
            if(allFolder.toString().indexOf("client") == -1){
                Folder defaultFolder = store.getDefaultFolder()
                Folder newFolder = defaultFolder.getFolder("client")
                newFolder.create(Folder.HOLDS_MESSAGES)
            }
            //add client Folder in user view and count of the each mail

            Folder inboxFolder = store.getFolder("inbox")
            inboxFolder.open(Folder.READ_WRITE)
            Message[] messages = inboxFolder.getMessages()
            //mail move based on subject
            for (int i = messages.length - 1; i >= 0; i--) {
                Message allMessage = messages[i]
                allMessage.setFlag(Flags.Flag.SEEN, false)
                int temp = 0
                String messageBasedFolderName=""
                inboxMessageKeywords.each{par->
                    par.getValue().each{
                        if(allMessage.getContent().toString().toLowerCase().indexOf(it.toString().toLowerCase())!=-1)
                        {
                            if(erpUserEmployment?.department.toString().replaceAll(" ","_").toLowerCase() == par.getKey().toString().toString().toLowerCase()){
                                mailMoveApproval = true
                                messageBasedFolderName=erpUserEmployment.department.toString()
                            }
                        }
                    }
                }
                // Mail Move client requirement corrspending mail folder
                if(messageBasedFolderName != "")
                {
                    Folder cilentMainFolder = store.getFolder("client")
                    Folder newSubFolder = cilentMainFolder.getFolder(messageBasedFolderName)
                    newSubFolder.create(Folder.HOLDS_MESSAGES)
                }
                // mail Move
                if(mailMoveApproval == true && allFolder.toString().indexOf("client/"+messageBasedFolderName) != -1){
                    mailMoveApproval = false
                    Folder moveMessage = store.getFolder("client/"+messageBasedFolderName)
                    allMessage.setFlag(Flags.Flag.SEEN, false)
                    moveMessage.open(Folder.READ_WRITE)
                    moveMessage.appendMessages(allMessage)
                    moveMessage.close(true)
                    //delete mail for the move client folder mail
                    Folder inboxFolderRemove = store.getFolder("inbox")
                    inboxFolderRemove.open(Folder.READ_WRITE)
                    inboxFolderRemove.getMessage(allMessage.getMessageNumber()).setFlag(Flags.Flag.DELETED, true)
                    allMessage.setFlag(Flags.Flag.SEEN, false)
                    inboxFolderRemove.close(true)
                }
            //Client Mail based folder
            }
            [folder:VyoogMailService.clientFolder(session?.mailUser?.store)]
        }
        else {
            redirect(action:"login")
        }
    }

    def notificationCount(){
        // notification count for unread mails
        Folder emailFolder =  session?.mailUser?.store?.getFolder("inbox")
        emailFolder.open(Folder.READ_ONLY)
        Message[] unreadmessages = emailFolder.search(new FlagTerm(new Flags(Flags.Flag.SEEN), false))
        render unreadmessages.size()
    }

    def loadInboxMail(){
        def inboxMail=[]
        boolean flag = false
        // user login call in Service Method and get the inbox folder

        Folder emailFolder = session?.mailUser?.store?.getFolder("inbox")

        // email folder set the read or write
        emailFolder.open(Folder.READ_ONLY)

        // set the array for all messages.this method load all inbox mails
        Message[] messages = emailFolder.getMessages()
        // set the array for unreadmessages.this method load only user unread messages
        Message[] unreadmessages = emailFolder.search(new FlagTerm(new Flags(Flags.Flag.SEEN), false))
        for (int i = messages.length - 1; i >= 0; i--) {
            //each array message will be come and store the message
            Message allMessage = messages[i]
            for (int j = unreadmessages.length - 1; j >= 0; j--) {
                //this unread message will come every time to check messages are unread or read
                Message unMessage = unreadmessages[j]
                //it check for messages are unread ? . and avoid duplicates so we are using compare date

                if (allMessage.getSentDate().compareTo(unMessage.getSentDate()) == 0 && flag !=true) {
                    //it is used for unread messages it check for message length it 18 are above . and check the mail have attachment are not
                    if(allMessage.getContent().toString().length() > 18 && allMessage.getContent().toString().substring(0,19)=="javax.mail.internet")
                    {
                        MimeMultipart content = (MimeMultipart) allMessage.getContent()
                        def con=[read:"unread",to:allMessage.getRecipients(Message.RecipientType.TO),cc:allMessage.getRecipients(Message.RecipientType.CC),form:allMessage.getFrom()[0],Subject:allMessage.getSubject(),Date: allMessage.getSentDate(),Message:content.getBodyPart(0).getContent(),messageObject:i]
                        inboxMail.add(con)
                        flag = true
                    }
                    // this used for unreadmessages without attachment
                    else{
                        def con=[read:"unread",cc:allMessage.getRecipients(Message.RecipientType.CC),to:allMessage.getRecipients(Message.RecipientType.TO),form:allMessage.getFrom()[0],Subject:allMessage.getSubject(),Date: allMessage.getSentDate(),Message:allMessage.getContent(),messageObject:i]
                        inboxMail.add(con)
                        flag = true
                    }
                }
            }
            //this method will used as read message add to map
            if (flag == false) {
                if(allMessage.getContent().toString().length() > 18 && allMessage.getContent().toString().substring(0,19)=="javax.mail.internet")
                {
                    MimeMultipart content = (MimeMultipart) allMessage.getContent()
                    def con=[read:"read",cc:allMessage.getRecipients(Message.RecipientType.CC),to:allMessage.getRecipients(Message.RecipientType.TO),form:allMessage.getFrom()[0],Subject:allMessage.getSubject(),Date: allMessage.getSentDate(),Message:content.getBodyPart(0).getContent().toString().replaceAll("\n","<\br><b>")+"sssss",messageObject:i]
                    inboxMail.add(con)
                }
                else
                {
                    def con=[read:"read",to:allMessage.getRecipients(Message.RecipientType.TO),cc:allMessage.getRecipients(Message.RecipientType.CC),form:allMessage.getFrom()[0],Subject:allMessage.getSubject(),Date: allMessage.getSentDate(),Message:allMessage.getContent().toString().replaceAll("\n","<br>"),messageObject:i]
                    inboxMail.add(con)
                }
            }
            flag = false
        }
        [inboxMail:inboxMail,folder:VyoogMailService.clientFolder(session?.mailUser?.store)]
    }

    def sendMail(){
        String fromAddress = session?.mailUser?.emailAddress.toString()
        boolean status = true
        if(fromAddress=="null")
        {
            status = false
            def userInstance = UserAccount?.findByUserName(session.userName)
            def employmentInstance = Employment?.findByUserName(userInstance)
            fromAddress = employmentInstance?.organizationalEmailID.toString()
            if(fromAddress=="null")
            fromAddress="admin"
        }

        String password = session?.mailUser?.password.toString()
        def toMailAddress,ccMailAddress,bccMailAddress
        //  this action used for send the mail to destination address
        sendMail {
            if(params.attachment)
            {
                multipart true
                attachBytes "invoice.html", "text/html",new File('/home/vyoog/Desktop/invoice.html').readBytes()
            }
            if(params.emailAddress)
            {
                toMailAddress = params.emailAddress.split(',')
                to toMailAddress
            }
            if(params.cc)
            {
                ccMailAddress = params.cc.split(',')
                cc ccMailAddress
            }
            if(params.bcc)
            {
                bccMailAddress = params.bcc.split(',')
                bcc bccMailAddress
            }
            from fromAddress
            subject params.subject
            body params.message
        }

        if(status){
            Properties props = System.getProperties()
            props.setProperty("mail.store.protocol", "imaps")
            props.setProperty("mail.imaps.ssl.trust", "mail.myvyoog.com")
            Session session = Session.getDefaultInstance(props, null)
            Store store = session.getStore("imaps")
            store.connect("mail.myvyoog.com", fromAddress, password)
            Folder sentFolder = store.getFolder("sent")
            sentFolder.open(Folder.READ_WRITE)
            Message message = new MimeMessage(session)
            message.setFrom(new InternetAddress(fromAddress))
            toMailAddress.each{
                message.addRecipient(Message.RecipientType.TO, new InternetAddress(it))
            }
            ccMailAddress.each{
                message.addRecipient(Message.RecipientType.CC, new InternetAddress(it))
            }
            bccMailAddress.each{
                message.addRecipient(Message.RecipientType.BCC, new InternetAddress(it))
            }
            message.setSubject(params.subject)
            message.setSentDate(new Date())
            message.setText(params.message)
            message.setFlag(Flags.Flag.SEEN, true)
            sentFolder.appendMessages(message)
        }
        render "mail send successfully"
    }

    def readUpdate(){
        Folder folderread = session?.mailUser?.store?.getFolder(params.folderName)
        folderread.open(Folder.READ_WRITE)
        if(folderread.getMessageCount() >=(params.int('messageId')+1))
        {
            folderread.getMessage(params.int('messageId')+1).setFlag(Flags.Flag.SEEN, true)
        }
        render "Success"
    }

    def deleteMail(){

        Folder folder = session?.mailUser?.store?.getFolder(params.folderName)
        folder.open(Folder.READ_WRITE)

        if(params.folderName!="Trash")
        {
            Folder sentFolder = session?.mailUser?.store?.getFolder("Trash")
            sentFolder.open(Folder.READ_WRITE)
            sentFolder.getMessageCount()
            sentFolder.appendMessages(folder.getMessage(params.int('messageId')+1))
            sentFolder.close(true)
        }
        folder.getMessage(params.int('messageId')+1).setFlag(Flags.Flag.DELETED, true)
        folder.close(true)

        render "Success"
    }

    def test(){}

    def loadMailView2(){
        def userInstance = UserAccount?.findByUserName(session.userName)
        def employmentInstance = Employment?.findByUserName(userInstance)
        def role = employmentInstance?.designationBasedEmployeeRoles?.roles
        def display=[]
        def moreActions=[]

        role.each{
            display << ActionList.findAllByDesignationAndRole(employmentInstance?.designation,it)
        }
        display.each{
            if(it.moduleList.toString() != employmentInstance?.department.toString()) {
                moreActions << it.actionListLine?.screenName?.screenPath
            }
        }

        session.userName=session?.mailUser?.employment.toString()
        session.u = UserAccount.findByUserName(session?.mailUser?.employment.toString())
        session.userId = session.u.id
        [inboxMail:VyoogMailService.loadClientMailView1(params.clientFolderName,session?.mailUser?.store),folderName:params.clientFolderName,moreActions:moreActions,folder:VyoogMailService.clientFolder(session?.mailUser?.store)]
    }

    def loadMailView3(){
        [inboxMail:VyoogMailService.loadClientMailView1(params.clientFolderName,session?.mailUser?.store),folderName:params.clientFolderName,folder:VyoogMailService.clientFolder(session?.mailUser?.store)]
    }

    def erpViewOpen(){}

    def downloadInvoice(){
        def fileURL = "http://localhost:8090/VyoogErp3/salesInvoice/invoicePreview/1"
        def thisUrl = new URL(fileURL)
        def connection = thisUrl.openConnection()
        def dataStream = connection.inputStream
        new File("/home/vyoog/Desktop/invoice.html").write(new URL(fileURL).openConnection().inputStream.text.toString())
        response.setContentType("application/octet-stream")
        response.setHeader('Content-disposition', 'Attachment; filename=Invoice.html')
        response.outputStream << dataStream
        response.outputStream.flush()
    }

    def mailMove(){
        boolean folderPersent = false
        Folder[] allFolder = session?.mailUser?.store.getFolder("client").list("*")
        Folder fromMailFolder = session?.mailUser?.store.getFolder(params.fromFolder)
        fromMailFolder.open(Folder.READ_WRITE)
        allFolder.each{
            if(it.toString() == params.folderName) {
                folderPersent = true
            }
        }
        if(!folderPersent){
            Folder newSubFolder = session?.mailUser?.store.getFolder(params.folderName)
            newSubFolder.create(Folder.HOLDS_MESSAGES)
        }
        Folder moveFolder = session?.mailUser?.store.getFolder(params.folderName)
        moveFolder.open(Folder.READ_WRITE)
        moveFolder.appendMessages(fromMailFolder.getMessage(params.int('messageId')+1))
        moveFolder.close(true)
        fromMailFolder.getMessage(params.int('messageId')+1).setFlag(Flags.Flag.DELETED, true)
        fromMailFolder.close(true)
        render params.fromFolder
    }
}
