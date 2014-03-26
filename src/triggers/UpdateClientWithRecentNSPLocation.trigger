trigger UpdateClientWithRecentNSPLocation on Needle_Exchange__c (after insert) 
{
	// update the number of interventions on the client
	Set<id> clientIds = new Set<Id>();
	for (Needle_Exchange__c oneIntervention: Trigger.new)
	{
		if (oneIntervention.Client__c != null) clientIds.Add (oneIntervention.Client__c);
	}
	Map <ID, Contact> clients = new Map<ID, Contact>([select id, Last_NSP_Intervention__c from Contact where id in :clientIds]);

	for (Needle_Exchange__c oneIntervention: Trigger.new)
	{
		if (oneIntervention.Client__c != null && oneIntervention.Location__c != null)
		{
			Contact client = clients.get(oneIntervention.Client__c);
			if (client != null)
			{
				client.Last_NSP_Intervention__c = oneIntervention.Location__c;
			}
		}
	}
	update clients.values();
}