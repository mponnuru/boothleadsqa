public class scanlead {
public list<Lead_Scan__c> ls{get;set;}
public scanlead()
{
ls=new list<Lead_Scan__c>();

ls=[select name, First_Name__c,Last_Name__c,Scanee_User__r.name,Scanee_User__r.Email__c,Cell_Phone__c,City__c,Company__c,Event__c,Home_Phone__c,Prefix__c,
Scan_Time__c,Street1__c,Street2__c,Suffix__c,Work_Phone__c,Scanner_User__c,Scanee_User__r.Last_Name__c,Scanee_User__r.First_Name__c from Lead_Scan__c where  Scanee_User__r.Email__c=:UserInfo.getUserName() ];

system.debug('eeeeeeeeeeee'+ls);
}  


}