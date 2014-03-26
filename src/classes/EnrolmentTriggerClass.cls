public with sharing class EnrolmentTriggerClass 
{

/*
Author: Eamon Kelly, Enclude
Purpose: the value in the Enrolment “Status on Programme” should be written to the appropriate field on the client
Called from: Enrolment Trigger

*/
	public void MainEntry (Boolean isBefore, Boolean isDelete, Boolean isAfter, Boolean isInsert, Boolean isUpdate, Boolean isExecuting,
		List<ecass01__Enrolment__c> newList, Map<Id, ecass01__Enrolment__c> newMap, List<ecass01__Enrolment__c> oldList, Map<Id, ecass01__Enrolment__c> oldMap)
	{
		if (isAfter && (isInsert || isUpdate))
		{
			map <ID, ecass01__Enrolment__c> clientStabilisationMap = new map <ID, ecass01__Enrolment__c>();
			map <ID, ecass01__Enrolment__c> clientDetoxMap = new map <ID, ecass01__Enrolment__c>();
			list <ecass01__Enrolment__c> enrols = [select ID, ecass01__Program_Service__r.ecass01__Course_Type__c, ecass01__Young_Person__c, ecass01__Status_on_Programme__c, ecass01__Date_joined_program__c from ecass01__Enrolment__c where id in :newMap.keyset()];
			for (ecass01__Enrolment__c oneE : enrols)
			{
				if (oneE.ecass01__Program_Service__r.ecass01__Course_Type__c == 'Stabilisation') clientStabilisationMap.put (oneE.ecass01__Young_Person__c, oneE);
				if (oneE.ecass01__Program_Service__r.ecass01__Course_Type__c == 'Community Detox') clientDetoxMap.put (oneE.ecass01__Young_Person__c, oneE);
			}
			List <Contact> stabClients = [select ID, Date_admitted_to_stabilisation_group__c, Stabilisation_Group_status__c from Contact where ID in :clientStabilisationMap.keySet()];
			List <Contact> detoxClients = [select ID, Community_Detox_group_status__c from Contact where ID in :clientDetoxMap.keySet()];
			
			for (Contact oneClient: stabClients)
			{
				ecass01__Enrolment__c enrolment = clientStabilisationMap.get (oneClient.id);
				if (enrolment != null)
				{
					oneClient.Stabilisation_Group_status__c = enrolment.ecass01__Status_on_Programme__c;
					if (enrolment.ecass01__Status_on_Programme__c == 'Admitted to Coolmine' && oldMap.get(enrolment.id).ecass01__Status_on_Programme__c != 'Admitted to Coolmine')
					{
						oneClient.Date_admitted_to_stabilisation_group__c = system.today();
					}
				}
			}

			for (Contact oneClient: detoxClients)
			{
				ecass01__Enrolment__c enrolment = clientDetoxMap.get (oneClient.id);
				if (enrolment != null)
				{
					oneClient.Community_Detox_group_status__c = enrolment.ecass01__Status_on_Programme__c;
				}
			}
			if (stabClients.size() > 0) update stabClients;
			if (detoxClients.size() > 0) update detoxClients;
		}
	}
}