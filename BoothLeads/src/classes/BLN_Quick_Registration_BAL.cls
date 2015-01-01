/**************************************************
* @author :Arindam Sarkar
* @date 05/11/2014
* @ This class is used for Quick Registration module
****************************************************/



public without sharing class BLN_Quick_Registration_BAL{
public string orderId{get;set;}

//Check user availability
public String checkUser(User newu)
{
   
   BLN_User_DAO blnuserDao = new BLN_User_DAO();
      user user = new user();
      user = blnuserDao.CheckUser(newu.email);
      return user.id!=null?user.id:null;
}

//GetExistingUSerInformation for Ajax call
public User getExistingUser(String email){
    BLN_User_DAO blnuserDao = new BLN_User_DAO();
    user user = new user();
    user = blnuserDao.CheckUser(email);
    return user;
}


//Check Company Availability
public String checkCompany(Company__c newcomp){
    BLN_Company_DAO blncmpDao = new BLN_Company_DAO();
    Company__c comp = new Company__c ();
    comp = blncmpDao.checkCompany(newcomp.name);
    return comp.id!=null?comp.id:null;
}

//Check User Email
public String checkUserEmail(String Email){
    BLN_User_DAO blnuserDao = new BLN_User_DAO();
    user user = new user();
    user = blnuserDao.CheckUser(Email);
    return user.id!=null?user.id:null;
}


// Inserting GN User
public BLN_StatusMessage insertGNUser(GN_User__c NewUser){

    BLN_User_DAO UserDAO = new BLN_User_DAO();
    
    User SFUser = new User();
    
    String UserEmail;
    if(checkUserEmail(NewUser.Email__c) != NULL){
        UserEmail = checkUserEmail(NewUser.Email__c);
    }
    else{
        SFUser.FirstName = NewUser.First_Name__c;
        SFUser.LastName = NewUser.Last_Name__c;
        SFUser.Email = NewUser.Email__c;
        SFUser.Title= NewUser.Title__c;
        SFUser.Phone= NewUser.Phone__c;
        if(newUser.Company_Name__c != NULL && newUser.Company_Name__c !=''){
            SFUser.Companyname= NewUser.Company_name__c;
        }else{
            SFUser.Companyname= NewUser.First_Name__c + NewUser.Last_Name__c;
        }
        
        BLN_StatusMessage userMsg = insertUser(SFUser);
        if(userMsg.successBool){
            UserEmail = userMsg.successId;
        }
    }
    NewUser.User__c = UserEmail;
    
    BLN_StatusMessage StatusMessage = UserDAO.insertGNUser(NewUser);
    return StatusMessage;
}


//Inserting User
public BLN_StatusMessage insertUser(user newu){
    BLN_User_DAO blnuserDao = new BLN_User_DAO();
    
    //Insert Contact
    contact Con = new Contact();
    Con.Lastname = newu.Lastname ;
    Con.Firstname =newu.Firstname ; 
    con.email = newu.email;
    
    string contactId = blnuserDao.account_Contact(con);
    //Get Profile
    Profile P = [SELECT Id,Name FROM Profile WHERE Name = 'Event Admin'];
    user u = new user();
    U.ContactID =contactId;    
    U.Username = newu.email;  
    U.Email = newu.email;
    U.LastName = newu.LastName;
    U.FirstName = newu.FirstName;
    U.CompanyName = newu.CompanyName;
    U.phone= newu.phone;
    U.title= newu.title;
    U.Alias = 'EAdmin';
    U.ProfileID = P.id;
    U.Eff_Date__c=system.today();
    U.LocaleSidKey = 'en_US';
    U.LanguageLocaleKey = 'en_US';
    U.TimeZoneSidKey = 'America/Los_Angeles';
    U.EmailEncodingKey='UTF-8';
    U.CommunityNickname = String.valueOf(math.random());
    BLN_StatusMessage userMsg = blnuserDAO.createUser(u);

    return userMsg ;
}

//Updating User
public String updateUser(User U){
    BLN_User_DAO blnuserDao = new BLN_User_DAO();
    String userMsg = blnuserDAO.updateUser(u);
    return userMsg;
}

//Inserting Company
public BLN_StatusMessage insertCompany(Company__c newcomp,Company_Ext__c comext)
{
    BLN_Company_DAO blnCompanyDAO = new BLN_Company_DAO();
    BLN_StatusMessage companyMsg = blnCompanyDAO.insertCompany(newcomp);
    if(companyMsg.successBool)
    if(comext != null){
        blnCompanyDAO.insertcompdetails(companyMsg.successId,comext);
    }
    return companyMsg;    
}

//Inserting UCRole
public BLN_StatusMessage insertUCRole(String userId,String comId,String eventId,String role){
        BLN_UCRole_DAO companyRole = new BLN_UCRole_DAO();    
        system.debug('UserID in BAL:'+userId+' CompanyID in BAL:'+comId);
        UC_Role__c uRole = new UC_Role__c();
        uRole.Company__c = comId; 
        uRole.GN_User__c =userId;
        uRole.Event__c=eventId;
        
        BLN_User_DAO UserDAO = new BLN_User_DAO();
        GN_User__c GU = UserDAO.getGNUser(UserId);
        uRole.User__c = GU.User__c;
        
        BLN_StatusMessage ucRoleMsg = companyRole.insertUCRole(uRole, role);
        system.debug('Inserted UC Role Id in BAL:'+ucRoleMsg);
        return ucRoleMsg;           
}


//Inserting UCRole
public BLN_StatusMessage insertUCRolewithUtype(String userId,String comId,String eventId,String role,string utype){
        BLN_UCRole_DAO companyRole = new BLN_UCRole_DAO();    
        system.debug('UserID in BAL:'+userId+' CompanyID in BAL:'+comId);
        UC_Role__c uRole = new UC_Role__c();
        uRole.Company__c = comId; 
        uRole.GN_User__c =userId;
        uRole.Event__c=eventId;
        uRole.user_type__c =utype;
        
        BLN_User_DAO UserDAO = new BLN_User_DAO();
        GN_User__c GU = UserDAO.getGNUser(UserId);
        uRole.User__c = GU.User__c;
        
        BLN_StatusMessage ucRoleMsg = companyRole.insertUCRole(uRole, role);
        system.debug('Inserted UC Role Id in BAL:'+ucRoleMsg);
        return ucRoleMsg;           
}






    //Get Available Tickets 
    public LIST<selectOption> getAvailableTickets(LIST<BLN_Item__c> items){
    System.debug('ITEMSSSS '+items);
        BLN_Ticket_DAO tcdao=new BLN_Ticket_DAO();
        LIST<selectOption> myitems = new LIST<selectOption>();
        myitems.add(new selectOption('','Select One'));
        LIST<Ticket__c> tckt;
        for(BLN_Item__c item:items){
        
            
            tckt = tcdao.getTickets('id,name,Event__c,Item__r.Payment__c,Item__r.Event__c,Item__r.price__c,Item__r.item_name__c,Item_Type__r.name,item__r.Ticket_Settings__c,Ticket_Status__c,Parent_ID__c,Item_Pool__r.Badgable__c','Event__c=\''+item.Event__c +'\' and Item__r.id=\''+item.id+'\' and Ticket_Status__c=\'Available\' and Parent_ID__c=null order by name limit 1');
            if(tckt.size()>0){
                myitems.add(new selectOption(tckt[0].id,item.item_name__c));
            } 
        }
        return myitems;
    }
    
    //Get Event Details based on Id
    public BLN_Event__c geteventDetails(string eventId){
        BLN_Event_DAO evdao=new BLN_Event_DAO();
        LIST<BLN_Event__c> eventdetails=evdao.getEventDetails(eventId);
        if(eventdetails.size()>0)
            return eventdetails[0];
        else
            return new BLN_Event__c();
    }

    //Get Items For an Event
    public LIST<BLN_Item__c> getEventItems(String eventId){
        BLN_Item_DAO itmdao=new BLN_Item_DAO();
        LIST<BLN_Item__c> items=itmdao.getEventItems(eventId);
        if(items.size()>0)
            return items;
        else
            return new LIST<BLN_Item__c>();
    }
    
    
   
// ------------------------------------------------------ Edit for Regular Registration start by Mahesh Sakunala ----------------------------------------------------------------
   
        
    //Get Registration Template Details For an Event
    public Registration_Template__c getRegTempDetails(String RegTemplateId){
        BLN_RegTemplate_DAO regTempDAO = new BLN_RegTemplate_DAO();
        Registration_Template__c registrationTemplate = regTempDAO.getRegTempDetails(RegTemplateId);
        return registrationTemplate;
    }
    
    //Get Ticket Details
    public LIST<Ticket__c> getTicketDetail(BLN_Item__c Item, Integer RecordCount){
        // Getting Ticket Details from Ticket DAO
        BLN_Ticket_DAO TicketDAO = new BLN_Ticket_DAO();
        LIST<Ticket__c> TicketList = new LIST<Ticket__c>();
        LIST<Ticket__c> PackageTickets = new LIST<Ticket__c>();
        
        //Getting Package Tickets from Ticket DAO
        if(Item.Item_Type__r.Name == 'Package' && Item.Ticket_Settings__c == 'Collect info from All Attendees'){
           List<Ticket__c> tckt = TicketDAO.getTickets('id,name,Event__c,Item__r.item_name__c,Item_Pool__r.Item_Pool_Name__c,item__r.Ticket_Settings__c,Item_Pool__r.Ticket_Settings__c,Item_Type__r.name,Ticket_Status__c,Parent_ID__c,Item_Pool__r.Package_Flag__c,Item_Pool__r.Badgable__c','Event__c=\''+item.Event__c +'\' AND Item__r.item_name__c=\''+item.item_name__c+'\' AND Ticket_Status__c=\'Available\' AND Parent_ID__c=null AND Item_Pool__r.Badgable__c=\'N - No Badge\' ORDER BY Name LIMIT '+ RecordCount);     
           //AND Parent_ID__c=null 
           system.debug('Package Single Ticket: '+tckt);
         for(Ticket__c tc : tckt){  
           if(tc.Item_Pool__r.Package_Flag__c == 'P - Package item pool'){
               PackageTickets.addAll(TicketDAO.getTickets('id,name,Event__c,Item__r.item_type__r.Name,Item_Pool__r.Item_Pool_Name__c,Item__r.item_name__c,Item_Pool__r.Ticket_Settings__c,Client_GN_User__c,Client_Company__c,Order__c,Order_Item__c,item__r.Ticket_Settings__c,Item_Type__r.name,Parent_ID__c,Item_Pool__r.Package_Flag__c,Item_Pool__r.Badgable__c,Ticket_Status__c','Ticket_Status__c=\'Available\' and  Parent_ID__c=\''+tc.id+'\'')); 
               system.debug('Package Tickets: '+PackageTickets);
           }
         } 
        }
        else{
          if(Item.Item_Type__r.Name == 'Package'){
            TicketList = TicketDAO.getTickets('id,Item__r.item_type__r.Name,name,Event__c,Item__r.item_name__c,Item_Pool__r.Item_Pool_Name__c,item__r.Ticket_Settings__c,Item_Pool__r.Ticket_Settings__c,Item_Type__r.name,Ticket_Status__c,Item_Pool__r.Package_Flag__c,Parent_ID__c,Item_Pool__r.Badgable__c','Event__c=\''+item.Event__c +'\' AND Item__r.item_name__c=\''+item.item_name__c+'\' AND Ticket_Status__c=\'Available\' AND Parent_ID__c=null AND Item_Pool__r.Badgable__c=\'N - No Badge\' ORDER BY Name LIMIT '+ RecordCount);     
           }else{
            TicketList = TicketDAO.getTickets('id,name,Item__r.item_type__r.Name,Event__c,Item__r.item_name__c,Item_Pool__r.Item_Pool_Name__c,item__r.Ticket_Settings__c,Item_Pool__r.Ticket_Settings__c,Item_Type__r.name,Ticket_Status__c,Item_Pool__r.Package_Flag__c,Parent_ID__c,Item_Pool__r.Badgable__c','Event__c=\''+item.Event__c +'\' AND Item__r.item_name__c=\''+item.item_name__c+'\' AND Ticket_Status__c=\'Available\' AND Parent_ID__c=null AND Item_Pool__r.Badgable__c=\'B - Badge\' ORDER BY Name LIMIT '+ RecordCount);     
          
           }
        }
        TicketList.addAll(PackageTickets);
        return TicketList;
    }
    
    // Get Event Payment Gateways
    public LIST<Event_Pay_Gateway__c> getEventPayGateWays(String EventId){
        // Get Event Payment Gateways from Event PayGateway DAO 
        BLN_EventPayGateway_DAO EventPayGatewayDAO = new BLN_EventPayGateway_DAO();
        LIST<Event_Pay_Gateway__c> EventPayGateWays = EventPayGatewayDAO.getEventPayGateWays(EventId);
        
        return EventPayGateWays;
    }
    
    public List<Ticket__c> ticketsForupdatePkg{get;set;}
    // Update Ticket Details 
    public BLN_StatusMessage updateTickets(LIST<String> UserIds,LIST<String> CompanyIds,LIST<String> TicketIds,String EventId,String OrderUserId, Decimal SubTotal, Decimal DiscountAmount, Decimal FeeAmount,Decimal TaxAmount, Decimal AmountPaid, MAP<Id,Id> PromotionIdMap,Integer PromotionCount,String PromoCode, String PayAddress, String ChargeType, String PGatewayType,String ChargeId, String PGatewayMode){
        ticketsForupdatePkg = new List<Ticket__c>();
        BLN_StatusMessage TicketUpdateMessage;
        
        
        
        //Buying Tickets
        BLN_Ticket_DAO TicketDAO = new BLN_Ticket_DAO();
        
        //Get Currency
        BLN_Currency_DAO CurDAO =new BLN_Currency_DAO();
        Currency__c cur = CurDAO.getCurrencyDetails('id,name','name=\'USD\' LIMIT 1');
        
        //Get PGateway Type
        BLN_PGateway_Type_DAO PGatewayDAO = new BLN_PGateway_Type_DAO();
        if(PGatewayMode == 'Stripe'){
            PGatewayType = 'Stripe';
        }else if(PGatewayMode == 'Authorize .Net'){
            PGatewayType = 'Authorize.Net';
        }else{
           /*if(SubTotal<=0){
             PGatewayType = 'Free';
           }else{*/
              PGatewayType = PGatewayType;
           //}
        }
         
         PGateway_Type__c PGateway = new PGateway_Type__c();
        
         try{
            PGateway = PGatewayDAO.getGatewayType(PGatewayType);
          }catch(exception er){}
        //Get User Details
        BLN_User_DAO UserDAO = new BLN_User_DAO();
        GN_User__c UserDetails = UserDAO.getGNUser(OrderUserId);
        
        //Insert Order
        BLN_Order_DAO OrderDAO =new BLN_Order_DAO();
        Order__c   Order = new Order__c();
        if(CompanyIds.size()>0){
            Order = new Order__c(Events__c=eventId,Amount_Paid__c=AmountPaid,Client_GN_User__c=OrderUserId,Client_Company__c=CompanyIds[0],Order_Total__c=AmountPaid,Order_Sub_Total__c=SubTotal,Order_Discount__c=DiscountAmount,Order_Status__c='Fully Paid',Currency_Code__c=cur.id,Fee_Amount__c=FeeAmount,Order_Taxes__c=TaxAmount,Transaction_Status__c='Completed');
       }else{
           Order = new Order__c(Events__c=eventId,Amount_Paid__c=AmountPaid,Client_GN_User__c=OrderUserId,Order_Total__c=AmountPaid,Order_Sub_Total__c=SubTotal,Order_Discount__c=DiscountAmount,Order_Status__c='Fully Paid',Currency_Code__c=cur.id,Fee_Amount__c=FeeAmount,Order_Taxes__c=TaxAmount,Transaction_Status__c='Completed');
      
       }
       
        BLN_StatusMessage OrderMessage  =OrderDAO.insertorder(Order);
        try{
             orderId =OrderMessage.successId;
            }catch(exception er){}
        
        
        
        //Insert Payment
        BLN_payment_DAO PaymentDAO = new BLN_payment_DAO();
        Payment__c Payment = new Payment__c(Payment_Amount__c=AmountPaid,Order__c=OrderMessage.successId,Currency_Code__c=cur.id,Payment_Mode__c=ChargeType,PGateway_Type__c=PGateway.id,Pay_Address__c=PayAddress,Payment_Ref_Number__c=ChargeId);
        BLN_StatusMessage PaymentMessage = PaymentDAO.insertPayment(Payment);
        
        //Update Promotion
        BLN_PromoCode_BAL PromotionBAL = new BLN_PromoCode_BAL();
        BLN_Promotion_DAO PromotionDAO = new BLN_Promotion_DAO();
        
        LIST<Promotion__c> promotionlist  = new LIST<Promotion__c>();
        system.debug('Promo Code: '+PromoCode);
        if(PromoCode !=''){
            promotionlist = PromotionBAL.getPromotionDetails(eventId,PromoCode);
            if(promotionlist.size()>0){
                for(Promotion__c p:promotionlist){
                    p.T_Used_Count__c += PromotionCount;
                }
                PromotionDAO.UpsertPromotion(promotionlist);
            }
        }
        
        MAP<ID, ID> findDuplicateItems = new MAP<ID, ID>(); // Map to find out duplicate order items
       
         system.debug('TTTTTTTTTTTTTTtt  '+TicketIds.size());
      
        // Looping through Users, Companies and Tickets  
        for(integer i=0; i< TicketIds.size();i++){
            system.debug('AAAAAAAAAAAAAAAAAAA '+TicketIds[i]);
            //Getting Ticket Details to update
            LIST<Ticket__c> TicketsList = [select Parent_ID__c,id,name,First_Name__c,Last_Name__c,Email__c,Company__c,Client_GN_User__c,item__r.Id,item__r.Ticket_Settings__c,Client_Company__c,Order__c,Order_Item__c,Item_Pool__r.Package_Flag__c,Item__c,Item__r.price__c,Event__c,Item_Type__r.name,Ticket_Status__c from Ticket__c where id=:TicketIds[i] ];
            //TicketDAO.getTickets('Parent_ID__c,id,name,First_Name__c,Last_Name__c,Email__c,Company__c,Client_GN_User__c,item__r.Id,item__r.Ticket_Settings__c,Client_Company__c,Order__c,Order_Item__c,Item_Pool__r.Package_Flag__c,Item__c,Item__r.price__c,Event__c,Item_Type__r.name,Ticket_Status__c','id=\''+TicketIds[i]+'\' LIMIT 1');
            system.debug('AAAAAAAAAAAAAAAAAAA '+TicketsList);
            
            //Insert & Update Order Item
            BLN_StatusMessage OrderItemMessage;
            Id OrderItemId; 
            Order_Item__c insertedOrderItem = new Order_Item__c();
            
            BLN_OrderItem_DAO OrderItemDAO = new BLN_OrderItem_DAO();
            if(!findDuplicateItems.containsKey(TicketsList[0].item__r.Id)){
                findDuplicateItems.put(TicketsList[0].item__r.Id,TicketsList[0].item__r.Id);
                Order_Item__c OrderItem = new Order_Item__c(Currency__c=Cur.id,Item_Quantity__c=1,Item_Total__c=TicketsList[0].Item__r.price__c,Item__c = TicketsList[0].item__c,Item_Discount__c=DiscountAmount,Order__c=OrderMessage.successId,Promotion__c=PromotionIdMap.get(TicketsList[0].item__r.Id));
                OrderItemMessage = OrderItemDAO.insertorder(OrderItem); 
                OrderItemId = OrderItemMessage.successId;
               
            }
            else{
              if(TicketsList[0].Parent_ID__c==null){    
                    insertedOrderItem = OrderItemDAO.getOrderItem(OrderMessage.successId,TicketsList[0].item__r.Id);
                    insertedOrderItem.Item_Quantity__c = insertedOrderItem.Item_Quantity__c+1;
                    insertedOrderItem.Item_Total__c = insertedOrderItem.Item_Total__c+insertedOrderItem.Item__r.price__c;
                    LIST<Order_Item__c> insertedOrderItems = new LIST<Order_Item__c>();
                    insertedOrderItems.add(insertedOrderItem);
                    OrderItemMessage = OrderItemDAO.updateOrder(insertedOrderItems);
                    OrderItemId = OrderItemMessage.successId;
              }
            }
            
            // Update Ticket
            if(TicketsList[0].Item_Pool__r.Package_Flag__c=='P - Package item pool'){
            
               //List<Ticket__c> PackageTicket = new List<Ticket__c>();
              
                //Get all Package Tickets
                List<Ticket__c> PackageTicket = TicketDAO.getTickets('id,name,First_Name__c,Last_Name__c,Email__c,Company__c,Client_GN_User__c,Client_Company__c,Order__c,item__r.Ticket_Settings__c,Order_Item__c,Ticket_Status__c','Parent_ID__c=\''+TicketsList[0].id+'\'');
                List<Ticket__c> PackageTicket2 = new List<Ticket__c>(TicketDAO.getTickets('id,name,First_Name__c,Last_Name__c,Email__c,Company__c,Client_GN_User__c,Client_Company__c,Order__c,item__r.Ticket_Settings__c,Order_Item__c,Ticket_Status__c','id=\''+TicketsList[0].id+'\''));
                 for(Ticket__c tc :PackageTicket2  ){
                   tc.Ticket_Status__c = 'Booked';
                 }
                
                
                for(integer j=0;j<PackageTicket.size();j++){
                   
                    ticketsForupdatePkg.add(PackageTicket[j]);
                    PackageTicket[j].Client_GN_User__c= UserIds[i];
                   
                    
                    try{
                    PackageTicket[j].Client_Company__c = CompanyIds[i];
                   
                    }catch(exception e){}
                    
                    PackageTicket[j].Order__c = OrderMessage.successId;
                    if(OrderItemId != NULL){
                        PackageTicket[j].Order_Item__c = OrderItemId;
                    }else{
                        PackageTicket[j].Order_Item__c = insertedOrderItem.Id;
                    }
                    PackageTicket[j].Ticket_Status__c = 'Booked';
              
                }  
            
                
                
                
                //Update Package Ticket
                TicketsList[0].Client_GN_User__c= UserIds[i];
                
                 try{
                    TicketsList[0].Client_Company__c = CompanyIds[i];
                   
                 }catch(exception ex){}
                TicketsList[0].Order__c = OrderMessage.successId;
                if(OrderItemId != NULL){
                    TicketsList[0].Order_Item__c = OrderItemId;
                }else{
                    TicketsList[0].Order_Item__c = insertedOrderItem.Id;
                }
                TicketsList[0].Ticket_Status__c='Booked';
                PackageTicket.add(TicketsList[0]);
                TicketUpdateMessage = TicketDAO.updateTicket(PackageTicket);
            }
            else{
                //Update Individual Ticket
                system.debug('Ticket Details are : '+TicketsList[0]);  
                TicketsList[0].Ticket_Status__c='Booked';
                try{
                TicketsList[0].Client_GN_User__c= UserIds[i];
                }catch(exception er){}
                 try{
                  TicketsList[0].Client_Company__c = CompanyIds[i];
                  
                }catch(exception ey){}
                TicketsList[0].Order__c = OrderMessage.successId;
                if(OrderItemId != NULL){
                    TicketsList[0].Order_Item__c = OrderItemId;
                }else{
                    TicketsList[0].Order_Item__c = insertedOrderItem.Id;
                }
                
                TicketUpdateMessage = TicketDAO.updateTicket(TicketsList[0]);
                system.debug('Updated Ticket Response: '+TicketUpdateMessage);  
            }
        }
        return TicketUpdateMessage;      
    }
    
   // ----------------------------------------------------- Edit for Regular Registration by Mahesh Sakunala --------------------- END ------------------------------------------------------    
    
      
    //Get Badge For Ticket
    public String getBadgeForTicket(String ticketId){
        BLN_Badge_DAO badgedao=new BLN_Badge_DAO();
        String badgeid=badgedao.getBadgeForTicket(ticketId);
        
        //For tickets having the same badge
        if(badgeid==''){
            BLN_Ticket_DAO tcktdao=new BLN_Ticket_DAO();
            List<Ticket__c> tc=tcktdao.getTickets('id,name,Badge_Label__c,Badge_ID__c','id=\''+ticketId+'\'');
            if(tc.size()!=0)
                badgeid=tc[0].Badge_ID__c;
        }
        return badgeid;
    }
   
   
    //Get all the booked tickets for showing in picklist
    public List<Ticket__c> getBookedTickets(String event){
        BLN_Ticket_DAO tcktdao=new BLN_Ticket_DAO();
        return tcktdao.getTickets('id,name,Order_Item__r.Item__r.item_name__c,Order__r.Name,Client_User__r.FirstName,item__r.Ticket_Settings__c,Client_User__r.LastName,Client_User__r.Email,Client_Company__r.name','Event__c=\''+event+'\' and Ticket_Status__c=\'Booked\' and Item_Pool__r.Badgable__c=\'N - No Badge\' order by Order__r.Name');  
    }
   

    //Get Details to fill the form for update/prnt   
    public Ticket__c getItemInfoFrmTicket(String ticketId){
        BLN_Ticket_DAO tcktdao=new BLN_Ticket_DAO();
        List<Ticket__c> tckt=tcktdao.getTickets('id,name,Badge_ID__c,Badge_ID__r.name,Badge_ID__r.badge_label__c,(select id,name,badge_label__c from badges__r where cancel_time__c=null and Exp_time__c=null),Client_Company__c,Order__c,Order__r.id,Order_Item__c,Order_Item__r.Item__r.id,Order_Item__r.Item__r.item_name__c,Client_GN_User__c,Client_GN_User__r.First_Name__c,Client_GN_User__r.Last_Name__c,Client_GN_User__r.Email__c,Client_GN_User__r.title__c,Client_GN_User__r.phone__c,Client_Company__r.name','id=\''+ticketId+'\''); 
        return tckt[0];
    } 
   
   
   //Update Existing Ticket Information
   
   public void updateExistingBadge(String oldbadgelabel,String badgelabel,String oldASTitle ,String ASTitle ,String oldASPhone ,String ASPhone,String oldASFirstName,String  ASFirstName,String oldASLastName,String ASLastName,String oldASUserEmail,String ASUserEmail,String oldASCompanyName,String ASCompanyName,String ticketitems )
     {
     String userid;
                   String companyid;
     BLN_User_DAO userdao=new BLN_User_DAO();
     BLN_Gnuser_DAO gnuserdao=new BLN_Gnuser_DAO();
     //update badge
     if(oldbadgelabel!=badgelabel)
       {       
                 String[] ticketidandclientid =ticketitems.split(';');
          String ticketid=ticketidandclientid [0];
          
          if(oldbadgelabel==null)
          generateBadge(badgelabel,ticketid);
          else
          {
                 Badge__c bg=new Badge__c();     
                String badgeid=getBadgeForTicket(ticketid);
                bg.id=badgeid;
                    bg.Badge_Label__c=badgelabel;
                    //bg.ticket_id__c=ticketid;
                    BLN_Badge_DAO bdgdao=new BLN_Badge_DAO();
                    bdgdao.updatebadge(bg);
                    }
                    
       }
     
     //update user information
       if((oldASFirstName!=ASFirstName||oldASLastName !=ASLastName||oldASTitle!=ASTitle||oldASPhone!=ASPhone)&&oldASUserEmail==ASUserEmail)
       {
         GN_User__c upuser=new GN_User__c();
         upuser.Email__c =ASUserEmail;
         upuser.First_Name__c=ASFirstName;
         upuser.Last_Name__c=ASLastName;
         upuser.title__c=ASTitle;
         upuser.phone__c=ASPhone;
          String[] ticketidandclientid =ticketitems.split(';');
          String ticketid=ticketidandclientid [0];
          String clientid=ticketidandclientid [1];
         userid=gnuserdao.updateGNUser(upuser,ASUserEmail,ticketid,null);
       }

       //create a new user and insert company and company role       
        if(oldASUserEmail!=ASUserEmail)
       {

             user user = new user();
                 user = userdao.CheckUser(ASUserEmail);
                
    if(user.id == null ){
            //Insert Contact
            contact Con = new Contact();
            Con.Lastname = ASFirstName ;
            Con.Firstname =ASLastName ; 
            con.email = ASUserEmail;
           
            string contactId = userdao.account_Contact(con);
            //Get Profile
            Profile P = [SELECT Id,Name FROM Profile WHERE Name = 'Event Admin'];
            user u = new user();
            U.ContactID =contactId;    
            U.Username = ASUserEmail;  
            U.Email = ASUserEmail;
            U.LastName = ASLastName ;
            U.FirstName = ASFirstName ;
            U.CompanyName = ASCompanyName ;
            U.Alias = 'EAdmin';
            U.ProfileID = P.id;
            U.Eff_Date__c=system.today();
            U.LocaleSidKey = 'en_US';
            U.LanguageLocaleKey = 'en_US';
            U.TimeZoneSidKey = 'America/Los_Angeles';
            U.EmailEncodingKey='UTF-8';
            U.CommunityNickname = String.valueOf(math.random());
            BLN_StatusMessage userMsg = userdao.createUser(u);
            //BLN_Debug.log('BLN_User_SignUP_BAL','createUser ','User Created',userMsg.errors);
              if(userMsg.successBool){
                userid=userMsg.successId; 
                //update GNUser
                GN_User__c upuser=new GN_User__c();
                 upuser.Email__c =ASUserEmail;
                 upuser.First_Name__c=ASFirstName;
                 upuser.Last_Name__c=ASLastName;
                 upuser.title__c=ASTitle;
                 upuser.phone__c=ASPhone;
                 String[] ticketidandclientid =ticketitems.split(';');
                  String ticketid=ticketidandclientid [0];
                  String clientid=ticketidandclientid [1];
                  userid=gnuserdao.updateGNUser(upuser,oldASUserEmail,ticketid,userid);  
                 
              }               
                }  
                
                
       }


        //create company and update user company role if company changes 
       if(oldASCompanyName!=ASCompanyName )
       {
       BLN_Company_DAO comdao=new BLN_Company_DAO();
        BLN_UCRole_DAO ucroledao=new BLN_UCRole_DAO();
          List<Company__c> company = [select id from Company__c where name=:ASCompanyName limit 1];
          String[] ticketidandclientid =ticketitems.split(';');
          String ticketid=ticketidandclientid [0];
          String clientid=ticketidandclientid [1];
           if(company.size()>0){
               ucroledao.updateUCRole1(clientid,company[0].id);   
               companyid=company[0].id;
           }else{
             if(ASCompanyName !=null){
               Company__c com = new Company__c();
               com.Name = ASCompanyName ;
               BLN_StatusMessage  compMsg=comdao.insertCompany(com);
                 companyid =compMsg.successId;
               ucroledao.updateUCRole1(clientid,companyid);   
                              
             }else{
              Company__c com = new Company__c();
               com.Name = ASFirstName+' '+ASLastName;
               BLN_StatusMessage  compMsg=comdao.insertCompany(com);
               companyid =compMsg.successId;
               ucroledao.updateUCRole1(clientid,companyid);  
             }        
           
           }   
           
           //Ticket Company Update
           
    
                //Ticket__c tc;
                BLN_Ticket_DAO tcktdao=new BLN_Ticket_DAO();
               //tc= tcktdao.getItemInfoFrmTicket(itemId,clientId,Apexpages.currentPage().getParameters().get('id'));
        List<Ticket__c> tc=tcktdao.getTickets('Client_Company__c,Order__c,Order__r.id,Order_Item__c,item__r.Ticket_Settings__c,Order_Item__r.Item__r.id,Order_Item__r.Item__r.item_name__c,Client_GN_User__c,Client_GN_User__r.First_Name__c,Client_GN_User__r.Last_Name__c,Client_GN_User__r.Email__c,Client_Company__r.name','id=\''+ticketId+'\' and Client_GN_User__c=\''+clientId+'\' and Event__c=\''+Apexpages.currentPage().getParameters().get('id')+'\'');           
        
     
        tc[0].Client_Company__c=companyid;
        update tc;
       }

      
        
     }
   

  //Get Tickets based on orderno or email
    public List<Ticket__c > getClientTicketsbasedonOrderOrEmail(String eventId,String ordernoOremail){
    BLN_Ticket_DAO tcktdao=new BLN_Ticket_DAO();
    List<Ticket__c > tckts=tcktdao.getTickets('id,name,Badge_ID__c,Badge_ID__r.Badge_Label__c,(select id,name,Badge_Label__c from badges__r  where cancel_time__c=null and Exp_time__c=null),Order__r.Name,Event__c,Order__c,Order__r.id,Order_Item__c,Order_Item__r.Item__r.id,Order_Item__r.Item__r.item_name__c,Client_GN_User__c,Client_GN_User__r.First_Name__c,Client_GN_User__r.Last_Name__c,Client_GN_User__r.Email__c,Client_Company__r.name,Ticket_Status__c,Item_Pool__r.Badgable__c','Event__c=\''+eventId+'\' and Ticket_Status__c=\'Booked\' and Item_Pool__r.Badgable__c=\'B - Badge\' and (Client_GN_User__r.Email__c=\'' + ordernoOremail+ '\' or Order__r.name=\''+ordernoOremail+'\' or Client_GN_User__r.First_Name__c=\''+ordernoOremail+'\' or Client_GN_User__r.Last_Name__c=\''+ordernoOremail+'\' or Client_Company__r.name=\''+ordernoOremail+'\') order by Order__r.Name');
    if(tckts.size()>0)
   return tckts;
   else
   return new List<Ticket__c>();
   }
  
   //Generate Badge while printing
   public String generateBadge(String badgelabel,String ticketid)
   {
        //generate badge for single ticket
                    Badge__c bg=new Badge__c();
                    bg.Badge_Label__c=badgelabel;
                    bg.ticket_id__c=ticketid;
                    BLN_Badge_DAO bdgdao=new BLN_Badge_DAO();
                   
        BLN_StatusMessage userMsg =  bdgdao.insertbadge(bg);
           
              if(userMsg.successBool){
              //update badgeid in ticket
          Ticket__c up=new Ticket__c();
          up.id=ticketid;
          up.badge_label__c=badgelabel;
          up.badge_id__c=userMsg.successId;
          update up;
                 return userMsg.successId;
                              
              }else{
                  return userMsg.errors ;
              }
           
   }

 
  //------------------------------------------------------------------------- Registration start --------------------------  
    
    
    // Insert orders and tickets for registrationpage By Phani On 22/12/2014
      public void insertingusers(List<Gn_user__c> userslist){
           BLN_Gnuser_DAO blnusersdao = new BLN_Gnuser_DAO();
           BLN_User_DAO usrdao = new BLN_User_DAO();
           SET<string> duplicateremove = new SET<string>();
           List<contact> insertingCon = new List<contact>();
           MAP<string,Gn_user__c> existingusers = new MAP<string,Gn_user__c>(); 
           MAP<string,id> mapconemailWithId = new MAP<string,id>();
           List<user> sfuserList = new List<user>();   
           MAP<string,Gn_user__c> emails = new MAP<string,Gn_user__c>(); 
           List<Gn_user__c> gnusersList = new List<Gn_user__c>();   
           
             for(Gn_user__c users : userslist){
               emails.put(users.Email__c,users);
             }  
            // Getting users who are existed   
             for(Gn_user__c  em :blnusersdao.existingGnusers(emails.keyset()) ){
               existingusers.put(em.Email__c,em);   
            }
             // Inserting Contacts for inserting user
             for(Gn_user__c usersid : userslist){
              if((!existingusers.keyset().contains(usersid.Email__c)) && (!duplicateremove.contains(usersid.Email__c))){
                    contact Con = new Contact();
                    Con.Lastname = usersid.Last_name__c ;
                    Con.Firstname =usersid.First_name__c ; 
                    con.email = usersid.email__c;
                    insertingCon.add(con);
                    duplicateremove.add(usersid.email__c);
                   // contactId = blnuserDao.account_Contact(con);
               }       
            }  
            BLN_StatusMessage blnmsg ;
             //Mapping contactEmail with conid 
                If(insertingCon.size()>0){
                 List<contact> contactslistnew = new List<Contact>();
                 contactslistnew = usrdao.conList(usrdao.account_Contact(insertingCon));
                   for(contact conids :contactslistnew ){
                     user sfuser = new user();
                      sfuser.ContactID =conids.id;    
                      sfuser.Username = conids.email;  
                      sfuser.Email = conids.email;
                      sfuser.LastName = conids.LastName;
                      sfuserList.add(sfuser);
                   }
              // Inserting users 
                 blnmsg = usrdao.insertUserBulk(sfuserList);      
            }
          
          // Iterating for inserting gn user
           for(user uy :usrdao.getusers(blnmsg.successIds)){
              Gn_user__c gn =  emails.get(uy.username);
              gn.User__c = uy.id;
              gnusersList.add(gn);
           }         
           blnusersdao.InsertGNUser(gnusersList);   
     }
    
  // Inserting companies for guests if he picks company from existing we are not passing here
   public void insertingCompanies(SET<Company__c> companies){
      BLN_Company_DAO compdao = new BLN_Company_DAO();
      //BLN_StatusMessage blnmsg = compdao.insertCompanyBulk(companies);       
   }
       
  
  
  
  
}