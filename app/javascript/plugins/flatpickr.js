import flatpickr from "flatpickr";

const initFlatpickr = () => {
  flatpickr(".datepicker", {
      enableTime: true,
      dateFormat: "Y-m-d H:i",
  });

  flatpickr(".daterangepicker", {
    mode: 'range'
});
}

export { initFlatpickr };
