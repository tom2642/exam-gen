const initUpdateQuestionsOnSelect = () => {
  const bookmarkForm = document.getElementById("new_bookmark");
  const bookmarkRadios = document.querySelectorAll(".bookmark-radio");
  const cards = document.querySelectorAll(".card");

  bookmarkForm.addEventListener("click", () => {
    bookmarkRadios.forEach((radio) => {
      if (radio.checked) {
        radio.nextElementSibling.classList.add("chosen");
      } else {
        radio.nextElementSibling.classList.remove("chosen");
      }
    });
  });
}

export { initUpdateQuestionsOnSelect };
