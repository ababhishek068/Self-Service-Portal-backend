Report 50223 "HMS Drug Expiration Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HMSDrugExpirationReport.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Inventory Posting Group", "Expiration Calculation";
            column(ReportForNavId_8129; 8129) { }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4)) { }
            column(COMPANYNAME; COMPANYNAME) { }
            column(CurrReport_PAGENO; CurrReport.PageNo) { }
            column(UserId; UserId) { }
            column(Item__No__; "No.") { }
            column(Item_Description; Description) { }
            column(Item_Inventory; Inventory) { }
            column(Drug_Expiration_Report_ListingCaption; Drug_Expiration_Report_ListingCaptionLbl) { }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl) { }
            column(Item_Ledger_Entry__Expiration_Date_Caption; "Item Ledger Entry".FieldCaption("Expiration Date")) { }
            column(Item_Ledger_Entry__Location_Code_Caption; "Item Ledger Entry".FieldCaption("Location Code")) { }
            column(Item_Ledger_Entry__Serial_No__Caption; "Item Ledger Entry".FieldCaption("Serial No.")) { }
            column(Item_Ledger_Entry__Lot_No__Caption; "Item Ledger Entry".FieldCaption("Lot No.")) { }
            column(Item_Ledger_Entry_QuantityCaption; "Item Ledger Entry".FieldCaption(Quantity)) { }
            column(Item_Ledger_Entry__Remaining_Quantity_Caption; "Item Ledger Entry".FieldCaption("Remaining Quantity")) { }
            column(Item__No__Caption; FieldCaption("No.")) { }
            column(Item_DescriptionCaption; FieldCaption(Description)) { }
            column(Item_InventoryCaption; FieldCaption(Inventory)) { }
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Item No." = field("No.");
                DataItemTableView = where(Quantity = filter(> 0));
                column(ReportForNavId_7209; 7209) { }
                column(Item_Ledger_Entry__Location_Code_; "Location Code") { }
                column(Item_Ledger_Entry__Serial_No__; "Serial No.") { }
                column(Item_Ledger_Entry__Lot_No__; "Lot No.") { }
                column(Item_Ledger_Entry_Quantity; Quantity) { }
                column(Item_Ledger_Entry__Remaining_Quantity_; "Remaining Quantity") { }
                column(Item_Ledger_Entry__Expiration_Date_; "Expiration Date") { }
                column(Item_Ledger_Entry_Entry_No_; "Entry No.") { }
                column(Item_Ledger_Entry_Item_No_; "Item No.") { }
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
        Drug_Expiration_Report_ListingCaptionLbl: label 'Drug Expiration Report Listing';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

