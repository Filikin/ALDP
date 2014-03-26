trigger UpdateClientNSPInterventionCount on Needle_Exchange__c (after insert, after update) 
{
	/*
	// update the number of interventions on the client
	Set<id> clientIds = new Set<Id>();
	for (Needle_Exchange__c oneIntervention: Trigger.new)
	{
		if (oneIntervention.Client__c != null) clientIds.Add (oneIntervention.Client__c);
	}
	Map <ID, Contact> clients = new Map<ID, Contact>([select id, Name, Gender__c, Number_of_NSP_Interventions__c from Contact where id in :clientIds]);

	List<Contact> clientsUpdated = new List<Contact>();
	List<aggregateResult> results = [select Client__c, count(ID) interventions from Needle_Exchange__c where client__c in :clientIds group by Client__c];
	for (aggregateResult ar : results)
	{
		ID clientID = (ID)ar.get('Client__c');
		if (clientID != null)
		{
			Contact client = clients.get(clientID);
			if (client != null)
			{
				client.Number_of_NSP_Interventions__c = (Integer)ar.get('interventions');
				clientsUpdated.add(client);
			}
		}
	}
	if (clientsUpdated.size() > 0)
	{
		update clientsUpdated;
	}
	*/
}