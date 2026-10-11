/// <summary>
/// SSP Facility UAT R55-R58: posted transfer shipments a gate pass can reference.
/// PUBLISH AS ODATA WEB SERVICE with Service Name = "QyGatePassTransferShipments".
///
/// NOTE FOR FELIX: "Transfer Shipment Header" (5744) is standard BC. The
/// GatePassNo column assumes the HIJRA base adds a "Gate Pass No." field to
/// stamp shipments already linked to a gate pass; if the field name differs,
/// adjust the source name — the portal filters `GatePassNo eq ''` to offer
/// only unlinked shipments.
/// </summary>
query 50126 "QyGatePassTransferShipments"
{
    QueryType = Normal;

    elements
    {
        dataitem(Shipment; "Transfer Shipment Header")
        {
            column(No; "No.") { }
            column(TransferfromCode; "Transfer-from Code") { }
            column(TransfertoCode; "Transfer-to Code") { }
            column(PostingDate; "Posting Date") { }
            column(GatePassNo; "Gate Pass No.") { }
        }
    }
}
