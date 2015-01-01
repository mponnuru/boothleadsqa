@RestResource(urlMapping='/AWS_SNS_RecieveNotification')
global class AWS_SNS_RecieveNotification {

    global AWS_SNS_RecieveNotification(){
        system.debug('debug for asw sns');
    }

@HttpPost
global static void doPost() {
    
     String allowedTopic = 'arn:aws:sns:us-west-2:575259256142:Delivery_Satistic';
     String sourceDomain = 'sns.us-west-2.amazonaws.com';
     
     system.debug('debug for asw sns');
    
     Http http = new Http();
    
     RestRequest req = RestContext.request;
     RestResponse res = RestContext.response;
     Blob reqbody = req.requestBody;
    
     system.debug('debug for asw sns'+reqbody+allowedTopic  );
    
    /*RestContext.response.addHeader('Content-Type', 'text/plain');
    //String name = RestContext.request.params.get('name');
    
    
    RestContext.response.addHeader('client_id','3MVG9GiqKapCZBwHzyHJ_RnuesB4SLhNhSBC2Z6JIKEf1j1sSRhMHoxf6h0U4nxZqJafm89IR74G3PQCDzrZy');
    RestContext.response.addHeader('client_secret','835319979606089662');
    RestContext.response.addHeader('username','sfadmin@globalnest.com');
    RestContext.response.addHeader('password','Administrator@123yYsXgJo6B7mrL6GvURrhlMFQ');*/
    
  }
}