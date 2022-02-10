public with sharing class ValidationCNPJClass {
    public static boolean isCNPJ(String CNPJ) {
    
        if(CNPJ == null) return false;
        
        CNPJ = CNPJ.replace('.','').replace('/','').replace('-','');
        
        if (CNPJ.equals('00000000000000') || CNPJ.equals('11111111111111') ||
            CNPJ.equals('22222222222222') || CNPJ.equals('33333333333333') ||
            CNPJ.equals('44444444444444') || CNPJ.equals('55555555555555') ||
            CNPJ.equals('66666666666666') || CNPJ.equals('77777777777777') ||
            CNPJ.equals('88888888888888') || CNPJ.equals('99999999999999') ||
            (CNPJ.length() != 14))
            return false;

        Integer sum, i, rest, num, weight, dig13, dig14;
        List<String> digitList = CNPJ.split('');
        
        sum = 0;
        weight = 2;
        for (i=11; i>=0; i--) {
            num = Integer.valueOf(digitList[i]);
            sum = sum + (num * weight);
            weight = weight + 1;
            if (weight == 10)
                weight = 2;
        }
        
        rest = math.mod(sum, 11);
        if ((rest == 0) || (rest == 1))
            dig13 = 0;
        else 
            dig13 = Integer.valueOf(11-rest);
        
        sum = 0;
        weight = 2;
        for (i=12; i>=0; i--) {
            num = Integer.valueOf(digitList[i]);
            sum = sum + (num * weight);
            weight = weight + 1;
            if (weight == 10)
                weight = 2;
        }
        
        rest = math.mod(sum, 11);
        if ((rest == 0) || (rest == 1))
            dig14 = 0;
        else 
            dig14 = Integer.valueOf(11-rest);
        
        if (dig13 == Integer.valueOf(digitList[12]) && dig14 == Integer.valueOf(digitList[13]))
            return true;
        else 
            return false;
    }
    
    public static boolean validateFormatCNPJ(String CNPJ) {   
        
        if(CNPJ == null) return false;
        
        return Pattern.matches('^(\\d{2}\\.\\d{3}\\.\\d{3}/\\d{4}\\-\\d{2})?$', CNPJ);
    }

    public static boolean existCNPJ(Account acc, List<Account> accountList) {   
        
        if(acc.CNPJ__c == null) return false;
        
        for(Account a : accountList) {
            if(a.CNPJ__c != null && acc.Id != a.Id && a.CNPJ__c.equals(acc.CNPJ__c)) {
                return true;
            }
        }

        return false;
    }
}