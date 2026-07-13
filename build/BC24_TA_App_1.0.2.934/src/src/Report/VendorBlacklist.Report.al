namespace ABH_UAT.ABH_UAT;
using Microsoft.Purchases.Vendor;
using Microsoft.Foundation.Company;

report 50371 "Vendor Blacklist"

{
    ApplicationArea = All;
    Caption = 'Vendor Blacklist';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = Word;
    WordLayout = './NewLayouts/blacklist.docx';
    dataset
    {
        dataitem(BlacklistVendor; BlacklistVendor)
        {
            column(BlacklistCode; "Blacklist Code")
            {
            }
            column(BlacklistPeriod; "Blacklist Period")
            {
            }
            column(BlacklistingEndDate; Format("Blacklisting End Date", 0, '<Closing><Day,2>/<Month,2>/<Year,4>'))
            {
            }
             //column(clearancedate; format("HR Employee Exit Interviews"."Date Of Clearance", 0, '<Closing><Day,2>/<Month,2>/<Year,4>')) { }
            column(BlacklistingStartDate; Format("Blacklisting Start Date", 0, '<Closing><Day,2>/<Month,2>/<Year,4>'))
            {
            }
            column(ContractEnddate; Format("Contract End date", 0, '<Closing><Day,2>/<Month,2>/<Year,4>'))
            {
            }
            column(ContractName; "Contract Name")
            {
            }
            column(ContractNo; "Contract No")
            {
            }
            column(ContractPeriod; "Contract Period")
            {
            }
            column(ContractStartDate; Format("Contract Start Date", 0, '<Closing><Day,2>/<Month,2>/<Year,4>'))
            {
            }
            column(ContractValue; "Contract Value")
            {
            }
            column(CreatedBy; "Created By")
            {
            }
            column(DateApproved; Format("Date Approved", 0, '<Closing><Day,2>/<Month,2>/<Year,4>'))
            {
            }
            column(DateCreated; Format("Date Created", 0, '<Closing><Day,2>/<Month,2>/<Year,4>'))
            {
            }
            column(ReasonCode; "Reason Code")
            {
            }
            column(Status; Status)
            {
            }
            column(Vendor_Response_Date;Format("Vendor Response Date", 0, '<Closing><Day,2>/<Month,2>/<Year,4>')){}
            column(Vendor_Response;"Vendor Response"){}
            column(Vendor_Response_Ref_No;"Vendor Response Ref No"){}
            column(SummaryReasonforBlaclist; "Summary Reason for Blaclist")
            {
            }
            column(SystemCreatedAt; SystemCreatedAt)
            {
            }
            column(SystemCreatedBy; SystemCreatedBy)
            {
            }
            column(SystemId; SystemId)
            {
            }
            column(SystemModifiedAt; SystemModifiedAt)
            {
            }
            column(SystemModifiedBy; SystemModifiedBy)
            {
            }
            column(TimeCreated; "Time Created")
            {
            }
            column(VendorCode; "Vendor Code")
            {
            }
            column(VendorName; "Vendor Name")
            {
            }
            column(pic;CompInfo.Picture){}
            column(subcityC;subcityC){}
            column(compname;CompInfo.Name){}
            trigger OnAfterGetRecord()
            begin
                Vend.Reset;
                vend.SetRange(Vend."No.", "Vendor Code");
                if Vend.FindFirst() then begin
                    //payee := Vend.Name;
                    TINV := vend."VAT Registration No.";
                    WoredaV := vend.County;
                    KabeleV := '';
                    HNoV := vend."Post Code";
                    subcityV := vend."Address 2";
                    subcityV := vend.Address;
                end;
            end;           
                
        }
       
            
    }
    trigger OnPreReport()
    begin
        CompInfo.get;
        CompInfo.CalcFields(Picture);
        subcityC := compInfo."Address 2";
        AddressC := CompInfo.Address;
        WoredaC := CompInfo.County;
        KabeleC := '';
        HNoC := CompInfo."Post Code";
        TINC := compinfo."VAT Registration No.";
        counter := 0;
    end;
    var
    TINC: text[30];
    counter:Integer;
    CompInfo: Record "Company Information";
        TINV: text[30];
        WoredaC: text[50];
        WoredaV: text[50];
        KabeleC: text[30];
        KabeleV: text[30];
        HNoC: text[30];
        HNoV: text[30];
        VATREGC: text[30];
        VATREGV: text[30];
        ModeofPayment: code[30];
        subcityV: text[30];
        subcityC: text[30];

        AddressC: text[50];
        AddressV: text[50];

        Vend: Record Vendor;

        from: label 'From';
        To_: label 'To';
        AddressCC: label 'Address City/Town';
        subcitycc: label 'Zone/Sub-city';
        Woredacc: label 'Woreda';
        Kebelecc: label 'Kebele';
        Hnocc: label 'H.No.';
        TIN: label 'TIN';
    
}
