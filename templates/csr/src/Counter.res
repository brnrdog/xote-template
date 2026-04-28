@jsx.component
let make = () => {
  let count = Signal.make(0)

  let decrement = (_: Dom.event) => Signal.update(count, n => n - 1)
  let increment = (_: Dom.event) => Signal.update(count, n => n + 1)

  <div className="flex items-center gap-3 p-6">
    <button
      className="px-3 py-1 rounded bg-slate-900 text-white hover:bg-slate-700"
      onClick={decrement}>
      {View.text("-")}
    </button>
    <span className="font-mono text-xl tabular-nums">
      {View.signalText(() => Signal.get(count)->Int.toString)}
    </span>
    <button
      className="px-3 py-1 rounded bg-slate-900 text-white hover:bg-slate-700"
      onClick={increment}>
      {View.text("+")}
    </button>
  </div>
}
