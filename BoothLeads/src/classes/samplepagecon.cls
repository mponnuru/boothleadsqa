global class samplepagecon {

   public samplepage2con ins {get;set;}
   
   public  samplepagecon (){
     ins = new samplepage2con();
     
     pageREference pf = page.BLN_Registrationnew;
      Apexpages.currentPage().getParameters().put('Id','xyz');
     
   }
    
 }