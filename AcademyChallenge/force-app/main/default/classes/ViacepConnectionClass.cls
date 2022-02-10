public with sharing class ViacepConnectionClass {
    
    public static Map<String, Object> getAddress(String cep) {
        if(!validationCep(cep)) return null;
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('http://viacep.com.br/ws/'+ cep +'/json/');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200) {
            return (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        }

        return new Map<String, Object>();
    }

    private static boolean validationCep(String cep) {
        if(cep == null) return false;
        
        return Pattern.matches('\\d{8}', cep);
    }

    
}
