trigger UpdateStockWhenNeedlesExchanged on Needle_Exchange__c (after insert, after update) 
{
	// use oldMap to distinguish 
	Needle_Exchange__c lastExchange=null;
	for (Needle_Exchange__c oneExchange: Trigger.New)
	{
		try
		{
			String location=null;
			if (oneExchange.Location__c == 'Dublin') 
				location = 'Dublin';
			else if (oneExchange.Location__c == 'Cavan' || oneExchange.Location__c == 'Louth' || oneExchange.Location__c == 'Meath'|| oneExchange.Location__c == 'Monaghan')
				location = 'North East';
			else if (oneExchange.Location__c == 'Westmeath' || oneExchange.Location__c == 'Offaly' || oneExchange.Location__c == 'Longford' || oneExchange.Location__c == 'Laois' )
				location = 'Mullingar';
			else if (oneExchange.Location__c == 'Limerick')
				location = 'Limerick';
			else if (oneExchange.Location__c == 'Limerick City' || oneExchange.Location__c == 'Limerick County' || oneExchange.Location__c == 'North Tipperary' || oneExchange.Location__c == 'Clare')
       			location = 'Limerick';
			else location = oneExchange.Location__c; // to try and cover new locations
			
			Needle_Syringe_Stock__c stock = [Select X1ml_Diabetic__c, X1ml_Filter__c, X1ml_Nevershare__c, X1ml_Omnifix__c, X2ml_Green__c, X2ml_Never_Share_Syringe__c,
				X2ml_Orange__c, X2ml_Syringe__c, X5ml_Syringe__c, Baby_Brown__c, Bins__c, Blue__c, Brown__c, Citric__c, Condoms__c, Green__c, Orange__c, Long_Orange__c, Grey__c, Pipes__c,
				Stericups__c, Swabs__c, Tooters__c, Tourniquet__c, VitC__c, Water__c, X1ml_Low_Dead_Space__c, X1ml_Saline__c, Foil_x_20__c, Foil_x_50__c,
				Blunt_Needle__c, Bang_it_and_bin_it_stickers__c, Cleaning_Works__c, Groin_FI__c, HEP_C__c, Safer_Injecting_Handbook__c, Safer_Injecting_MQI__c, Staying_Alive__c, Vein_Care_booklet__c,
				Vein_Care_card__c, When_Things_Go_Wrong__c, Overdose_Card__c
			 from Needle_Syringe_Stock__c where Name = :location limit 1];
			 
			if (Trigger.isUpdate)
			{
				lastExchange = Trigger.oldMap.get (oneExchange.id); 
			}
			else lastExchange = null;
			
			if (stock.X1ml_Diabetic__c == null) stock.X1ml_Diabetic__c = 0;
			stock.X1ml_Diabetic__c -= UpdateStock (oneExchange, lastExchange, 'X1ml_Diabetic_Dispensed__c');
			
			if (stock.X1ml_Filter__c == null) stock.X1ml_Filter__c = 0;
			stock.X1ml_Filter__c -= UpdateStock (oneExchange, lastExchange, 'X1ml_Filter_Dispensed__c');
			
			if (stock.X1ml_Nevershare__c == null) stock.X1ml_Nevershare__c = 0;
			stock.X1ml_Nevershare__c -= UpdateStock (oneExchange, lastExchange, 'X1ml_Nevershare_Dispensed__c'); 
			
			if (stock.X1ml_Low_Dead_Space__c == null) stock.X1ml_Low_Dead_Space__c = 0;
			stock.X1ml_Low_Dead_Space__c -= UpdateStock (oneExchange, lastExchange, 'X1ml_Low_Dead_Space_Dispensed__c'); 
			
			if (stock.X1ml_Omnifix__c == null) stock.X1ml_Omnifix__c = 0;
			stock.X1ml_Omnifix__c -= UpdateStock (oneExchange, lastExchange, 'X1ml_Omnifix_Dispensed__c'); 
			
			if (stock.X2ml_Green__c == null) stock.X2ml_Green__c = 0;
			stock.X2ml_Green__c -= UpdateStock (oneExchange, lastExchange, 'X2ml_Green_Dispensed__c'); 
			
			if (stock.X2ml_Never_Share_Syringe__c == null) stock.X2ml_Never_Share_Syringe__c = 0;
			stock.X2ml_Never_Share_Syringe__c -= UpdateStock (oneExchange, lastExchange, 'X2ml_Never_Share_Syringe_Dispensed__c'); 
			
			if (stock.X2ml_Orange__c == null) stock.X2ml_Orange__c = 0;
			stock.X2ml_Orange__c -= UpdateStock (oneExchange, lastExchange, 'X2ml_Orange_Dispensed__c'); 
			
			if (stock.X2ml_Syringe__c == null) stock.X2ml_Syringe__c = 0;
			stock.X2ml_Syringe__c -= UpdateStock (oneExchange, lastExchange, 'X2ml_Syringe_Dispensed__c'); 
			
			if (stock.X5ml_Syringe__c == null) stock.X5ml_Syringe__c = 0;
			stock.X5ml_Syringe__c -= UpdateStock (oneExchange, lastExchange, 'X5ml_Syringe_Dispensed__c'); 
			
			if (stock.Baby_Brown__c == null) stock.Baby_Brown__c = 0;
			stock.Baby_Brown__c -= UpdateStock (oneExchange, lastExchange, 'Baby_Brown_Dispensed__c'); 
			
			if (stock.Bins__c == null) stock.Bins__c = 0;
			stock.Bins__c -= UpdateStock (oneExchange, lastExchange, 'Bins_Dispensed__c'); 
			
			if (stock.Blue__c == null) stock.Blue__c = 0;
			stock.Blue__c -= UpdateStock (oneExchange, lastExchange, 'Blue_Dispensed__c'); 
			
			if (stock.Grey__c == null) stock.Grey__c = 0;
			stock.Grey__c -= UpdateStock (oneExchange, lastExchange, 'Grey_Dispensed__c'); 

			if (stock.Brown__c == null) stock.Brown__c = 0;
			stock.Brown__c -= UpdateStock (oneExchange, lastExchange, 'Brown_Dispensed__c'); 
			
			if (stock.Citric__c == null) stock.Citric__c = 0;
			stock.Citric__c -= UpdateStock (oneExchange, lastExchange, 'Citric_Dispensed__c'); 
			
			if (stock.Condoms__c == null) stock.Condoms__c = 0;
			stock.Condoms__c -= UpdateStock (oneExchange, lastExchange, 'Condoms_Dispensed__c'); 
			
			if (stock.Foil_x_20__c == null) stock.Foil_x_20__c = 0;
			stock.Foil_x_20__c -= UpdateStock (oneExchange, lastExchange, 'Foil_x_20__c'); 
			
			if (stock.Foil_x_50__c == null) stock.Foil_x_50__c = 0;
			stock.Foil_x_50__c -= UpdateStock (oneExchange, lastExchange, 'Foil_x_50__c'); 
			
			if (stock.X1ml_Saline__c == null) stock.X1ml_Saline__c = 0;
			stock.X1ml_Saline__c -= UpdateStock (oneExchange, lastExchange, 'X1ml_Saline__c'); 
			
			if (stock.Green__c == null) stock.Green__c = 0;
			stock.Green__c -= UpdateStock (oneExchange, lastExchange, 'Green_Dispensed__c'); 
			
			if (stock.Orange__c == null) stock.Orange__c = 0;
			stock.Orange__c -= UpdateStock (oneExchange, lastExchange, 'Orange_Dispensed__c'); 
			
			if (stock.Long_Orange__c == null) stock.Long_Orange__c = 0;
			stock.Long_Orange__c -= UpdateStock (oneExchange, lastExchange, 'Long_Orange_Dispensed__c'); 
			
			if (stock.Pipes__c == null) stock.Pipes__c = 0;
			stock.Pipes__c -= UpdateStock (oneExchange, lastExchange, 'Pipes_Dispensed__c'); 
			
			if (stock.Stericups__c == null) stock.Stericups__c = 0;
			stock.Stericups__c -= UpdateStock (oneExchange, lastExchange, 'Stericups_Dispensed__c'); 
			
			if (stock.Swabs__c == null) stock.Swabs__c = 0;
			stock.Swabs__c -= UpdateStock (oneExchange, lastExchange, 'Swabs_Dispensed__c'); 
			
			if (stock.Tooters__c == null) stock.Tooters__c = 0;
			stock.Tooters__c -= UpdateStock (oneExchange, lastExchange, 'Tooters_Dispensed__c'); 
			
			if (stock.Tourniquet__c == null) stock.Tourniquet__c = 0;
			stock.Tourniquet__c -= UpdateStock (oneExchange, lastExchange, 'Tourniquet_Dispensed__c'); 
			
			if (stock.VitC__c == null) stock.VitC__c = 0;
			stock.VitC__c -= UpdateStock (oneExchange, lastExchange, 'Vit_C_Dispensed__c'); 
			
			if (stock.Water__c == null) stock.Water__c = 0;
			stock.Water__c -= UpdateStock (oneExchange, lastExchange, 'Water_Dispensed__c'); 
	
	// Leaflets
			if (stock.Blunt_Needle__c == null) stock.Blunt_Needle__c = 0;
			stock.Blunt_Needle__c -= UpdateStockBoolean (oneExchange, lastExchange, 'Blunt_Needle__c');
			
			if (stock.Cleaning_Works__c == null) stock.Cleaning_Works__c = 0;
			stock.Cleaning_Works__c -= UpdateStockBoolean (oneExchange, lastExchange, 'Cleaning_Works__c');

			if (stock.Groin_FI__c == null) stock.Groin_FI__c = 0;
			stock.Groin_FI__c -= UpdateStockBoolean (oneExchange, lastExchange, 'Groin_Femoral_Injecting__c');

			if (stock.HEP_C__c == null) stock.HEP_C__c = 0;
			stock.HEP_C__c -= UpdateStockBoolean (oneExchange, lastExchange, 'HEP_C__c');

			if (stock.Safer_Injecting_Handbook__c == null) stock.Safer_Injecting_Handbook__c = 0;
			stock.Safer_Injecting_Handbook__c -= UpdateStockBoolean (oneExchange, lastExchange, 'Safer_Injecting_Handbook__c');

			if (stock.Safer_Injecting_MQI__c == null) stock.Safer_Injecting_MQI__c = 0;
			stock.Safer_Injecting_MQI__c -= UpdateStockBoolean (oneExchange, lastExchange, 'Safer_Injecting_Guide_MQI__c');

			if (stock.Staying_Alive__c == null) stock.Staying_Alive__c = 0;
			stock.Staying_Alive__c -= UpdateStockBoolean (oneExchange, lastExchange, 'Staying_Alive__c');

			if (stock.Vein_Care_booklet__c == null) stock.Vein_Care_booklet__c = 0;
			stock.Vein_Care_booklet__c -= UpdateStockBoolean (oneExchange, lastExchange, 'Vein_Care_booklet__c');

			if (stock.Vein_Care_card__c == null) stock.Vein_Care_card__c = 0;
			stock.Vein_Care_card__c -= UpdateStockBoolean (oneExchange, lastExchange, 'Vein_Care_card__c');

			if (stock.When_Things_Go_Wrong__c == null) stock.When_Things_Go_Wrong__c = 0;
			stock.When_Things_Go_Wrong__c -= UpdateStockBoolean (oneExchange, lastExchange, 'When_Things_Go_Wrong__c');

			if (stock.Overdose_Card__c == null) stock.Overdose_Card__c = 0;
			stock.Overdose_Card__c -= UpdateStockBoolean (oneExchange, lastExchange, 'Overdose_General__c');

			if (stock.Bang_it_and_bin_it_stickers__c == null) stock.Bang_it_and_bin_it_stickers__c = 0;
			stock.Bang_it_and_bin_it_stickers__c -= UpdateStockBoolean (oneExchange, lastExchange, 'Bang_it_and_bin_it_stickers__c');
			update stock;
		}
		catch (Exception e)
		{
			trigger.newMap.get(oneExchange.id).Location__c.addError ('Failed to update the stock for ' + oneExchange.Location__c + ' check the location matches the stock location');
		}
	}
	
	public Decimal UpdateStockBoolean (sObject thisExchange, sObject oldExchange, String fieldName)
	{
		Integer oldValue = 0;
		Integer newValue = 0;
		if (isValid (thisExchange, fieldName)) newValue = (Boolean)thisExchange.get(fieldName) ? 1:0;
		if (isValid (oldExchange, fieldName)) oldValue = (Boolean)oldExchange.get(fieldName) ? 1:0;
		return newValue - oldValue;
	}
	
	public Decimal UpdateStock (sObject thisExchange, sObject oldExchange, String fieldName)
	{
		if (isValid (thisExchange, fieldName)) 
			if (isValid (oldExchange, fieldName)) return (Decimal)thisExchange.get(fieldName) - (Decimal)oldExchange.get(fieldName);
			else return (Decimal)thisExchange.get(fieldName);
		else if (isValid (oldExchange, fieldName)) return - (Decimal)oldExchange.get(fieldName);
			else return 0;
	}

	public Boolean isValid (sObject dispensed, String fieldName)
	{
		if (dispensed == null || dispensed.get(fieldName) == null)
		{
			return false;
		}
		else
		{
			return true;
		}
	}
}