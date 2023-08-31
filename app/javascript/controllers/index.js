import { application } from './application';
import CampaignSessionController from './campaign_session_subscription_controller.js';

import WizardController from './wizard_controller.js';
application.register('wizard', WizardController);
application.register('campaignSession', CampaignSessionController);
