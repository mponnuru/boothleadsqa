@RestResource(urlMapping='/BLN_AS_SignUp/*')

global class AS_SignUp{

global static Container ct=new Container();
global static BLN_SignUpCon signupcon {get ; set ;}

@HttpPost  
    global static Container doPost(){  
        signupcon = new BLN_SignUpCon ();
        RestRequest req = RestContext.request;
        String FirstName = req.params.get('FirstName');
        String LastName = req.params.get('LastName');
        String Password=req.params.get('Password');
        String Email=req.params.get('Email');
        String Company=req.params.get('Company');
        
        //sending Parameters to signup global class written by phani
        signupcon.ASFirstName = FirstName;
        signupcon.ASLastName  = LastName;
        signupcon.ASUserEmail = Email;
        signupcon.password    = Password;
        signupcon.ASCompanyName = Company;
        signupcon.BLS_SignUpUser();
        
        
        
         return ct;
        }
       global class Container{
    
        
        public String FirstName {get;set;}
        public String LastName {get;set;}
        public String Password{get;set;}
        public String Email{get;set;}
        
        public Container(){
        
        }
        
        }
}