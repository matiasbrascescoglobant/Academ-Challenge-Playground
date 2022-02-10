public with sharing class ViacepController {
    
    @AuraEnabled
    public static void updateAccountAddress(ID accId, String cep, boolean isBillingAddress) {

        Account acc = getSingleAccount(accId);

        Map<String,Object> result = ViacepConnectionClass.getAddress(cep);

        if(result == null) {
            throw new HandledException('Invalid cep format, must be 8 digits, please enter another.');
        } else if(result.get('erro') != null && String.valueOf(result.get('erro')).trim().equals('true')) {
            throw new HandledException('Cep not found, please enter another.');
        } else if(result.get('cep') != null) {
            updateAddress(acc, result, isBillingAddress);
        } else {
            throw new HandledException('Internal server error.');
        }
    }

    private static Account getSingleAccount(ID aId) {
        return [
            SELECT Id, Name, 
            BillingPostalCode, BillingStreet, BillingCity, BillingState,
            ShippingPostalCode, ShippingStreet, ShippingCity, ShippingState
            FROM Account
            WHERE Id=:aId
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];
    }

    private static void updateAddress(Account a, Map<String,Object> result, boolean isBillingAddress) {
        if(isBillingAddress) {
            a.BillingPostalCode = String.valueOf(result.get('cep'));
            a.BillingStreet = String.valueOf(result.get('logradouro'));
            a.BillingCity = String.valueOf(result.get('localidade'));
            a.BillingState = String.valueOf(result.get('uf'));
        } else {
            a.ShippingPostalCode = String.valueOf(result.get('cep'));
            a.ShippingStreet = String.valueOf(result.get('logradouro'));
            a.ShippingCity = String.valueOf(result.get('localidade'));
            a.ShippingState = String.valueOf(result.get('uf'));
        }

        update a;
    }

}
