/* Test for CreateDetoxClient  */
@isTest
private class TestCreateDetoxClient
{

    public static testMethod void TestNewDetoxClient ()
    {
        Contact testClient = new Contact (FirstName='Test', LastName='Client', BirthDate=Date.valueOf('2014-03-24'));
        insert testClient;
        ID testClientID = testClient.ID;
        String checkFullName;
        
        /* Basic check, adding new Detox client */
        Test.setCurrentPage(Page.DetoxClientPage);
        ApexPages.StandardController testContactController = new ApexPages.StandardController(testClient);
        
        CreateDetoxClient testDetoxClient = new CreateDetoxClient(testContactController);
        
        testDetoxClient.makeDetoxClient();
        
        Detox_Client__c clientCreated = [SELECT ID, Client_Name__c, Date_of_Birth__c FROM Detox_Client__c];
        
        System.AssertEquals('Test Client',clientCreated.Client_Name__c);
        Date checkDate = Date.valueOf('2014-03-24');
        System.AssertEquals(checkDate,clientCreated.Date_of_Birth__c);
        
        testClient = [SELECT ID, Detox_Client__c FROM Contact where ID = :testClient.ID];
    
        System.AssertEquals(clientCreated.ID, testClient.Detox_Client__c); 
        
        /* Check behaviour when user attempts to create duplicate Detox client */
        Test.setCurrentPage(Page.DetoxClientPage);
        ApexPages.StandardController duplicateContactController = new ApexPages.StandardController(testClient);
 
        CreateDetoxClient duplicateDetoxClient = new CreateDetoxClient(duplicateContactController);
        duplicateDetoxClient.makeDetoxClient();
        
        List<Detox_Client__c> allDetoxClients = new List<Detox_Client__c>();
        allDetoxClients = [SELECT ID FROM Detox_Client__c];    
        System.AssertEquals(1,allDetoxClients.size());
        
        /* Check synching of Detox client when Name or Date of Birth is changed in Contact record */
        testClient.ID = testClientID;
        testClient.Birthdate = Date.valueOf('2013-03-25');
        update testClient;
        
        testClient.ID = testClientID;
        testClient.LastName = 'New';
        update testClient;
        
        testClient.ID = testClientID;
        testClient.FirstName = 'Client';
        update testClient;
 
        List<Contact> updatedContacts = [SELECT FirstName, LastName, Birthdate, Detox_Client__c from Contact WHERE ID = :testClientID];
       
        ID detoxClientID = updatedContacts[0].Detox_Client__c;
        allDetoxClients = [SELECT ID, Client_Name__c, Date_of_Birth__c FROM Detox_Client__c WHERE ID = :detoxClientID];
        
        Detox_Client__c checkDetoxClient = allDetoxClients[0];
        checkFullName = updatedContacts[0].FirstName + ' ' + updatedContacts[0].LastName;
        System.AssertEquals(checkFullName,checkDetoxClient.Client_Name__c);
        System.AssertEquals(updatedContacts[0].Birthdate,checkDetoxClient.Date_of_Birth__c);
        
        
        /* Check synching logic works when a number of update records are passed */
        List<Contact> contactList = new List<Contact>();
        for (Integer i = 0;i<6;i++){
        	contactList.add(new Contact(LastName = 'ListTest'+ i));
        }
        insert contactList;
        
        /* Now create related detox client records */
 		ApexPages.StandardController newContactController;
 		CreateDetoxClient newDetoxClient;
 		for (Contact newContact: contactList){
 			Test.setCurrentPage(Page.DetoxClientPage);
 			newContactController = new ApexPages.StandardController(newContact);
        	newDetoxClient = new CreateDetoxClient(newContactController);
 			newDetoxClient.makeDetoxClient();
 		}
		
		/* Update dates for selected records */
        checkDate = Date.valueOf('2014-03-25');
        for (Integer i=0;i<6;i=i+2){
        	contactList[i].Birthdate = checkDate;	
        }
        update contactList;
        
        /* Check expected updates have been made */ 
        Integer updatedDetoxClientRecordCount = 0;
        updatedDetoxClientRecordCount = [SELECT COUNT() FROM Detox_Client__c WHERE Date_of_Birth__c = :checkDate];
        System.AssertEquals(3,updatedDetoxClientRecordCount);
        
       
    }

}