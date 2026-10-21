export function readFileAsBase64(file: File) {
  return new Promise<string>((resolve, reject) => {
    const reader = new FileReader()
    reader.onerror = () => reject(new Error(`Could not read ${file.name}`))
    reader.onload = () => {
      const raw = String(reader.result ?? '')
      const base64 = raw.includes(',') ? raw.split(',')[1] ?? '' : raw
      if (!base64) {
        reject(new Error(`Could not read ${file.name}`))
        return
      }
      resolve(base64)
    }
    reader.readAsDataURL(file)
  })
}
