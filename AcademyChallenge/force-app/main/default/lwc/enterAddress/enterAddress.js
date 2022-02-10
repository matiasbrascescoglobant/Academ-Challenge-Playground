import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, updateRecord } from 'lightning/uiRecordApi';

import updateAccountAddress from '@salesforce/apex/ViacepController.updateAccountAddress';
import ID_FIELD from '@salesforce/schema/Account.Id';
import BILLING_POSTAL_CODE_FIELD from '@salesforce/schema/Account.BillingPostalCode';
import BILLING_STREET_FIELD from '@salesforce/schema/Account.BillingStreet';
import BILLING_CITY_FIELD from '@salesforce/schema/Account.BillingCity';
import BILLING_STATE_FIELD from '@salesforce/schema/Account.BillingState';
import SHIPPING_POSTAL_CODE_FIELD from '@salesforce/schema/Account.ShippingPostalCode';
import SHIPPING_STREET_FIELD from '@salesforce/schema/Account.ShippingStreet';
import SHIPPING_CITY_FIELD from '@salesforce/schema/Account.ShippingCity';
import SHIPPING_STATE_FIELD from '@salesforce/schema/Account.ShippingState';

const accountFields = [
	ID_FIELD,
	BILLING_POSTAL_CODE_FIELD,
	BILLING_STREET_FIELD,
    BILLING_CITY_FIELD,
    BILLING_STATE_FIELD,
    SHIPPING_POSTAL_CODE_FIELD,
    SHIPPING_STREET_FIELD,
    SHIPPING_CITY_FIELD,
    SHIPPING_STATE_FIELD
];

export default class EnterAddress extends LightningElement {

    @api recordId;
    @track account;
    @track isLoading = false;
    value = '';
    billingAddressChecked = true;
    error = '';

    get options() {
        return [
            { label: 'BillingAddress', value: 'BillingAddress'},
            { label: 'ShippingAddress', value: 'ShippingAddress' },
        ];
    }

    @wire(getRecord, { recordId: '$recordId', fields: accountFields })
    getaccountRecord({ data, error }) {
        if (data) {
            this.account = data;
        } else if (error) {
            console.error('ERROR => ', JSON.stringify(error));
        }
    }

    handleChange(event) {
        if(event.detail.value === 'BillingAddress') {
            this.billingAddressChecked = true;
        } else {
            this.billingAddressChecked = false;
        }
    }

    handleCepBlur(event) {
        this.isLoading = true;
        updateAccountAddress({accId: this.recordId, cep: event.target.value, isBillingAddress: this.billingAddressChecked})
        .then(() => {
            this.error = undefined;

            const fieldsInput = {};

            fieldsInput[ID_FIELD.fieldApiName] = this.recordId;

            const recordInput = {
                fields: fieldsInput
            };

            updateRecord(recordInput).then(() => {
                this.isLoading = false;    
            });
            
        })
        .catch(error => {
            this.error = error;
            this.isLoading = false;
        });
    }
}