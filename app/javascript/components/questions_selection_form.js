const initUpdateQuestionsOnSelect = () => {
  const selectionForm = document.querySelector(".questions-display");
  const selectionCheckboxes = document.querySelectorAll(".selection-checkbox");
  const questions = document.querySelectorAll(".question");

  selectionForm.addEventListener("click", () => {
    selectionCheckboxes.forEach((checkbox) => {
      if (checkbox.checked) {
        checkbox.parentElement.classList.add("chosen");
      } else {
        checkbox.parentElement.classList.remove("chosen");
      }
    });
  });

  questions.forEach(question => {
    question.addEventListener("click", (event) => {
      const checkbox = question.getElementsByTagName("input")[0];
      checkbox.checked = !(checkbox.checked);
    });
  });
}

export { initUpdateQuestionsOnSelect };
