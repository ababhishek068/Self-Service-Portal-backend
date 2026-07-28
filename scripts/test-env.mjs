// Keep unit tests deterministic and prevent accidental calls to a real BC environment.
process.env.BC_AUTH_MODE = 'none'
process.env.BC_ODATA_BASE_URL = 'http://127.0.0.1:9/ODataV4/'
process.env.BC_SOAP_CODEUNIT_URL = 'http://127.0.0.1:9/WS/Company/Codeunit/CuStaffPortal'
process.env.BC_SOAP_PAGE_BASE_URL = 'http://127.0.0.1:9/ODataV4/'
process.env.BC_ODATA_PAGE_BASE_URL = 'http://127.0.0.1:9/ODataV4/'
process.env.BC_REQUEST_TIMEOUT_MS = '50'
