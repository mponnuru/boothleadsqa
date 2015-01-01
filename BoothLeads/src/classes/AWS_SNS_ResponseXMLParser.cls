public with sharing class AWS_SNS_ResponseXMLParser{
       
    public AWS_SNS_ResponseXMLParser(){
        
    }
    
    
    public String parsXML(String xml){        
        String MessageId;
        
        Dom.Document doc = new Dom.Document();
        doc.load(xml);
        
        Dom.XMLNode Envelope = doc.getRootElement();
        System.debug('11111111111111111111111111111     ' +  Envelope );    
        //system.debug('ml444444444444444444'+doc.getRootElement());
        
         //dom.XmlNode location = doc.getRootElement().getChildElement('SendEmailResult',null);
          //location.getChildElement('MessageId', null).getText();
        
        for(Dom.XMLNode child : Envelope.getChildElements()){
            System.debug('2222222222222222222222' +  child.getChildElements().size()   +' 00000000000000000 '+ child.getChildElements());
            for(Dom.XMLNode subchild : child.getChildElements()) {
               System.debug('3333333333333333333333333333     ' + subchild.getText());
               if(subchild.getName()=='MessageId'){
                 MessageId = subchild.getText();
                 system.debug('MessageId 55555555555555  '+MessageId );
               }
            }             
        }
        return MessageId;
    }
}