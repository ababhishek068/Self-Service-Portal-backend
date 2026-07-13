Report 50225 "HMS Patient Prescription"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HMSPatientPrescription.rdlc';
    Caption = 'Sales - Quote';
    PreviewMode = PrintLayout;
    ApplicationArea = All;

    dataset
    {
        dataitem("HMS Pharmacy Header"; "HMS Pharmacy Header")
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Pharmacy No.", "Pharmacy Date", "Link No.";
            column(ReportForNavId_6640; 6640) { }
            column(PatientName; PatientName) { }
            column(PharmacyNo_HMSPharmacyHeader; "HMS Pharmacy Header"."Pharmacy No.") { }
            column(PharmacyDate_HMSPharmacyHeader; "HMS Pharmacy Header"."Pharmacy Date") { }
            column(PharmacyTime_HMSPharmacyHeader; "HMS Pharmacy Header"."Pharmacy Time") { }
            column(RequestArea_HMSPharmacyHeader; "HMS Pharmacy Header"."Request Area") { }
            column(PatientNo_HMSPharmacyHeader; "HMS Pharmacy Header"."Patient No.") { }
            column(StudentNo_HMSPharmacyHeader; "HMS Pharmacy Header"."Student No.") { }
            column(EmployeeNo_HMSPharmacyHeader; "HMS Pharmacy Header"."Employee No.") { }
            column(RelativeNo_HMSPharmacyHeader; "HMS Pharmacy Header"."Relative No.") { }
            column(BillToCustomerNo_HMSPharmacyHeader; "HMS Pharmacy Header"."Bill To Customer No.") { }
            column(IssuedBy_HMSPharmacyHeader; "HMS Pharmacy Header"."Issued By") { }
            column(LinkType_HMSPharmacyHeader; "HMS Pharmacy Header"."Link Type") { }
            column(LinkNo_HMSPharmacyHeader; "HMS Pharmacy Header"."Link No.") { }
            column(Status_HMSPharmacyHeader; "HMS Pharmacy Header".Status) { }
            column(NoSeries_HMSPharmacyHeader; "HMS Pharmacy Header"."No. Series") { }
            column(Surname_HMSPharmacyHeader; "HMS Pharmacy Header".Surname) { }
            column(MiddleName_HMSPharmacyHeader; "HMS Pharmacy Header"."Middle Name") { }
            column(LastName_HMSPharmacyHeader; "HMS Pharmacy Header"."Last Name") { }
            column(IDNumber_HMSPharmacyHeader; "HMS Pharmacy Header"."ID Number") { }
            column(CorrespondenceAddress1_HMSPharmacyHeader; "HMS Pharmacy Header"."Correspondence Address 1") { }
            column(TelephoneNo1_HMSPharmacyHeader; "HMS Pharmacy Header"."Telephone No. 1") { }
            column(Email_HMSPharmacyHeader; "HMS Pharmacy Header".Email) { }
            column(PatientRefNo_HMSPharmacyHeader; "HMS Pharmacy Header"."Patient Ref. No.") { }
            column(TotalPrice_HMSPharmacyHeader; "HMS Pharmacy Header"."Total Price") { }
            column(InsuranceNo_HMSPharmacyHeader; "HMS Pharmacy Header"."Insurance No") { }
            column(AdmNo_HMSPharmacyHeader; "HMS Pharmacy Header"."Ref No") { }
            column(CLogo; CompanyInfo.Picture) { }
            dataitem("HMS Pharmacy Line"; "HMS Pharmacy Line")
            {
                DataItemLink = "Pharmacy No." = field("Pharmacy No.");
                column(ReportForNavId_7; 7) { }
                column(DrugName_HMSPharmacyLine; "HMS Pharmacy Line"."Drug Name") { }
                column(Quantity_HMSPharmacyLine; "HMS Pharmacy Line".Quantity) { }
                column(Dosage_HMSPharmacyLine; "HMS Pharmacy Line".Dosage) { }
            }

            trigger OnAfterGetRecord()
            begin
            end;

            trigger OnPostDataItem()
            begin
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get;
                CompanyInfo.CalcFields(Picture);
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
    end;

    var
        GLSetup: Record "General Ledger Setup";
        CompanyInfo: Record "Company Information";
        SegManagement: Codeunit SegManagement;
        LogInteraction: Boolean;
        [InDataSet]
        LogInteractionEnable: Boolean;
        PatientName: Text[100];

    procedure InitializeRequest(NoOfCopiesFrom: Integer; ShowInternalInfoFrom: Boolean; ArchiveDocumentFrom: Boolean; LogInteractionFrom: Boolean; PrintFrom: Boolean)
    begin
    end;
}

