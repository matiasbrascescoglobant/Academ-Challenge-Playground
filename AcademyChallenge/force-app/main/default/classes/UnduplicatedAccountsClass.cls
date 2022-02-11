global class UnduplicatedAccountsClass implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
        Map<String,Datetime> cnpjLastModifiedMap = new Map<String,Datetime>();

		AggregateResult[] groupedResults = 
            [SELECT CNPJ__c, MAX(LastModifiedDate)
             FROM Account
             WHERE CNPJ__c <> ''
             GROUP BY CNPJ__c
             HAVING COUNT(Id) > 1];
System.debug(groupedResults.size());
        if(groupedResults.size() == 0) return;
System.debug('HAY CNPJ DUPLIADOS!!!');
		for (AggregateResult ar : groupedResults) {
            cnpjLastModifiedMap.put(String.valueOf(ar.get('CNPJ__c')), Datetime.valueOf(ar.get('expr0')));
        }

        List<Account> accList = new List<Account>();
		String currentCNPJ = '';
        for(Account acc : [SELECT Id, CNPJ__c, LastModifiedDate
                            FROM Account 
                            WHERE CNPJ__c <> '' 
                            ORDER BY CNPJ__c]) {                                             
            if(acc.LastModifiedDate == cnpjLastModifiedMap.get(acc.CNPJ__c)) {
                if(acc.CNPJ__c == currentCNPJ) {
                    accList.add(acc);
                } else {
                    currentCNPJ = acc.CNPJ__c;
                }
            } else {
                accList.add(acc);
            }
        }

        delete accList;
    }
}
