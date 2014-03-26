trigger SynchDetoxClientWithContactUpdates on Contact (after update) 
	
{


	List<Contact> updatedContacts = new List<Contact>();
	updatedContacts = Trigger.new;

	Set<ID> updatedDetoxIDSet = new Set<ID>();
	for(Contact thisContact: updatedContacts)
	{
		if (thisContact.Detox_Client__c != NULL)
			updatedDetoxIDSet.add(thisContact.Detox_Client__c); 
	}


	if (updatedDetoxIDSet.size() > 0)
	{

	
		map<ID,Detox_Client__c> detoxClients = new map <ID,Detox_Client__c> ([SELECT Client_Name__c, Date_of_Birth__c FROM Detox_Client__c WHERE ID IN :updatedDetoxIDSet]);

		if (detoxClients.size()>0)
		{
	
	        system.debug('Size of Non-null IDs set: '+updatedDetoxIDSet.size());
	        system.debug('Number of detox clients retrieved: '+detoxClients.size());
	        
			List<Detox_Client__c> detoxClientsForUpdate = new List<Detox_Client__c>();
			Detox_Client__c updatedDetoxClient = new Detox_Client__c();
			String thisContactName;
	
			for (Contact thisContact: updatedContacts)
			{
				
				system.debug('**thisContact: '+ thisContact.Name + thisContact.FirstName + thisContact.LastName + thisContact.BirthDate);
				thisContactName = thisContact.FirstName + ' ' + thisContact.LastName;
				
				if (thisCOntact.Detox_Client__c !=NULL)
				{
				
					Detox_Client__c thisClient = detoxClients.get(thisContact.Detox_Client__c);
			
					if ((thisContactName != thisClient.Client_Name__c) ||(thisContact.Birthdate != thisClient.Date_of_Birth__c))
						{ 		
						    thisClient.Client_Name__c = thisContactName;
							thisClient.Date_of_Birth__c = thisContact.Birthdate;
			
							detoxClientsForUpdate.add(thisClient);
						
						}
				}
			}	

		system.debug('Detox clients for update: ' + detoxClientsForUpdate);

		if (detoxClientsForUpdate.size()>0)
			update detoxClientsForUpdate;

		}
	}
	
}