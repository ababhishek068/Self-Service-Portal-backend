report 50351 "PPRA RFQ Document"
{
    RDLCLayout = './PPRARFQDocument.rdlc';
    WordLayout = './PPRARFQDocument.docx';
    DefaultLayout = Word;
    ApplicationArea = All;
    //WordMergeDataItem = "Purchase Quote Header";

    dataset
    {
        dataitem("Purchase Quote Header"; "Purchase Quote Header")
        {
            RequestFilterFields = "No.";
            column(No_PurchaseQuoteHeader; "Purchase Quote Header"."No.") { }
            column(RequestSummary_PurchaseQuoteHeader; "Purchase Quote Header"."Request Description") { }
            dataitem("Purchase Quote Line"; "Purchase Quote Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                column(No_PurchaseQuoteLine; "Purchase Quote Line"."No.") { }
                column(Description_PurchaseQuoteLine; "Purchase Quote Line".Description) { }
                column(Description2_PurchaseQuoteLine; "Purchase Quote Line"."Description 2") { }
                column(Quantity_PurchaseQuoteLine; "Purchase Quote Line".Quantity) { }
                column(UnitofMeasure_PurchaseQuoteLine; "Purchase Quote Line"."Unit of Measure") { }
            }

            trigger OnAfterGetRecord()
            begin
                QVend.RESET;
                QVend.SETFILTER(QVend."Requisition Document No.", GETFILTER("No."));
                IF QVend.FIND('-') THEN begin

                end
            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    var
        QVend: Record "Quotation Request Vendors";

    local procedure GetVendDetails(VendNo: Code[20]; QNo: Code[20])
    begin
    end;
}

