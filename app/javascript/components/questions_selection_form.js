const initUpdateQuestionsOnSelect = () => {
  const selectionForm = document.querySelector(".questions-display");
  const selectionCheckboxes = document.querySelectorAll(".selection-checkbox");
  const questions = document.querySelectorAll(".question");
  const selected_count = document.getElementById("selected_count");
  const generate_button = document.getElementById("generate-button");

  selectionForm.addEventListener("click", () => {
    let count = 0;
    selectionCheckboxes.forEach((checkbox) => {
      if (checkbox.checked) {
        checkbox.parentElement.classList.add("chosen");
      } else {
        checkbox.parentElement.classList.remove("chosen");
      }
      if (checkbox.checked) { count++ }
    });
    if (count === 0) {
      generate_button.disabled = ture;
    } else { generate_button.disabled = false; }
    selected_count.innerText = `You have selected ${count} questions.`
  });

  questions.forEach(question => {
    question.addEventListener("click", (event) => {
      const checkbox = question.getElementsByTagName("input")[0];
      checkbox.checked = !(checkbox.checked);
    });
  });
}

export { initUpdateQuestionsOnSelect };
