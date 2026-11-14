/**
 * Print a self-contained HTML document through a hidden frame on the current page.
 *
 * No pop-up window is involved, so pop-up blockers never stop it. (The old way opened a window
 * with `noopener`: Chrome then returns null from window.open although the window opens, which
 * left a blank window and a false "Allow pop-ups" message.)
 */
export function printHtml(html: string): boolean {
  const frame = document.createElement('iframe')
  frame.setAttribute('aria-hidden', 'true')
  frame.setAttribute('tabindex', '-1')
  frame.style.cssText = 'position:fixed;right:0;bottom:0;width:0;height:0;border:0;visibility:hidden'
  document.body.appendChild(frame)
  const win = frame.contentWindow
  const doc = frame.contentDocument ?? win?.document
  if (!win || !doc) {
    frame.remove()
    return false
  }
  let removed = false
  const cleanUp = () => {
    if (removed) return
    removed = true
    frame.remove()
  }
  doc.open()
  doc.write(html)
  doc.close()
  const run = () => {
    try {
      win.addEventListener('afterprint', () => window.setTimeout(cleanUp, 500))
      win.focus()
      win.print()
    } finally {
      // Browsers without afterprint keep the frame a little while, then drop it.
      window.setTimeout(cleanUp, 120_000)
    }
  }
  // Let the written document lay out (fonts, tables) before the print dialog opens.
  if (doc.readyState === 'complete') window.setTimeout(run, 60)
  else frame.addEventListener('load', () => window.setTimeout(run, 60), { once: true })
  return true
}
