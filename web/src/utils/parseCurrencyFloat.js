export default function parseCurrencyFloat(input) {
  if (!input) return input;
  // CA$12,391,839,184,981,948.00
  const val = input
    .replace("CA$", "") // Remove prefix
    .replace(/,/g, ''); // Remove commas

  return parseFloat(val);
}
