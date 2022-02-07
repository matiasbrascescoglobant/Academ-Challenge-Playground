import { LightningElement } from 'lwc';

export default class EnterAddress extends LightningElement {

    value = '';
    billingAddressChecked = false;

    get options() {
        return [
            { label: 'BillingAddress', value: 'BillingAddress' },
            { label: 'ShippingAddress', value: 'ShippingAddress' },
        ];
    }

    handleChange(event) {
        if(event.detail.value === 'BillingAddress') {
            this.billingAddressChecked = true;
        } else {
            this.billingAddressChecked = false;
        }
    }

}