@isTest
private class TestEnrolmentTriggers {

	public static testMethod void createTestObjects ()
	{
		ecass01__Program_Service__c detoxCourse = new ecass01__Program_Service__c (Name='Course1', ecass01__Course_Type__c = 'Community Detox');
		insert detoxCourse;
		ecass01__Program_Service__c stabilisationCourse = new ecass01__Program_Service__c (Name='Course2', ecass01__Course_Type__c = 'Stabilisation');
		insert stabilisationCourse;

		list <ecass01__Enrolment__c> enrolments = new list <ecass01__Enrolment__c>();		
		ID clientRecordTypeID = [select id from RecordType where Name = 'Open Access Client' limit 1].id;
		for (integer i=1; i<=5; i++)
		{
			Contact client = new Contact (Lastname='test'+i, BirthDate=Date.newInstance(1990, 2, i), Gender__c='Male', RecordTypeID=clientRecordTypeID);
			insert client;
			ecass01__Enrolment__c enrolstab = new ecass01__Enrolment__c (ecass01__Young_Person__c = client.id, ecass01__Date_joined_program__c=system.today(), ecass01__Program_Service__c=stabilisationCourse.id, ecass01__Status_on_Programme__c='Active');
			enrolments.add (enrolstab); 
			ecass01__Enrolment__c enroldetox = new ecass01__Enrolment__c (ecass01__Young_Person__c = client.id, ecass01__Date_joined_program__c=system.today(), ecass01__Program_Service__c=detoxCourse.id, ecass01__Status_on_Programme__c='Active');
			enrolments.add(enroldetox);
		}
		insert enrolments;
		
		// for one client, check that changing the status to 'Admitted to Coolmine' causes the Date_admitted_to_stabilisation_group__c to change to today
		ecass01__Enrolment__c oneE = enrolments[0];
		oneE.ecass01__Status_on_Programme__c = 'Admitted to Coolmine';
		update oneE;
		
		Contact oneC = [select ID, Date_admitted_to_stabilisation_group__c from Contact where ID = :oneE.ecass01__Young_Person__c];
		system.assertEquals (system.today(), oneC.Date_admitted_to_stabilisation_group__c);
	}
}