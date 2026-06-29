import { gatePassSources, listGatePasses, type GatePassSource } from '@/api/endpoints/gatePass'
import { RequestFormPage } from '@/components/shared/RequestFormPage'
import { gatePassSchema } from '@/schemas/requestSchemas'

export function GatePass({ source }: { source: GatePassSource }) {
  const activeSource = gatePassSources.find((item) => item.value === source) ?? gatePassSources[0]

  return (
    <RequestFormPage
      title={activeSource.label}
      description={activeSource.description}
      schema={gatePassSchema}
      queryKey={['facility', 'gate-pass', source]}
      listRequests={() => listGatePasses(source)}
      createRequest={async () => undefined}
      source="Facility requirements workbook"
      defaultValues={{
        gatePassType: 'Returnable',
        assetTagNumber: '',
        destination: '',
        issueDate: '',
        returnDate: '',
        reason: '',
        attachments: [],
      }}
      fields={[]}
      listOnly
      moduleConfig={{ module: 'gatePass', entity: 'selfServiceGatePasses' }}
      businessRules={[
        'Gate passes are generated in Business Central from Store Issue, Transfer Order, and Asset Transfer documents.',
        'Open gate passes can be sent for approval from the detail screen.',
      ]}
    />
  )
}
