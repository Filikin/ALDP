trigger SynchGenderWithClient on Needle_Exchange__c (before insert, before update) 
{
	/*
	Set<id> clientIds = new Set<Id>();
	for (Needle_Exchange__c oneIntervention: Trigger.new)
	{
		if (oneIntervention.Client__c != null) clientIds.Add (oneIntervention.Client__c);
	}
	Map <ID, Contact> clients = new Map<ID, Contact>([select id, Name, Gender__c, Number_of_NSP_Interventions__c from Contact where id in :clientIds]);
	for (Needle_Exchange__c oneIntervention: Trigger.new)
	{
		if (oneIntervention.Client__c != null) 
		{
			Contact client = clients.get(oneIntervention.Client__c);
			if (client != null)
			{
				oneIntervention.Gender__c = client.Gender__c;
			}
		}
	}
	*/
}