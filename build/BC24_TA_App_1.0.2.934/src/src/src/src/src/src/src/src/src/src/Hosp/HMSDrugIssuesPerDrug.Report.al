Report 50217 "HMS Drug Issues Per Drug"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HMSDrugIssuesPerDrug.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(ReportForNavId_8129; 8129) { }
            column(Date_Printed______FORMAT_TODAY_0_4_; 'Date Printed: ' + Format(Today, 0, 4)) { }
            column(COMPANYNAME; COMPANYNAME) { }
            column(CurrReport_PAGENO; CurrReport.PageNo) { }
            column(Printed_By______USERID; 'Printed By: ' + UserId) { }
            column(Item__No__; "No.") { }
            column(Item_Description; Description) { }
            column(Item_Inventory; Inventory) { }
            column(TotalFor___FIELDCAPTION__No___; TotalFor + FieldCaption("No.")) { }
            column(Item_Inventory_Control1102760020; Inventory) { }
            column(UNIVERSITY_HEALTH_SERVICESCaption; UNIVERSITY_HEALTH_SERVICESCaptionLbl) { }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl) { }
            column(DRUG_ISSUES_PER_GROUPCaption; DRUG_ISSUES_PER_GROUPCaptionLbl) { }
            column(U_O_MCaption; U_O_MCaptionLbl) { }
            column(HMS_Pharmacy_Line_DateCaption; "HMS Pharmacy Line".FieldCaption(Date)) { }
            column(HMS_Pharmacy_Line__Actual_Qty_Caption; "HMS Pharmacy Line".FieldCaption("Actual Qty")) { }
            column(HMS_Pharmacy_Line_QuantityCaption; "HMS Pharmacy Line".FieldCaption(Quantity)) { }
            column(Iss_d_QtyCaption; Iss_d_QtyCaptionLbl) { }
            column(Iss_d_UnitsCaption; Iss_d_UnitsCaptionLbl) { }
            column(RemainingCaption; RemainingCaptionLbl) { }
            column(HMS_Pharmacy_Line_PharmacyCaption; "HMS Pharmacy Line".FieldCaption(Pharmacy)) { }
            column(Item_InventoryCaption; FieldCaption(Inventory)) { }
            column(Item_DescriptionCaption; FieldCaption(Description)) { }
            column(Item__No__Caption; FieldCaption("No.")) { }
            dataitem("HMS Pharmacy Line"; "HMS Pharmacy Line")
            {
                DataItemLink = "No." = field("No.");
                column(ReportForNavId_1251; 1251) { }
                column(HMS_Pharmacy_Line_Date; Date) { }
                column(HMS_Pharmacy_Line__Measuring_Unit_; "Measuring Unit") { }
                column(HMS_Pharmacy_Line__Actual_Qty_; "Actual Qty") { }
                column(HMS_Pharmacy_Line_Quantity; Quantity) { }
                column(HMS_Pharmacy_Line__Issued_Quantity_; "Issued Quantity") { }
                column(HMS_Pharmacy_Line__Issued_Units_; "Issued Units") { }
                column(HMS_Pharmacy_Line_Remaining; Remaining) { }
                column(HMS_Pharmacy_Line_Pharmacy; Pharmacy) { }
                column(HMS_Pharmacy_Line_Pharmacy_No_; "Pharmacy No.") { }
                column(HMS_Pharmacy_Line_Drug_No_; "No.") { }
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("No.");
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
        LastFieldNo: Integer;
        TotalFor: label 'Total for ';
        UNIVERSITY_HEALTH_SERVICESCaptionLbl: label 'UNIVERSITY HEALTH SERVICES';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        DRUG_ISSUES_PER_GROUPCaptionLbl: label 'DRUG ISSUES PER GROUP';
        U_O_MCaptionLbl: label 'U.O.M';
        Iss_d_QtyCaptionLbl: label 'Iss''d Qty';
        Iss_d_UnitsCaptionLbl: label 'Iss''d Units';
        RemainingCaptionLbl: label 'Remaining';
}

