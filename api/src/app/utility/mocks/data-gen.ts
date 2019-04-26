export function* generator(num: number, fn: () => any): Iterable<any> {
  const index = 0;
  while (index < num) {
    yield fn();
  }
}
