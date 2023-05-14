import { Controller } from "@hotwired/stimulus"
import { end } from "@popperjs/core";

// Connects to data-controller="bet-amount"
export default class extends Controller {
  static targets = ['inputAmount', 'buttonSubmit']

  increment(e) {
    this.inputAmountTarget.value = parseInt(this.inputAmountTarget.value) + 1;
  }

  decrement(e) {
    if (this.inputAmountTarget.value > 0) {
      this.inputAmountTarget.value = parseInt(this.inputAmountTarget.value) - 1;
    } else {
      // this.buttonSubmit.disabled = true
    }
  }

}
