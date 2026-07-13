namespace microsoft;
using Microsoft.EServices.EDocument;
using Microsoft.Finance.AllocationAccount;
using Microsoft.Finance.Currency;
using Microsoft.Finance.Deferral;
using Microsoft.Finance.Dimension;
using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Finance.ReceivablesPayables;
using Microsoft.Finance.SalesTax;
using Microsoft.Finance.VAT.Calculation;
using Microsoft.Finance.VAT.Setup;
using Microsoft.FixedAssets.Depreciation;
using Microsoft.FixedAssets.FixedAsset;
using Microsoft.FixedAssets.Insurance;
using Microsoft.FixedAssets.Maintenance;
using Microsoft.FixedAssets.Posting;
using Microsoft.FixedAssets.Setup;
using Microsoft.Foundation.Attachment;
using Microsoft.Foundation.AuditCodes;
using Microsoft.Foundation.Calendar;
using Microsoft.Foundation.Enums;
using Microsoft.Foundation.ExtendedText;
using Microsoft.Foundation.UOM;
using Microsoft.Intercompany.GLAccount;
using Microsoft.Intercompany.Partner;
using Microsoft.Inventory;
using Microsoft.Inventory.Availability;
using Microsoft.Inventory.Intrastat;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Item.Catalog;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Location;
using Microsoft.Inventory.Setup;
using Microsoft.Inventory.Tracking;
using Microsoft.Manufacturing.Document;
using Microsoft.Manufacturing.MachineCenter;
using Microsoft.Manufacturing.Routing;
using Microsoft.Manufacturing.WorkCenter;
using Microsoft.Pricing.Calculation;
using Microsoft.Pricing.PriceList;
using Microsoft.Projects.Project.Job;
using Microsoft.Projects.Project.Journal;
using Microsoft.Projects.Project.Planning;
using Microsoft.Projects.Resources.Resource;
using Microsoft.Purchases.Comment;
using Microsoft.Purchases.History;
using Microsoft.Purchases.Posting;
using Microsoft.Purchases.Pricing;
using Microsoft.Purchases.Setup;
using Microsoft.Purchases.Vendor;
using Microsoft.Sales.Document;
using Microsoft.Utilities;
using Microsoft.Warehouse.Document;
using Microsoft.Warehouse.Journal;
using Microsoft.Warehouse.Request;
using Microsoft.Warehouse.Setup;
using Microsoft.Warehouse.Structure;
using System.Utilities;
using System.Environment.Configuration;
using Microsoft.Purchases.Document;
table 50931 "Budget line"
{
    Caption = 'Budget line';
    DataClassification = ToBeClassified;
    LookupPageId=IndividualizedBudgetLine;
    
    fields
    {
        field(1; "Entry No"; Integer)
        {
            Caption = 'Entry No';
            AutoIncrement=true;
        }
        field(2; "Budget No"; Code[20])
        {
            Caption = 'Budget No';
        }
        field(3; "Department Code"; Code[20])
        {
            Caption = 'Department Code';
        }
        field(4; "Gl Account"; Code[20])
        {
            Caption = 'Gl Account';
        }
        field(5; "Type";Enum "Purchase Line Type")
        {
            
            Caption = 'Type';
        }
        field(6; No; Code[20])
        {
            Caption = 'No';
            TableRelation = if (Type = const(" ")) "Standard Text"
            else
            if (Type = const("G/L Account")) "G/L Account"."No."
            else
            if (Type = const(Item)) Item
            else
            if (Type = const(3)) Resource
            else
            if (Type = const("Fixed Asset")) "Fixed Asset"
            else
            if (Type = const("Charge (Item)")) "Item Charge";

            trigger OnValidate()
            begin
                //,G/L Account,Item,,Fixed Asset,Charge (Item)
                if Type = Type::"G/L Account" then begin
                    GLAcc.Reset;
                    GLAcc.Get(No);
                    Description := GLAcc.Name;
                end
                else
                    if Type = Type::Item then begin
                        Item.Reset;
                        Item.Get(No);

                        Description := Item.Description;
                        UoM:=items."Base Unit of Measure";
                    //CalcFields(items.Inventory);
                    "Current Quantity":=items.Inventory;
                    "Estimated Cost":=items."Unit Cost";

                    end
                    else
                        if Type = Type::"Fixed Asset" then begin
                            FA.Reset;
                            FA.Get(No);
                            Description := FA.Description;
                        end
                        else
                            if Type = Type::"Charge (Item)" then begin
                                CItem.Reset;
                                CItem.Get(No);
                                Description := CItem.Description;
                            end;
            end;

                
                //   items.reset;
                //   items.SetRange(items."No.",No);
                //   if items.FindFirst() then begin
                //     UoM:=items."Base Unit of Measure";
                //     //CalcFields(items.Inventory);
                //     "Current Quantity":=items.Inventory;
                //     "Estimated Cost":=items."Unit Cost";
                //   end;

            
                
        }
        field(7; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(8; R; Integer)
        {
            Caption = 'R';
        }
        field(9; "Current Quantity"; Integer)
        {
            Caption = 'Current Quantity';
        }
        field(10; "Estimated Cost"; Decimal)
        {
            Caption = 'Estimated Cost';
        }
        field(11; Justification; Text[100])
        {
            Caption = 'Justification';
        }
        field(12; UoM; Code[20])
        {
            Caption = 'UoM';
            TableRelation = "Unit of Measure";
        }
        field(13; Functional; Integer)
        {
            Caption = 'Functional';
        }
        field(14; "Partially Functional"; Integer)
        {
            Caption = 'Partially Functional';
        }
        field(15; N; Integer)
        {
            Caption = 'N';
        }
        field(16; T; Integer)
        {
            Caption = 'T';
        }
        field(17; "R(Birr)"; Integer)
        {
            Caption = 'R(Birr)';
        }
        field(18; "N(Birr)"; Integer)
        {
            Caption = 'N(Birr)';
        }
        field(19; "T(Birr)"; Integer)
        {
            Caption = 'T(Birr)';
        }
        field(20; "Budget year"; code[20])
        {
          
        }
        field(101; "System-Created Entry"; Boolean)
        {
            Caption = 'System-Created Entry';
            Editable = false;
        }
        field(102; "Non Functional"; Integer)
        {
            Caption = 'Partially Functional';
        }
    }
    
    keys
    {
        key(PK; "Entry No","Budget No","Department Code","Gl Account",No)
        {
            Clustered = true;
        }
    }
    var
    PurchHeader: Record "Purchase Header";
        PurchLine2: Record "Purchase Line";
        GLAcc: Record "G/L Account";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        VATPostingSetup: Record "VAT Posting Setup";
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        GenProdPostingGrp: Record "Gen. Product Posting Group";
        UnitOfMeasure: Record "Unit of Measure";
        ItemCharge: Record "Item Charge";
        SKU: Record "Stockkeeping Unit";
        WorkCenter: Record "Work Center";
        InvtSetup: Record "Inventory Setup";
        Location: Record Location;
        GLSetup: Record "General Ledger Setup";
        
        Item: Record Item;
        FA: Record "Fixed Asset";
        CItem: Record "Item Charge";
        CalChange: Record "Customized Calendar Change";
        TempJobJnlLine: Record "Job Journal Line" temporary;
        VendorLocation: Record "Vendor Location";
        TaxArea: Record "Tax Area";
        PurchSetup: Record "Purchases & Payables Setup";
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";       
        UOMMgt: Codeunit "Unit of Measure Management";
        AddOnIntegrMgt: Codeunit AddOnIntegrManagement;
        DimMgt: Codeunit DimensionManagement;
        ItemReferenceMgt: Codeunit "Item Reference Management";
        CatalogItemMgt: Codeunit "Catalog Item Management";
        LeadTimeMgt: Codeunit "Lead-Time Management";
        CalendarMgmt: Codeunit "Calendar Management";
        CheckDateConflict: Codeunit "Reservation-Check Date Confl.";
        DeferralUtilities: Codeunit "Deferral Utilities";
        PostingSetupMgt: Codeunit PostingSetupManagement;
        NonDeductibleVAT: Codeunit "Non-Deductible VAT";
        items: record Item;
        FieldCausedPriceCalculation: Integer;
        GLSetupRead: Boolean;
        PurchSetupRead: Boolean;

    procedure GetDefaultLineType(): Enum "Purchase Line Type"
    begin
        GetPurchSetup();
        if PurchSetup."Document Default Line Type" <> PurchSetup."Document Default Line Type"::" " then
            exit(PurchSetup."Document Default Line Type");
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetPurchSetup(var PurchaseLine: Record "Budget line"; var PurchSetup: Record "Purchases & Payables Setup")
    begin
    end;
    local procedure GetPurchSetup()
    begin
        if not PurchSetupRead then
            PurchSetup.Get();
        PurchSetupRead := true;

        OnAfterGetPurchSetup(Rec, PurchSetup);
    end;
    procedure GetCaptionClass(FieldNumber: Integer): Text[80]
    var
        PurchLineCaptionClassMgmt: Codeunit "Purch. Line CaptionClass Mgmt";
    begin
       // exit(PurchLineCaptionClassMgmt.GetPurchaseLineCaptionClass(Rec, FieldNumber));
    end;
}
