// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()


// ----------------------------------------------------
// Note(lewagon): ABOVE IS RAILS DEFAULT CONFIGURATION
// WRITE YOUR OWN JS STARTING FROM HERE 👇
// ----------------------------------------------------

// External imports
import "bootstrap";

// Internal imports, e.g:
import { initUpdateQuestionsOnSelect } from '../components/questions_selection_form';
import { initEnableButtonOnUploadFile } from '../components/questions_upload_form';
import { initTopicSeletion } from '../components/questions_selection_form';

document.addEventListener('turbolinks:load', () => {
  // Call your functions here
  initUpdateQuestionsOnSelect();
  initEnableButtonOnUploadFile();
  initTopicSeletion();
});
