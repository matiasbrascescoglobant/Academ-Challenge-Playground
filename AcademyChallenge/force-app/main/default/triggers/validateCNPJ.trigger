trigger validateCNPJ on Account (before insert, before update) {

    List<Account> accountList = [SELECT Id, CNPJ__c FROM Account WHERE CNPJ__c <> null];

    for(Account a : Trigger.New) {
        if(!ValidationCNPJClass.validateFormatCNPJ(a.CNPJ__c)) {
            a.addError('CNPJ must have the following format 99.999.999/9999-99');
        } else if(!ValidationCNPJClass.isCNPJ(a.CNPJ__c)) {
            a.addError('Invalid CNPJ, please enter another.');
        } else if(ValidationCNPJClass.existCNPJ(a, accountList)) {
            a.addError('CNPJ aready exists, please enter another.');
        }
    } 
}