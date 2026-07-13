Report 50224 "HMS Sales Invoice"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HMSSalesInvoice.rdlc';
    Caption = 'Sales - Quote';
    PreviewMode = PrintLayout;
    ApplicationArea = All;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Sales Quote';
            column(ReportForNavId_6640; 6640) { }
            column(DocType_SalesHeader; "Document Type") { }
            column(No_SalesHeader; "No.") { }
            column(SalesLineVATIdentifierCaption; SalesLineVATIdentifierCaptionLbl) { }
            column(PostingDate_SalesHeader; "Sales Header"."Posting Date") { }
            column(PaymentTermsDescriptionCaption; PaymentTermsDescriptionCaptionLbl) { }
            column(ShipmentMethodDescriptionCaption; ShipmentMethodDescriptionCaptionLbl) { }
            column(CompanyInfoHomePageCaption; CompanyInfoHomePageCaptionLbl) { }
            column(CompanyInfoEmailCaption; CompanyInfoEmailCaptionLbl) { }
            column(DocumentDateCaption; DocumentDateCaptionLbl) { }
            column(PostingDesc; "Sales Header"."Posting Description") { }
            column(Contact; "Sales Header"."Bill-to Contact") { }
            column(SalesLineAllowInvoiceDiscCaption; SalesLineAllowInvoiceDiscCaptionLbl) { }
            column(BillName; "Sales Header"."Bill-to Name") { }
            column(DueDate; "Sales Header"."Due Date") { }
            column(CustNo; "Sales Header"."Sell-to Customer No.") { }
            column(PatientNo; "Sales Header"."Patient No.") { }
            column(TreatmentNo; "Sales Header"."Treatment No") { }
            column(PatientName; PatientName) { }
            column(CLogo; CompanyInfo.Picture) { }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = where("No." = filter(<> ''));
                column(ReportForNavId_1; 1) { }
                column(No_SalesLine; "Sales Line"."No.") { }
                column(Description_SalesLine; "Sales Line".Description) { }
                column(Quantity_SalesLine; "Sales Line".Quantity) { }
                column(UnitPrice_SalesLine; "Sales Line"."Unit Price") { }
                column(Amount_SalesLine; "Sales Line".Amount) { }
            }

            trigger OnAfterGetRecord()
            var
                "Sell-to Country": Text[50];
            begin
                //CurrReport.Language := Language.GetLanguageID("Language Code");
                if PatientRec.Get("Sales Header"."Patient No.") then
                    PatientName := PatientRec."Membership No" + ' - ' + PatientRec.Surname + ' ' + PatientRec."Middle Name" + ' ' + PatientRec."Last Name";

                if RespCenter.Get("Responsibility Center") then begin
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                end else
                    FormatAddr.Company(CompanyAddr, CompanyInfo);

                DimSetEntry1.SetRange("Dimension Set ID", "Dimension Set ID");

                if "Salesperson Code" = '' then begin
                    SalesPurchPerson.Init;
                    SalesPersonText := '';
                end else begin
                    SalesPurchPerson.Get("Salesperson Code");
                    SalesPersonText := Text000;
                end;
                if "Your Reference" = '' then
                    ReferenceText := ''
                else
                    ReferenceText := FieldCaption("Your Reference");
                if "VAT Registration No." = '' then
                    VATNoText := ''
                else
                    VATNoText := FieldCaption("VAT Registration No.");
                if "Currency Code" = '' then begin
                    GLSetup.TestField("LCY Code");
                    TotalText := StrSubstNo(Text001, GLSetup."LCY Code");
                    TotalInclVATText := StrSubstNo(Text002, GLSetup."LCY Code");
                    TotalExclVATText := StrSubstNo(Text006, GLSetup."LCY Code");
                end else begin
                    TotalText := StrSubstNo(Text001, "Currency Code");
                    TotalInclVATText := StrSubstNo(Text002, "Currency Code");
                    TotalExclVATText := StrSubstNo(Text006, "Currency Code");
                end;
                FormatAddr.SalesHeaderBillTo(CustAddr, "Sales Header");

                if "Payment Terms Code" = '' then
                    PaymentTerms.Init
                else begin
                    PaymentTerms.Get("Payment Terms Code");
                    PaymentTerms.TranslateDescription(PaymentTerms, "Language Code");
                end;
                if "Shipment Method Code" = '' then
                    ShipmentMethod.Init
                else begin
                    ShipmentMethod.Get("Shipment Method Code");
                    ShipmentMethod.TranslateDescription(ShipmentMethod, "Language Code");
                end;

                if Country.Get("Sell-to Country/Region Code") then
                    "Sell-to Country" := Country.Name;
                //FormatAddr.SalesHeaderShipTo(ShipToAddr,"Sales Header");
                ShowShippingAddr := "Sell-to Customer No." <> "Bill-to Customer No.";
                for i := 1 to ArrayLen(ShipToAddr) do
                    if (ShipToAddr[i] <> CustAddr[i]) and (ShipToAddr[i] <> '') and (ShipToAddr[i] <> "Sell-to Country") then
                        ShowShippingAddr := true;

                if Print then begin
                    if ArchiveDocument then
                        ArchiveManagement.StoreSalesDocument("Sales Header", LogInteraction);

                    if LogInteraction then begin
                        CalcFields("No. of Archived Versions");
                        if "Bill-to Contact No." <> '' then
                            SegManagement.LogDocument(
                              1, "No.", "Doc. No. Occurrence",
                              "No. of Archived Versions", Database::Contact, "Bill-to Contact No.",
                              "Salesperson Code", "Campaign No.", "Posting Description", "Opportunity No.")
                        else
                            SegManagement.LogDocument(
                              1, "No.", "Doc. No. Occurrence",
                              "No. of Archived Versions", Database::Customer, "Bill-to Customer No.",
                              "Salesperson Code", "Campaign No.", "Posting Description", "Opportunity No.");
                    end;
                end;
                Mark(true);
            end;

            trigger OnPostDataItem()
            begin
                MarkedOnly := true;
                // COMMIT;
                // CurrReport.LANGUAGE := GLOBALLANGUAGE;
                // IF NOT FileManagement.IsWebClient THEN
                //  IF FIND('-') AND ToDo.WRITEPERMISSION THEN
                //    IF Print AND (NoOfRecords = 1) THEN
                //      IF CONFIRM(Text007) THEN
                //        CreateTodo;
            end;

            trigger OnPreDataItem()
            begin
                NoOfRecords := Count;
                Print := Print or not CurrReport.Preview;

                CompanyInfo.Get;
                CompanyInfo.CalcFields(CompanyInfo.Picture);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NoOfCopies; NoOfCopies)
                    {
                        ApplicationArea = Basic;
                        Caption = 'No. of Copies';
                        ToolTip = 'Specifies the value of the No. of Copies field.';
                    }
                    field(ShowInternalInfo; ShowInternalInfo)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Internal Information';
                        ToolTip = 'Specifies the value of the Show Internal Information field.';
                    }
                    field(ArchiveDocument; ArchiveDocument)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Archive Document';
                        ToolTip = 'Specifies the value of the Archive Document field.';

                        trigger OnValidate()
                        begin
                            if not ArchiveDocument then
                                LogInteraction := false;
                        end;
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies the value of the Log Interaction field.';

                        trigger OnValidate()
                        begin
                            if LogInteraction then
                                ArchiveDocument := ArchiveDocumentEnable;
                        end;
                    }
                }
            }
        }

        actions { }

        trigger OnInit()
        begin
            LogInteractionEnable := true;
        end;

        trigger OnOpenPage()
        begin
            //  ArchiveDocument := SalesSetup."Archive Quotes and Orders";
            LogInteraction := SegManagement.FindInteractTmplCode(1) <> '';

            LogInteractionEnable := LogInteraction;
        end;
    }

    labels { }

    trigger OnInitReport()
    begin
        GLSetup.Get;
        CompanyInfo.Get;
        SalesSetup.Get;

        case SalesSetup."Logo Position on Documents" of
            SalesSetup."logo position on documents"::"No Logo":
                ;
            SalesSetup."logo position on documents"::Left:
                begin
                    CompanyInfo3.Get;
                    CompanyInfo3.CalcFields(Picture);
                end;
            SalesSetup."logo position on documents"::Center:
                begin
                    CompanyInfo1.Get;
                    CompanyInfo1.CalcFields(Picture);
                end;
            SalesSetup."logo position on documents"::Right:
                begin
                    CompanyInfo2.Get;
                    CompanyInfo2.CalcFields(Picture);
                end;
        end;
    end;

    var
        Text000: label 'Salesperson';
        Text001: label 'Total %1';
        Text002: label 'Total %1 Incl. VAT';
        Text006: label 'Total %1 Excl. VAT';
        GLSetup: Record "General Ledger Setup";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        DimSetEntry1: Record "Dimension Set Entry";
        RespCenter: Record "Responsibility Center";
        Country: Record "Country/Region";
        FormatAddr: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        ArchiveManagement: Codeunit ArchiveManagement;
        CustAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        SalesPersonText: Text[30];
        VATNoText: Text[80];
        ReferenceText: Text[80];
        TotalText: Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        NoOfCopies: Integer;
        ShowShippingAddr: Boolean;
        i: Integer;
        ShowInternalInfo: Boolean;
        ArchiveDocument: Boolean;
        LogInteraction: Boolean;
        NoOfRecords: Integer;
        Print: Boolean;
        [InDataSet]
        ArchiveDocumentEnable: Boolean;
        [InDataSet]
        LogInteractionEnable: Boolean;
        SalesLineVATIdentifierCaptionLbl: label 'VAT Identifier';
        PaymentTermsDescriptionCaptionLbl: label 'Payment Terms';
        ShipmentMethodDescriptionCaptionLbl: label 'Shipment Method';
        CompanyInfoHomePageCaptionLbl: label 'Home Page';
        CompanyInfoEmailCaptionLbl: label 'E-Mail';
        DocumentDateCaptionLbl: label 'Document Date';
        SalesLineAllowInvoiceDiscCaptionLbl: label 'Allow Invoice Discount';
        PatientRec: Record "HMS Patient";
        PatientName: Text[100];

    procedure InitializeRequest(NoOfCopiesFrom: Integer; ShowInternalInfoFrom: Boolean; ArchiveDocumentFrom: Boolean; LogInteractionFrom: Boolean; PrintFrom: Boolean)
    begin
        NoOfCopies := NoOfCopiesFrom;
        ShowInternalInfo := ShowInternalInfoFrom;
        ArchiveDocument := ArchiveDocumentFrom;
        LogInteraction := LogInteractionFrom;
        Print := PrintFrom;
    end;
}

