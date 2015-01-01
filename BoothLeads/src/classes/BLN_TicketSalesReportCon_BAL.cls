/***********************************************************************************************
*   Controller Name : BLN_TicketSalesReportCon_BAL
*   Date            : 10/30/2014
*   Author          : Manasa Gandham
*   Purpose         : This class is to display the PromoCode Report
*   Change History  : 10/30/2014
*       Date                 Programmer                     Reason
*   --------------      -------------------           -------------------------
*    10/30/2014              Manasa Gandham                 To Create Page
*  
**************************************************************************************************/

public without sharing class BLN_TicketSalesReportCon_BAL{

    public BLN_TicketSalesReportCon_BAL(){
        
    }  
    
    public BLN_Order_DAO ordersDAOClass{get; set;}
    public BLN_Item_DAO ticketsDAOClass{get; set;}
    
    public LIST<ticketsInner> ticketsSalesForEvent(String EventId, Date FromDate, Date ToDate, String SearchString){
        
        ordersDAOClass= new BLN_Order_DAO();
        ticketsDAOClass= new BLN_Item_DAO();
        LIST<order__c> ordersList= new LIST<order__c>();
        String queryString= '';
        queryString= ' where Events__c = \''+EventId+'\'';
        queryString += ' AND Transaction_Status__c = \''+'Completed'+'\'';
        system.debug('  000000000000  '+queryString);        
        ordersList= ordersDAOClass.orderListForEvent(queryString);
        MAP<String, Decimal> itemDiscountMAP= new MAP<String, Decimal>();
        MAP<String, Decimal> itemFeeMAP= new MAP<String, Decimal>();
        MAP<String, Decimal> itemAmountMAP= new MAP<String, Decimal>();        
        MAP<String, Decimal> itemTotalDiscountMAP= new MAP<String, Decimal>(); 
          MAP<String, Decimal> itemTotalFeeMAP= new MAP<String, Decimal>();    
        MAP<String, Decimal> itemTotalAmountMAP= new MAP<String, Decimal>();
        MAP<String, Decimal> itemCountMAP= new MAP<String, Decimal>();
        system.debug(ordersList.size()+'  ORDERS SIZE ');        
        for(order__c order: ordersList){
            system.debug(' 00000000000000 '+order);        
            LIST<Payment__c> PaymentsList= new LIST<Payment__c>();
            PaymentsList= order.Payments__r;
            String paymentTypeString='';
            if(PaymentsList.size() >0){
            if(PaymentsList[0].Payment_Mode__c == 'Check'){
                paymentTypeString= PaymentsList[0].Payment_Mode__c;            
            }else if(PaymentsList[0].Payment_Mode__c == 'MasterCard' || PaymentsList[0].Payment_Mode__c == 'Visa' || PaymentsList[0].Payment_Mode__c == 'Discover' || PaymentsList[0].Payment_Mode__c == 'American Express'){
                paymentTypeString= 'CreditCard';                        
            }else if(PaymentsList[0].Payment_Mode__c == 'Cash'){
                paymentTypeString= PaymentsList[0].Payment_Mode__c;            
            }else if(PaymentsList[0].PGateway_Type__c != Null){
                paymentTypeString= 'External Pay';            
            }
            
            system.debug(' 11111111111111 '+paymentTypeString);        
            LIST<Order_Item__c> orderItemsList= new LIST<Order_Item__c>();
            orderItemsList= order.Order_Items__r;
            for(Order_Item__c orderItem: orderItemsList){ 
                if(orderItem.Status__c == 'Active'){
                
                    paymentTypeString= orderItem.Item__c+'-'+paymentTypeString;
                    system.debug(' 22222222222222 '+paymentTypeString);        
                    //Assigning Item Payment type Count to MAP                    
                    if(itemCountMAP.containsKey(paymentTypeString)){
                        Decimal itemCount= itemCountMAP.get(paymentTypeString);
                        itemCount= itemCount+orderItem.Item_Quantity__c;
                        itemCountMAP.put(paymentTypeString, itemCount);
                    }else{
                        itemCountMAP.put(paymentTypeString, orderItem.Item_Quantity__c);
                    }
                      
                    //Assiging discount with payment type to MAP
                    if(itemDiscountMAP.containsKey(paymentTypeString)){
                        Decimal discountAmount= itemDiscountMAP.get(paymentTypeString);
                        discountAmount= discountAmount+orderItem.Item_Discount__c;
                        itemDiscountMAP.put(paymentTypeString, discountAmount);
                    }else{
                        itemDiscountMAP.put(paymentTypeString, orderItem.Item_Discount__c);
                    }
                    //Assiging Total Amount with payment type to MAP
                    if(itemAmountMAP.containsKey(paymentTypeString)){
                        Decimal totalAmount= itemAmountMAP.get(paymentTypeString);
                        totalAmount= totalAmount+orderItem.Item_Total__c;
                        itemAmountMAP.put(paymentTypeString, totalAmount);
                    }else{
                        itemAmountMAP.put(paymentTypeString, orderItem.Item_Total__c);
                    }
                    //Assiging Tickets discount to MAP
                    if(itemTotalDiscountMAP.containsKey(orderItem.Item__c)){
                        Decimal discountAmount= itemTotalDiscountMAP.get(orderItem.Item__c);
                        discountAmount= discountAmount+orderItem.Item_Discount__c;
                        itemTotalDiscountMAP.put(orderItem.Item__c, discountAmount);
                    }else{
                        itemTotalDiscountMAP.put(orderItem.Item__c, orderItem.Item_Discount__c);
                    }
                    /*//Assiging Tickets fee to MAP
                    if(itemTotalFeeMAP.containsKey(orderItem.Item__c)){
                        Decimal feeAmount= itemTotalFeeMAP.get(orderItem.Item__c);
                        feeAmount= feeAmount+OrderItem.Item_Type__r.BL_Fee_Amt_per_res__c;
                        itemTotalFeeMAP.put(orderItem.Item__c,  feeAmount);
                    }else{
                        itemTotalFeeMAP.put(orderItem.Item__c, OrderItem.Item_Type__r.BL_Fee_Amt_per_res__c);
                    }*/
                    
                    //Assiging Tickets Total Amount to MAP
                     system.debug(orderItem.Item__c+' 222222222222222 '+itemTotalAmountMAP.containsKey(orderItem.Item__c));        
                     if(itemTotalAmountMAP.containsKey(orderItem.Item__c)){
                        Decimal totalAmount= itemTotalAmountMAP.get(orderItem.Item__c);
                        totalAmount= totalAmount+orderItem.Item_Total__c;
                        itemTotalAmountMAP.put(orderItem.Item__c, totalAmount);
                        system.debug('   44444444   '+itemTotalAmountMAP);
                    }else{
                        itemTotalAmountMAP.put(orderItem.Item__c, orderItem.Item_Total__c);
                        system.debug('  555555555   '+itemTotalAmountMAP);
                    }
                    system.debug(orderItem.Item__c+' 333333333333333 '+itemTotalAmountMAP);            

                }               
                
            }
            }
        
        }        
        
        /*
        // ********************************************
        
        //Building Search Functionality in between From and To Dates
        SET<Id> TicketIds= new SET<Id>();
        if(SearchString == null){
        }else{
            queryString= ' where Events__c = \''+EventId+'\'';
            queryString += ' AND Transaction_Status__c = \''+'Completed'+'\'';
            system.debug('  000000000000  '+queryString);
        
            if(FromDate != null){
                system.debug('  FROM DATE00000000000 '+FromDate);
                FromDate= FromDate.addDays(1);            
                dateTime d1 = FromDate;
                system.debug('  FROM DATE1111111111 '+d1);
                string FromDateStr= d1.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
                system.debug('  FROM DATE2222222222222 '+FromDateStr);
                queryString += ' AND Order__r.CreatedDate >= '+FromDateStr;
            } 
            system.debug('  111111111  '+queryString);
            if(ToDate != null){
                ToDate= ToDate.addDays(1);            
                dateTime d1 = ToDate;
                string ToDateStr= d1.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        
                queryString += ' AND Order__r.CreatedDate <='+ToDateStr;            
            }
            
                //queryString += ' AND (Client_GN_User__r.First_Name__c Like \'%'+SearchString+'%\''+' OR Client_GN_User__r.Last_Name__c Like \'%'+SearchString+'%\''+' OR Client_GN_User__r.Email__c Like \'%'+SearchString+'%\''+' OR Client_GN_User__r.Company_Name__c Like \'%'+SearchString+'%\''+' OR item__r.item_Name__c Like \'%'+SearchString+'%\''+' )'; 
              
        
            system.debug('  QUERY STRING11111111 '+queryString );
            LIST<LIST<BLN_Item__c>> ListOfItems= new LIST<LIST<BLN_Item__c>>();
            LIST<BLN_Item__c> itemList= new LIST<BLN_Item__c>();
            LIST<BLN_Item__c> itemList999= new LIST<BLN_Item__c>();
            itemList= ticketsDAOClass.itemsListForEvent(queryString);
        
            //for(BLN_Item__c item : itemList){
                //TicketIds.add(item.items__r);
            //}
        }
        
        queryString='';
        queryString= ' where Events__c = \''+EventId+'\'';
        queryString += ' AND Transaction_Status__c = \''+'Completed'+'\'';
        system.debug('  000000000000  '+queryString);
        if(FromDate != null){
            FromDate= FromDate.addDays(-1);            
            dateTime d1 = FromDate;
            string FromDateStr= d1.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
            queryString += ' and CreatedDate >= '+FromDateStr;
        } 
        system.debug('  111111111  '+queryString);
        if(ToDate != null){
            ToDate= ToDate.addDays(1);
            dateTime d1 = ToDate;
            string ToDateStr= d1.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        
            queryString += ' and CreatedDate <='+ToDateStr;            
        }
        
        // *************************************************************************************************** 
        */
    
        //Getting Tickets List belongs to Event
        LIST<ticketsInner> ticketsInnerList= new LIST<ticketsInner>();
        LIST<BLN_Item__c> itemsList= new LIST<BLN_Item__c>();
        queryString= '';
        queryString= ' where Event__c = \''+EventId+'\'';
        itemsList= ticketsDAOClass.itemsListForEvent(queryString);
        
        Decimal TotalTicketCount= 0;
        Decimal TotalAmount= 0;
        Decimal TotalDiscountAmount= 0;
        
        Decimal TotalCheckTicketCount= 0;
        Decimal TotalCreditCardTicketCount= 0;
        Decimal TotalCheckAmount= 0;
        Decimal TotalCreditCardAmount= 0;
        Decimal TotalCheckDiscountAmount= 0;
        Decimal TotalCreditCardDiscountAmount= 0;
        
        //For cassh Payment Type values
        Decimal TotalCashTicketCount= 0;
        Decimal TotalCashDiscountAmount= 0;
        Decimal TotalCashAmount= 0;
        
        //For External Payment Gateway Payment Type values
        Decimal TotalExtPayTicketCount= 0;
        Decimal TotalExtPayDiscountAmount= 0;
        Decimal TotalExtPayAmount= 0;
            
        for(BLN_Item__c item: itemsList){
            system.debug('  ITEM ID '+item.Id);
            Decimal usedTicketsCount=0;
            
            if(itemCountMAP.get(item.Id+'-'+'Check') != NULL){
                usedTicketsCount= itemCountMAP.get(item.Id+'-'+'Check');
            }
            if(itemCountMAP.get(item.Id+'-'+'CreditCard') != NULL){
                usedTicketsCount += itemCountMAP.get(item.Id+'-'+'CreditCard');
            }
            if(itemCountMAP.get(item.Id+'-'+'Cash') != NULL){
                usedTicketsCount= itemCountMAP.get(item.Id+'-'+'Cash');
            }
            if(itemCountMAP.get(item.Id+'-'+'External Pay') != NULL){
                usedTicketsCount += itemCountMAP.get(item.Id+'-'+'External Pay');
            }
            Decimal discountPrice=0;
            Decimal totalPrice= 0;
            if(itemTotalDiscountMAP.get(item.Id) != NULL){
                discountPrice= itemTotalDiscountMAP.get(item.Id);
            }else{
                discountPrice=0;
            }
            
            if(itemTotalAmountMAP.get(item.Id) != NULL){
                totalPrice= itemTotalAmountMAP.get(item.Id);
            }else{
                totalPrice=0;
            }
           
            Decimal CheckTicketCount= 0;
            Decimal CreditCardTicketCount= 0;
            Decimal CheckTotalAmount= 0;
            Decimal CreditCardTotalAmount= 0;
            Decimal CheckDiscountAmount= 0;
            Decimal CreditCardDiscountAmount= 0;
            
            //For cash Payment Type values
            Decimal cashTicketCount = 0;
            Decimal cashDiscountAmount= 0;
            Decimal cashTotalAmount= 0;
            
            //For External Payment Gateway Payment Type values
            Decimal extPayTicketCount = 0;
            Decimal extPayDiscountAmount= 0;
            Decimal extPayTotalAmount= 0;
            
            if(itemCountMAP.containsKey(item.Id+'-'+'Check')){
                CheckTicketCount= itemCountMAP.get(item.Id+'-'+'Check');
            }else{
                CheckTicketCount=0;
            }
            
            //For cash payment Type values
            if(itemCountMAP.containsKey(item.Id+'-'+'Cash')){
                cashTicketCount = itemCountMAP.get(item.Id+'-'+'Cash');
            }else{
                cashTicketCount =0;
            }
            if(itemDiscountMAP.containsKey(item.Id+'-'+'Cash')){
                cashDiscountAmount= itemDiscountMAP.get(item.Id+'-'+'Cash');
            }else{
                cashDiscountAmount=0;
            }
            if(itemAmountMAP.containsKey(item.Id+'-'+'Cash')){
                cashTotalAmount= itemAmountMAP.get(item.Id+'-'+'Cash');
            }else{
                cashTotalAmount=0;
            }
            
            //For External Payment Gateway Payment Type values
            if(itemCountMAP.containsKey(item.Id+'-'+'External Pay')){
                extPayTicketCount = itemCountMAP.get(item.Id+'-'+'External Pay');
            }else{
                extPayTicketCount =0;
            }
            if(itemDiscountMAP.containsKey(item.Id+'-'+'External Pay')){
                extPayDiscountAmount= itemDiscountMAP.get(item.Id+'-'+'External Pay');
            }else{
                extPayDiscountAmount=0;
            }
            if(itemAmountMAP.containsKey(item.Id+'-'+'External Pay')){
                extPayTotalAmount= itemAmountMAP.get(item.Id+'-'+'External Pay');
            }else{
                extPayTotalAmount=0;
            }
            
            if(itemCountMAP.containsKey(item.Id+'-'+'CreditCard')){
                CreditCardTicketCount= itemCountMAP.get(item.Id+'-'+'CreditCard');
            }else{
                CreditCardTicketCount=0;
            }
            
            if(itemDiscountMAP.containsKey(item.Id+'-'+'Check')){
                CheckDiscountAmount= itemDiscountMAP.get(item.Id+'-'+'Check');
            }else{
                CheckDiscountAmount=0;
            }
            
            if(itemDiscountMAP.containsKey(item.Id+'-'+'CreditCard')){
                CreditCardDiscountAmount= itemDiscountMAP.get(item.Id+'-'+'CreditCard');
            }else{
                CreditCardDiscountAmount=0;
            }
            
            if(itemAmountMAP.containsKey(item.Id+'-'+'Check')){
                CheckTotalAmount= itemAmountMAP.get(item.Id+'-'+'Check');
            }else{
                CheckTotalAmount=0;
            }
            
            if(itemAmountMAP.containsKey(item.Id+'-'+'CreditCard')){
                CreditCardTotalAmount= itemAmountMAP.get(item.Id+'-'+'CreditCard') ;
            }else{
                CreditCardTotalAmount=0;
            }
            TotalTicketCount +=usedTicketsCount;            
            TotalCheckTicketCount += CheckTicketCount;
            TotalCreditCardTicketCount += creditCardTicketCount;
            
            //For cash Payment Type values
            TotalCashTicketCount+=cashTicketCount;
            TotalCashDiscountAmount+= cashDiscountAmount;
            TotalCashAmount+= cashTotalAmount;
            
            //For External Payment Gateway Payment Type values
            TotalExtPayTicketCount+=extPayTicketCount;
            TotalExtPayDiscountAmount+= extPayDiscountAmount;
            TotalExtPayAmount+= extPayTotalAmount;
            
            TotalAmount += totalPrice;
            TotalCheckAmount+= CheckTotalAmount;
            TotalCreditCardAmount +=CreditCardTotalAmount;
            TotalDiscountAmount += discountPrice; 
            TotalCheckDiscountAmount+= CheckDiscountAmount;
            TotalCreditCardDiscountAmount+= CreditCardDiscountAmount; 
            system.debug(totalPrice+' DISCOUNT '+discountPrice);           
           system.debug(ticketsInnerList.size()+'    TICKETS INNER LIST '+ticketsInnerList);
            ticketsInnerList.add(new ticketsInner(item, usedTicketsCount, discountPrice, totalPrice, CheckTicketCount, creditCardTicketCount, CheckTotalAmount, CreditCardTotalAmount, CheckDiscountAmount, CreditCardDiscountAmount,cashTicketCount,cashDiscountAmount,cashTotalAmount,extPayTicketCount,extPayDiscountAmount,extPayTotalAmount));
        }
        ticketsInnerList.add(new ticketsInner(new BLN_Item__c(), TotalTicketCount, TotalDiscountAmount, TotalAmount, TotalCheckTicketCount, TotalCreditCardTicketCount, TotalCheckAmount, TotalCreditCardAmount , TotalCheckDiscountAmount, TotalCreditCardDiscountAmount,TotalCashTicketCount,TotalCashDiscountAmount,TotalCashAmount,TotalExtPayAmount,TotalExtPayDiscountAmount,TotalExtPayAmount));
        return ticketsInnerList;
    }
    
    
    public class ticketsInner{
        
        public BLN_Item__c ticketData{get; set;}
        public Decimal usedTickets{get; set;}
        public Decimal totalDiscount{get; set;}
        public Decimal totalAmount{get; set;}
        public Decimal checkTicketCount{get; set;}
        public Decimal creditCardTicketCount{get; set;}
        public Decimal checkTotalAmount{get; set;}
        public Decimal creditCardTotalAmount{get; set;}
        public Decimal checkDiscountAmount{get; set;}
        public Decimal creditCardDiscountAmount{get; set;}
        
        //For cash Payment Type values
        public Decimal cashTicketCount {get; set;}
        public Decimal cashDiscountAmount{get; set;}
        public Decimal cashTotalAmount{get; set;}
        
        //For External Payment Gateway Payment Type values
        public Decimal extPayTicketCount {get; set;}
        public Decimal extPayDiscountAmount{get; set;}
        public Decimal extPayTotalAmount{get; set;}
        
        public Decimal totalFee{get; set;}
        public Decimal checkTicketFeeCount{get; set;}
        public Decimal creditCardFeeCount{get; set;}
       //public LIST<paymentTypeInner> paymentTypeInnerList{get; set;}
        
        public ticketsInner(BLN_Item__c ticketData, Decimal usedTickets, Decimal totalDiscount, Decimal totalAmount, Decimal checkTicketCount, Decimal creditCardTicketCount, Decimal checkTotalAmount, Decimal creditCardTotalAmount, Decimal checkDiscountAmount, Decimal creditCardDiscountAmount,Decimal cashTicketCount,Decimal cashDiscountAmount,Decimal cashTotalAmount,Decimal extPayTicketCount,Decimal extPayDiscountAmount,Decimal extPayTotalAmount){
            this.ticketData= ticketData;
            this.usedTickets= usedTickets;
            this.totalDiscount= totalDiscount;
            this.totalAmount= totalAmount;
            this.checkTicketCount= checkTicketCount;
            this.creditCardTicketCount= creditCardTicketCount;
            this.checkTotalAmount= checkTotalAmount;
            this.creditCardTotalAmount= creditCardTotalAmount;
            this.checkDiscountAmount= checkDiscountAmount;
            this.creditCardDiscountAmount= creditCardDiscountAmount;
            
            //For cash Payment Type values
            this.cashTicketCount=cashTicketCount;
            this.cashDiscountAmount=cashDiscountAmount;
            this.cashTotalAmount=cashTotalAmount;
            
            //For External Payment Gateway Payment Type values
            this.extPayTicketCount=extPayTicketCount;
            this.extPayDiscountAmount=extPayDiscountAmount;
            this.extPayTotalAmount=extPayTotalAmount;
            //this.paymentTypeInnerList= paymentTypeInnerList;
        }
    }
    
    /*
    public class paymentTypeInner{
        
        public String paymentType{get; set;}
        public Decimal ticketCount{get; set;}
        public Decimal typeDiscountPrice{get; set;}
        public Decimal typeTotalAmount{get; set;}
                
        public paymentTypeInner(String paymentType, Decimal ticketCount, Decimal typeDiscountPrice, Decimal typeTotalAmount){
            
            this.paymentType= paymentType;
            this.ticketCount= ticketCount;
            this.typeDiscountPrice= typeDiscountPrice;
            this.typeTotalAmount= typeTotalAmount;
        }
    
    }
    */
    
    
    }