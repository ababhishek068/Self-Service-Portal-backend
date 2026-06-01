declare module 'httpntlm' {
  interface NtlmOptions {
    url: string
    username: string
    password: string
    domain?: string
    workstation?: string
    headers?: Record<string, string>
    body?: string
  }

  interface NtlmResponse {
    statusCode: number
    body: string
  }

  type Callback = (error: Error | null, response: NtlmResponse) => void

  const httpntlm: {
    get(options: NtlmOptions, callback: Callback): void
    post(options: NtlmOptions, callback: Callback): void
  }

  export default httpntlm
}
