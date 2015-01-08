public with sharing class BLN_Role_DAO {
    
     
    
      //BY Mallik
        public Role__c userRole(String roles){
            
              Role__c role = [SELECT ID, NAME FROM Role__c WHERE Role_ShortName__c =: roles limit 1];
            
            return role;
        }

      public static string checkPersonalAccount(string uEmail){
            LIST<UC_Role__c> UCRoleList = [SELECT id,Company__c,Company__r.id FROM UC_Role__c WHERE GN_User__r.Email__c =:uEmail and User_Type__c='Personal'];
            if(UCRoleList.size()>0){
                return UCRoleList[0].Company__r.id;
              }else{
                 return '';
              }
          }      
     
}