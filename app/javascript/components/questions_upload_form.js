const initEnableButtonOnUploadFile = () => {
  const fileFields = document.querySelectorAll(".file-field");

  fileFields.forEach(fileField => {
    fileField.addEventListener("change", () => {
      const uploadButton = fileField.parentElement.querySelector(".file-button");
      if (fileField.files.length == 0) {
        uploadButton.disabled = true;
      } else {
        uploadButton.disabled = false;
      }
    });
  });
}

export { initEnableButtonOnUploadFile };
