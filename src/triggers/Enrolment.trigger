trigger Enrolment on ecass01__Enrolment__c (after insert, after update) 
{
	EnrolmentTriggerClass gnci = new EnrolmentTriggerClass ();
	gnci.MainEntry (trigger.isBefore, trigger.isDelete, trigger.isAfter, trigger.isInsert, trigger.isUpdate, trigger.isExecuting,
		trigger.new, trigger.newMap, trigger.old, trigger.oldMap);
}