public with sharing class ClientTriggerClass 
{
/*
	public void MainEntry (Boolean isBefore, Boolean isDelete, Boolean isAfter, Boolean isInsert, Boolean isUpdate, Boolean isExecuting,
		List<Contact> newList, Map<Id, Contact> newMap, List<Contact> oldList, Map<Id, Contact> oldMap)
	{
/*
	Changes to Stabilisation_Group_status__c
		When the status is changed to "Admitted", the client is enroled in the stabilisation group.
		When the status is changed to "Departed", the client is removed from the stabilisation group.
	
	Community_Detox_group_status__c
		When status is changed to "Joined Group", client is enroled in community detox group.
		When status is changed to "Left Group", client is removed from community detox group.
		
	There should be only one of each type of group in the system and the group type is identified by the field ecass01__Course_Type__c

		ecass01__Program_Service__c detoxCourse, stabilisationCourse;
		
		try
		{
			detoxCourse = [select ID from ecass01__Program_Service__c where ecass01__Course_Type__c = 'Community Detox' limit 1];
			stabilisationCourse = [select ID from ecass01__Program_Service__c where ecass01__Course_Type__c = 'Stabilisation' limit 1];
		}
		catch (Exception e)
		{
//			newList[0].addError ('Stabilisation and Community Detox groups need to be created before clients can be added: ' + e.getMessage());
			return;
		}

		List <ecass01__Enrolment__c> newEnrolments = new List<ecass01__Enrolment__c>();
		List <ecass01__Enrolment__c> enrolmentstoDelete = new List<ecass01__Enrolment__c>();
		
		Map <ID, ecass01__Enrolment__c> mapClientToCurrentDetoxEnrolment = new Map <ID, ecass01__Enrolment__c>();
		for (ecass01__Enrolment__c oneEnrol: [select ID, ecass01__Young_Person__c from ecass01__Enrolment__c where ecass01__Young_Person__c in :newMap.keySet() and ecass01__Program_Service__c = :detoxCourse.id])
			mapClientToCurrentDetoxEnrolment.put (oneEnrol.ecass01__Young_Person__c, oneEnrol);
		
		Map <ID, ecass01__Enrolment__c> mapClientToCurrentStabilisationEnrolment = new Map <ID, ecass01__Enrolment__c>();
		for (ecass01__Enrolment__c oneEnrol: [select ID, ecass01__Young_Person__c from ecass01__Enrolment__c where ecass01__Young_Person__c in :newMap.keySet() and ecass01__Program_Service__c = :stabilisationCourse.id])
			mapClientToCurrentStabilisationEnrolment.put (oneEnrol.ecass01__Young_Person__c, oneEnrol);
	
		for (Contact oneClient : newList)
		{
			try
			{
				if (oneClient.Community_Detox_group_status__c == 'Joined Group' && mapClientToCurrentDetoxEnrolment.get(oneClient.ID) == null)
					newEnrolments.add (new ecass01__Enrolment__c (ecass01__Young_Person__c=oneClient.id, ecass01__Program_Service__c=detoxCourse.id));
				else if (oneClient.Community_Detox_group_status__c == 'Left Group' && mapClientToCurrentDetoxEnrolment.get(oneClient.ID) != null)
					enrolmentstoDelete.add (mapClientToCurrentDetoxEnrolment.get(oneClient.ID));
			}
			catch (Exception e)
			{
				oneClient.Community_Detox_group_status__c.addError ('Error adding or removing the client from the Community Detox group: ' + e.getMessage());
			}
			
			try
			{
				if (oneClient.Stabilisation_Group_status__c == 'Admitted' && mapClientToCurrentStabilisationEnrolment.get(oneClient.ID) == null)
					newEnrolments.add (new ecass01__Enrolment__c (ecass01__Young_Person__c=oneClient.id, ecass01__Program_Service__c=stabilisationCourse.id));
				else if (oneClient.Stabilisation_Group_status__c == 'Departed' && mapClientToCurrentStabilisationEnrolment.get(oneClient.ID) != null)
					enrolmentstoDelete.add (mapClientToCurrentStabilisationEnrolment.get(oneClient.ID));
			}
			catch (Exception e)
			{
				oneClient.Stabilisation_Group_status__c.addError ('Error adding or removing the client from the Stabilisation group: ' + e.getMessage());
			}
		}		
			 
		if (newEnrolments.size() > 0) insert newEnrolments;
		if (enrolmentstoDelete.size() > 0) delete enrolmentstoDelete;
	}
	
	public static void createTestObjects ()
	{
		ecass01__Program_Service__c detoxCourse = new ecass01__Program_Service__c (Name='Course1', ecass01__Course_Type__c = 'Community Detox');
		insert detoxCourse;
		ecass01__Program_Service__c stabilisationCourse = new ecass01__Program_Service__c (Name='Course2', ecass01__Course_Type__c = 'Stabilisation');
		insert stabilisationCourse;
		
		ID clientRecordTypeID = [select id from RecordType where Name = 'Open Access Client' limit 1].id;
		for (integer i=1; i<=5; i++)
		{
			Contact client = new Contact (Lastname='test'+i, BirthDate=Date.newInstance(1990, 2, i), Gender__c='Male', RecordTypeID=clientRecordTypeID);
			insert client;
		}
		
	}
	
	static testMethod void testAddContacts ()
	{
		ClientTriggerClass.createTestObjects ();
	}

	static testMethod void testUpdateStabilisationContacts ()
	{
		ClientTriggerClass.createTestObjects ();
		Map<ID, Contact> currentClients = new Map<ID, Contact>([select ID from Contact]);
		for (Contact oneClient: currentClients.values())
		{
			oneClient.Stabilisation_Group_status__c = 'Admitted';
		}
		update currentClients.values();
		
		List<ecass01__Enrolment__c> enrolments = [select ID from ecass01__Enrolment__c where ecass01__Young_Person__c in :currentClients.keySet()];
		system.assert (enrolments.size() > 0);

		for (Contact oneClient: currentClients.values())
		{
			oneClient.Stabilisation_Group_status__c = 'Departed';
		}
		update currentClients.values();
		
		enrolments = [select ID from ecass01__Enrolment__c where ecass01__Young_Person__c in :currentClients.keySet()];
		system.assert (enrolments.size() == 0);
	}
	
	static testMethod void testUpdateDetoxContacts ()
	{
		ClientTriggerClass.createTestObjects ();
		Map<ID, Contact> currentClients = new Map<ID, Contact>([select ID from Contact]);
		for (Contact oneClient: currentClients.values())
		{
			oneClient.Community_Detox_group_status__c = 'Joined Group';
		}
		update currentClients.values();
		
		List<ecass01__Enrolment__c> enrolments = [select ID from ecass01__Enrolment__c where ecass01__Young_Person__c in :currentClients.keySet()];
		system.assert (enrolments.size() > 0);

		for (Contact oneClient: currentClients.values())
		{
			oneClient.Community_Detox_group_status__c = 'Left Group';
		}
		update currentClients.values();
		
		enrolments = [select ID from ecass01__Enrolment__c where ecass01__Young_Person__c in :currentClients.keySet()];
		system.assert (enrolments.size() == 0);
	}
*/	
}