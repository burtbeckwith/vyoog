package vyoogmail

import javax.mail.Flags
import javax.mail.Folder
import javax.mail.Message
import javax.mail.Session
import javax.mail.Store
import javax.mail.internet.MimeMultipart
import javax.mail.search.FlagTerm

class VyoogMailService {

    static transactional = false

    def userLogin(String emailAddress,String password){
        //user login for mail server it return the store values
        Properties props = System.getProperties()
        props.setProperty("mail.store.protocol", "imaps")
        props.setProperty("mail.imaps.ssl.trust", "mail.myvyoog.com")
        Session session = Session.getDefaultInstance(props, null)
        Store store = session.getStore("imaps")
        try{
            store.connect("mail.myvyoog.com", emailAddress, password)
        }
        catch(e){
            return "Fail"
        }
        return store
    }

    def loadClientMailView1(String folderName,Store storeValue){
        def inboxMail=[]
        def inboxMessageKeywords=[SalesMarketing:["Enquiry","Invoice","Order","Invoise"],Market:["te1111","teeeee"]]
        def EnquiryList=[BusinessPartner,"businessPartnerNameField","businessPartnerCodeField"]
        String passValues = ""
        String dynamicButton=""
        String linkSend = ""
        boolean flag = false
        // user login call in Service Method and get the inbox folder
        Folder emailFolder = storeValue.getFolder(folderName)
        // email folder set the read or write
        emailFolder.open(Folder.READ_ONLY)
        // set the array for all messages.this method load all inbox mails
        Message[] messages = emailFolder.getMessages()
        // set the array for unreadmessages.this method load only user unread messages
        Message[] unreadmessages = emailFolder.search(new FlagTerm(new Flags(Flags.Flag.SEEN), false))
        for (int i = messages.length - 1; i >= 0; i--) {
            //each array message will be come and store the message
            Message allMessage = messages[i]

            inboxMessageKeywords.each{par->
                par.getValue().each{
                    if(allMessage.getContent().toString().toLowerCase().indexOf(it.toString().toLowerCase())!=-1)
                    {
                        dynamicButton =it.toString()
                    }
                }
            }
            if(dynamicButton == "Enquiry")
            {
                def customDomainvalues = BusinessPartner.list()
                String temp = allMessage.getContent().toString().toLowerCase()
                customDomainvalues.each{

                    if((temp.indexOf(it.toString().toLowerCase()))!= -1)
                    {
                        passValues = "value=customerName:"+it.id.toString()+",businessPartnerNameField:"+it.toString().replaceAll(" ","_")+",businessPartnerCodeField:"+it.businessPartnerCodeField.toString().replaceAll(" ","_")
                        linkSend = "<a class='btn btn-info btn-sm' onclick=newWindow('"+dynamicButton+"','"+passValues+"')>"+dynamicButton+"</a>"
                    }
                }
            }
            else if(dynamicButton == "Invoice")
            {
                def customDomainvalues = BusinessPartner.list()
                String temp = allMessage.getContent().toString().toLowerCase()
                customDomainvalues.each{

                    if((temp.indexOf(it.toString().toLowerCase()))!= -1)
                    {
                        passValues = "value=customerName:"+it.id.toString()+",businessPartnerNameField:"+it.toString().replaceAll(" ","_")+",businessPartnerCodeField:"+it.businessPartnerCodeField.toString().replaceAll(" ","_")
                        linkSend = "<a class='btn btn-info btn-sm' onclick=newMailBoxOpenAttachment('${allMessage.getFrom()[0]}','Invoice.html','Invoice_Of_${it.toString().replaceAll(" ","_")}') href='downloadInvoice/${it.id}'>send Invoice</a> "
                    }
                }
            }

            for (int j = unreadmessages.length - 1; j >= 0; j--) {
                //this unread message will come every time to check messages are unread or read
                Message unMessage = unreadmessages[j]
                //it check for messages are unread ? . and avoid duplicates so we are using compare date

                if (allMessage.getSentDate().compareTo(unMessage.getSentDate()) == 0 && flag !=true) {
                    //it is used for unread messages it check for message length it 18 are above . and check the mail have attachment are not
                    if(allMessage.getContent().toString().length() > 18 && allMessage.getContent().toString().substring(0,19)=="javax.mail.internet")
                    {
                        MimeMultipart content = (MimeMultipart) allMessage.getContent()

                        def con=[read:"read",bcc:allMessage.getRecipients(Message.RecipientType.BCC),cc:allMessage.getRecipients(Message.RecipientType.CC),form:allMessage.getFrom()[0],to:allMessage.getAllRecipients()[0],Subject:allMessage.getSubject(),Date: allMessage.getSentDate(),Message:content.getBodyPart(0).getContent().toString().replaceAll("\n","<br>"),messageObject:i,dynamicButton:linkSend]
                        inboxMail.add(con)
                        flag = true
                    }
                    // this used for unreadmessages without attachment
                    else{
                        def con=[read:"read",bcc:allMessage.getRecipients(Message.RecipientType.BCC),cc:allMessage.getRecipients(Message.RecipientType.CC),form:allMessage.getFrom()[0],to:allMessage.getAllRecipients()[0],Subject:allMessage.getSubject(),Date: allMessage.getSentDate(),Message:allMessage.getContent().toString().replaceAll("\n","<br>"),messageObject:i,dynamicButton:linkSend]
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
                    def con=[read:"read",bcc:allMessage.getRecipients(Message.RecipientType.BCC),cc:allMessage.getRecipients(Message.RecipientType.CC),form:allMessage.getFrom()[0],to:allMessage.getAllRecipients()[0],Subject:allMessage.getSubject(),Date: allMessage.getSentDate(),Message:content.getBodyPart(0).getContent().toString().replaceAll("\n","<br>"),messageObject:i,dynamicButton:linkSend]
                    inboxMail.add(con)
                }
                else
                {
                    def con=[read:"read",bcc:allMessage.getRecipients(Message.RecipientType.BCC),cc:allMessage.getRecipients(Message.RecipientType.CC),form:allMessage.getFrom()[0],to:allMessage.getAllRecipients()[0],Subject:allMessage.getSubject(),Date: allMessage.getSentDate(),Message:allMessage.getContent().toString().replaceAll("\n","<br>"),messageObject:i,dynamicButton:linkSend]
                    inboxMail.add(con)
                }
            }
            flag = false
        }
        return inboxMail
    }

    def clientFolder(Store store){
        def folderList= []
        Folder[] f = store.getFolder("client").list()
        Folder cilentFolder
        for (Folder fd : f) {
            cilentFolder = store.getFolder(fd.toString())
            cilentFolder.open(Folder.READ_ONLY)
            def mailFolderMap = [folderName:fd.toString().substring(7,fd.toString().length()),totalMail:cilentFolder.getMessages().length,unreadCount:cilentFolder.search(new FlagTerm(new Flags(Flags.Flag.SEEN), false)).length ]
            folderList << mailFolderMap
            cilentFolder.close(true)
        }
        return folderList
    }
}
