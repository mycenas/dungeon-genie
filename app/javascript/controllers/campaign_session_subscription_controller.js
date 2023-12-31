import { Controller } from '@hotwired/stimulus';
import { createConsumer } from '@rails/actioncable';

export default class extends Controller {
	static values = { campaignSessionId: Number };
	static targets = ['messages'];

	connect() {
		console.log('Test');
		this.channel = createConsumer().subscriptions.create(
			{ channel: 'CampaignSessionChannel', id: this.campaignSessionIdValue },
			{
				received: (data) => this.#insertMessageAndScrollDown(data),
			}
		);

		console.log(
			`Subscribed to the chatroom with the id ${this.campaignSessionIdValue}.`
		);
	}

	#insertMessageAndScrollDown(data) {
		this.messagesTarget.insertAdjacentHTML('beforeend', data);
		this.messagesTarget.scrollTo(0, this.messagesTarget.scrollHeight);
	}

	resetForm(event) {
		event.target.reset();
	}

	disconnect() {
		console.log('Unsubscribed from the chatroom');
		this.channel.unsubscribe();
	}
}
