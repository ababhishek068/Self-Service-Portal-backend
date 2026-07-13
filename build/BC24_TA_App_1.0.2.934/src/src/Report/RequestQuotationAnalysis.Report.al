Report 50194 "Request Quotation Analysis"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/RequestQuotationAnalysis.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Purchase Quote Header"; "Purchase Quote Header")
        {
            DataItemTableView = sorting("Document Type", "No.");
            RequestFilterFields = "No.";
            column(ReportForNavId_1; 1) { }
            column(No_PurchaseQuoteHeader; "Purchase Quote Header"."No.") { }
            column(PostingDate_PurchaseQuoteHeader; "Purchase Quote Header"."Posting Date") { }
            column(ShiptoName_PurchaseQuoteHeader; "Purchase Quote Header"."Ship-to Name") { }
            column(ExpectedClosingDate_PurchaseQuoteHeader; "Purchase Quote Header"."Expected Closing Date") { }
            column(picture; CompanyInformation.Picture) { }
            column(CertificateofIncorporation_PurchaseQuoteHeader; "Purchase Quote Header"."Certificate of Incorporation") { }
            column(Name; CompanyInformation.Name) { }
            column(Adress; CompanyInformation.Address) { }
            column(YAGPOCertificate_PurchaseQuoteHeader; "Purchase Quote Header"."YAGPO Certificate") { }
            column(TaxCompliance_PurchaseQuoteHeader; "Purchase Quote Header"."Tax Compliance") { }
            column(Adress2; CompanyInformation."Address 2") { }
            column(phoneno; CompanyInformation."Phone No.") { }
            column(VendorName; vendName) { }
            dataitem("Purchase Quote Line"; "Purchase Quote Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.");
                column(ReportForNavId_2; 2) { }
                column(Description_PurchaseQuoteLine; "Purchase Quote Line".Description) { }
                column(UnitofMeasure_PurchaseQuoteLine; "Purchase Quote Line"."Unit of Measure") { }
                column(Quantity_PurchaseQuoteLine; "Purchase Quote Line".Quantity) { }
                column(DirectUnitCost_PurchaseQuoteLine; "Purchase Quote Line"."Direct Unit Cost") { }
                column(Remarks_PurchaseQuoteLine; "Purchase Quote Line".Remarks) { }
                column(UnitCostLCY_PurchaseQuoteLine; "Purchase Quote Line"."Unit Cost (LCY)") { }
                column(Amount_PurchaseQuoteLine; "Purchase Quote Line".Amount) { }
                column(AmountIncludingVAT_PurchaseQuoteLine; "Purchase Quote Line"."Amount Including VAT") { }
                column(UnitPriceLCY_PurchaseQuoteLine; "Purchase Quote Line"."Unit Price (LCY)") { }
                column(DaystoDeliver_PurchaseQuoteLine; "Purchase Quote Line"."Days to Deliver") { }
                column(RequestSummary_PurchaseQuoteLine; "Purchase Quote Line"."Request Summary.") { }
            }
            trigger OnAfterGetRecord()

            begin
                VendName := '';
                vend.reset;
                vend.setfilter(vend."No.", "Purchase Quote Header".getfilter("Vendor No. Filter"));
                if Vend.find('-') then
                    VendName := Vend.Name;
            end;
        }

    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        CompanyInformation.Get;
        CompanyInformation.CalcFields(CompanyInformation.Picture);
    end;

    var
        Vend: Record Vendor;
        VendName: text[100];
        CompanyInformation: Record "Company Information";
}

