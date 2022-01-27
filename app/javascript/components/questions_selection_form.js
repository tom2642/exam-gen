const initUpdateQuestionsOnSelect = () => {
  const selectionCheckboxes = document.querySelectorAll(".selection-checkbox");
  const questions = document.querySelectorAll(".question");
  const selected_count = document.getElementById("selected_count");
  const generate_button = document.getElementById("generate-button");

  questions.forEach(question => {
    question.addEventListener("click", (event) => {
      // toggle checkbox
      const checkbox = question.getElementsByTagName("input")[0];
      checkbox.checked = !(checkbox.checked);

      // update styles of (un)chosen questions
      // count number of selections
      let count = 0;
      selectionCheckboxes.forEach((checkbox) => {
        if (checkbox.checked) {
          checkbox.parentElement.classList.add("chosen");
        } else {
          checkbox.parentElement.classList.remove("chosen");
        }
        if (checkbox.checked) { count++ }
      });

      // disable button if no questions selected
      if (count === 0) {
        generate_button.disabled = true;
      } else { generate_button.disabled = false; }

      selected_count.innerText = `You have selected ${count} questions.`
    });
  });
}

const initTopicSeletion = () => {
  const selection = document.getElementById("topic");
  const questions = document.querySelectorAll(".question");

  selection.addEventListener("change", () => {
    questions.forEach((question) => {
      let matchedTopic = false;
      question.classList.forEach((className) => {
        console.log(className.replaceAll('-', ' '));
        if (className.replaceAll('-', ' ') == selection.value || selection.value == 'All') {
          matchedTopic = true;
        }
        if (matchedTopic) {
          question.hidden = false;
        } else {
          question.hidden = true;
        }
      });
    });
  });
}

export { initUpdateQuestionsOnSelect, initTopicSeletion };
