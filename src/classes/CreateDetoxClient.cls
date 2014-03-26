/* 
Author: Maeve Kerney, Enclude
Purpose: Create detox record using details from Contact record
 
Called from: CreateDetoxClientPage - button on a Contact (initially Open Access only)
Tested in: TestCreateDetoxClient
*/
public with sharing class CreateDetoxClient
{
  private Contact basedOnClient;
  private Detox_Client__c detoxClient;
  
  public CreateDetoxClient(ApexPages.StandardController controller)
    {
        basedOnClient = (Contact)controller.getRecord();
        basedOnClient = [SELECT ID, Name, Birthdate, Detox_Client__c FROM Contact WHERE ID = :basedOnClient.ID];
        system.debug('Contact: ' + basedOnClient.Name + basedOnClient.Birthdate);
    }
  
  public PageReference makeDetoxClient ()
    {
        if (basedOnClient.Detox_Client__c == NULL)
        	detoxClient = newDetoxClient();
        else {
        	detoxClient = new Detox_Client__c();
        	detoxClient = [SELECT Id FROM Detox_Client__c WHERE Id = :basedOnClient.Detox_Client__c];
        	system.debug('Detox client record already created');
        }

        String detoxClientURL = '/' + detoxClient.ID + '/e?retURL=%2F' + detoxClient.ID;
        PageReference detoxClientPage = new PageReference(detoxClientURL);
        return detoxClientPage;
        
    }
        
        
  public Detox_Client__c newDetoxClient()
    {
       
       Detox_Client__c thisDetoxClient = new Detox_Client__c (Client_Name__c = basedOnClient.Name,Date_of_Birth__c = basedOnClient.Birthdate);
       insert thisDetoxClient;
       
       system.debug('Detox client: '+ thisDetoxClient);
       system.debug('basedOnClient: ' + basedOnClient);
       
       basedOnClient.Detox_Client__c = thisDetoxClient.ID;       
       update basedOnClient; 
       
       system.debug('Updated contact: ' + basedOnClient.Name + basedOnClient.Birthdate + basedOnClient.Detox_Client__c);
       
       return(thisDetoxClient);
      
    }
        
 
}