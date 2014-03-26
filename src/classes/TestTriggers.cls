@isTest
private class TestTriggers 
{
	/*
		createTestObjects(); needs to go before each test so that the courses are created before the clients
	*/
	
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
	
    static testMethod void updateStockTest() 
    {
    	createTestObjects();
    	
    	Needle_Syringe_Stock__c testStock = new Needle_Syringe_Stock__c (Name='Dublin', X1ml_Diabetic__c=100, X1ml_Filter__c=100);
    	insert testStock;
    	
     	Contact client = new Contact (LastName = 'Fred', Gender__c = 'Male');
    	insert client;
 
     	Needle_Exchange__c intervention1 = new Needle_Exchange__c (Client__c=client.id, Date_Exchange__c = system.today(), Location__c='Dublin', X1ml_Filter_Dispensed__c=5);
		insert intervention1;

		testStock = [select id, X1ml_Filter__c from Needle_Syringe_Stock__c where id=:testStock.id];
		System.assertEquals(95, testStock.X1ml_Filter__c);
				
		intervention1.X1ml_Diabetic_Dispensed__c = 10;
		update intervention1;
		
		testStock = [select id, X1ml_Filter__c, X1ml_Diabetic__c from Needle_Syringe_Stock__c where id=:testStock.id];
		
		System.assertEquals(95, testStock.X1ml_Filter__c);
		System.assertEquals(90, testStock.X1ml_Diabetic__c);
		
		client = [select Last_NSP_Intervention__c from Contact where id=:client.Id];
		System.assertEquals('Dublin', client.Last_NSP_Intervention__c);
    }

    static testMethod void Low_Dead_SpaceStockTest() 
    {
    	createTestObjects();

    	Needle_Syringe_Stock__c testStock = new Needle_Syringe_Stock__c (Name='Dublin', X1ml_Low_Dead_Space__c=601);
    	insert testStock;
    	
     	Contact client = new Contact (LastName = 'Fred', Gender__c = 'Male');
    	insert client;
 
     	Needle_Exchange__c intervention1 = new Needle_Exchange__c (Client__c=client.id, Date_Exchange__c = system.today(), Location__c='Dublin', X1ml_Low_Dead_Space_Dispensed__c=5);
		insert intervention1;

		testStock = [select id, X1ml_Low_Dead_Space__c from Needle_Syringe_Stock__c where id=:testStock.id];
		System.assertEquals(596, testStock.X1ml_Low_Dead_Space__c);
    }

    static testMethod void SalineTest() 
    {
    	createTestObjects();

    	Needle_Syringe_Stock__c testStock = new Needle_Syringe_Stock__c (Name='Dublin', X1ml_Saline__c=15);
    	insert testStock;
    	
     	Contact client = new Contact (LastName = 'Fred', Gender__c = 'Male');
    	insert client;
 
     	Needle_Exchange__c intervention1 = new Needle_Exchange__c (Client__c=client.id, Date_Exchange__c = system.today(), Location__c='Dublin', X1ml_Saline__c=10);
		insert intervention1;

		testStock = [select id, X1ml_Saline__c from Needle_Syringe_Stock__c where id=:testStock.id];
		System.assertEquals(5, testStock.X1ml_Saline__c);
    }

    static testMethod void CondomsFoilTest() 
    {
    	createTestObjects();

    	Needle_Syringe_Stock__c testStock = new Needle_Syringe_Stock__c (Name='Dublin', Foil_x_20__c=15, Foil_x_50__c=25);
    	insert testStock;
    	
     	Contact client = new Contact (LastName = 'Fred', Gender__c = 'Male');
    	insert client;
 
     	Needle_Exchange__c intervention1 = new Needle_Exchange__c (Client__c=client.id, Date_Exchange__c = system.today(), Location__c='Dublin', Foil_x_20__c=10, Foil_x_50__c=1);
		insert intervention1;

		testStock = [select id, Foil_x_20__c, Foil_x_50__c from Needle_Syringe_Stock__c where id=:testStock.id];
		System.assertEquals(24, testStock.Foil_x_50__c);
		System.assertEquals(5, testStock.Foil_x_20__c);
    }

    static testMethod void LeafletsTest() 
    {
     	createTestObjects();
 
    	Needle_Syringe_Stock__c testStock = new Needle_Syringe_Stock__c (Name='Dublin', Blunt_Needle__c=10, Bang_it_and_bin_it_stickers__c=11);
    	insert testStock;
    	
     	Contact client = new Contact (LastName = 'Fred', Gender__c = 'Male');
    	insert client;
 
     	Needle_Exchange__c intervention1 = new Needle_Exchange__c (Client__c=client.id, Date_Exchange__c = system.today(), Location__c='Dublin', Blunt_Needle__c=true, Bang_it_and_bin_it_stickers__c=true);
		insert intervention1;

		testStock = [select id, Blunt_Needle__c, Bang_it_and_bin_it_stickers__c from Needle_Syringe_Stock__c where id=:testStock.id];
		System.assertEquals(9, testStock.Blunt_Needle__c);
		System.assertEquals(10, testStock.Bang_it_and_bin_it_stickers__c);
    }
 }