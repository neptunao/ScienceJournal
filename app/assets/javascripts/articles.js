function changeVisibilityByCheckbox(checkbox_id, id) {
  checkbox = document.getElementById(checkbox_id)
  document.getElementById(id).style.display = checkbox.checked ? 'block' : 'none'
}