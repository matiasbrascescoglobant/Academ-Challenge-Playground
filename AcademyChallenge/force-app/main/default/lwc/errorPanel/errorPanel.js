import { LightningElement, api } from 'lwc';
import { reduceErrors } from 'c/ldsUtils';
import inlineMessage from './errorPanel.html';

export default class ErrorPanel extends LightningElement {
    @api errors;

    get errorMessages() {
        return reduceErrors(this.errors);
    }

    render() {
        return inlineMessage;
    }
}